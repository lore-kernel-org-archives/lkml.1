Return-Path: <linux-kernel-owner+w=401wt.eu-S1752282AbYKXE5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbYKXE5y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 23:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYKXE5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 23:57:44 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:36060 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbYKXE5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 23:57:43 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 23 Nov 2008 20:57:39 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Tejun Heo <htejun@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Miklos Szeredi <miklos@szeredi.hu>,
       arjan@linux.intel.com, Linus Torvalds <torvalds@linux-foundation.org>,
       hch@infradead.org, rminnich@sandia.gov, ericvh@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: poll: allow f_op->poll to sleep, take #3
In-Reply-To: <492A2DBF.3030208@gmail.com>
Message-ID: <alpine.DEB.1.10.0811232054400.29950@alien.or.mcafeemobile.com>
References: <E1L3oK1-0001Pz-J9@pomaz-ex.szeredi.hu> <20081122123942.GF5707@parisc-linux.org> <4927FE87.6050005@gmail.com> <20081122105356.87856d04.akpm@linux-foundation.org> <4928B162.9030404@gmail.com> <alpine.DEB.1.10.0811221831550.19456@alien.or.mcafeemobile.com>
 <20081123085902.GI30453@elte.hu> <49291F06.5040907@gmail.com> <20081123093420.GN30453@elte.hu> <492925B0.9030404@gmail.com> <20081123094551.GQ30453@elte.hu> <492A2DBF.3030208@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2008, Tejun Heo wrote:

> Ingo Molnar wrote:
> >> And @sync might be useful depending on who's waking it up, so we 
> >> either need to change the wake interface or give it an easier way to 
> >> pass those parameters as received.  The callback function isn't the 
> >> right place to ignore those parameters.  It simply doesn't know why 
> >> the caller is passing them in or what they mean under the 
> >> circumstances.
> > 
> > We'll likely eliminate the 'sync' parameter from the scheduler. It's 
> > not a flag that should be proliferated.
> 
> But it's still being used in quite hot paths (pipe, splice, socket)
> and I don't really wanna mix up a change which can cause subtle
> scheduling related performance regression into this patch.  How about
> using the dummy waitqueue hack for now and when removing the @sync
> param, switch it to one of wakeup APIs?  I'll be happy to add big /*
> TODO */ comment in the function.

I was noticing that wake ups on the poll queues do not use sync=1, AFAICS.
So using wake_up_state() and ignoring 'sync' should be fine. And 'key' is 
already ignored by default by default_wake_function().



- Davide


