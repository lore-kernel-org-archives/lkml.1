Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbYKXEaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbYKXEaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 23:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbYKXEaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 23:30:00 -0500
Received: from mail-gx0-f29.google.com ([209.85.217.29]:46332 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYKXE37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 23:29:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=q699L5zBsBeVDmnmgDKymeu/iI1AjpnHRsl5RNGKwNAGB3OgFnKKja2SkJRUprYiNV
         sqV8KarbH+dkMlzLY6WVzCe32Nyiz5kdpovtQl2HuWeySIOVZufQpCWYJQS0JZGKcvCQ
         l6VXr1lEIHEbxP1DoeeyDroayOWu1DH48O9JU=
Message-ID: <492A2DBF.3030208@gmail.com>
Date: Mon, 24 Nov 2008 13:29:51 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Miklos Szeredi <miklos@szeredi.hu>,
       arjan@linux.intel.com, Linus Torvalds <torvalds@linux-foundation.org>,
       hch@infradead.org, rminnich@sandia.gov, ericvh@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: poll: allow f_op->poll to sleep, take #3
References: <E1L3oK1-0001Pz-J9@pomaz-ex.szeredi.hu> <20081122123942.GF5707@parisc-linux.org> <4927FE87.6050005@gmail.com> <20081122105356.87856d04.akpm@linux-foundation.org> <4928B162.9030404@gmail.com> <alpine.DEB.1.10.0811221831550.19456@alien.or.mcafeemobile.com> <20081123085902.GI30453@elte.hu> <49291F06.5040907@gmail.com> <20081123093420.GN30453@elte.hu> <492925B0.9030404@gmail.com> <20081123094551.GQ30453@elte.hu>
In-Reply-To: <20081123094551.GQ30453@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> And @sync might be useful depending on who's waking it up, so we 
>> either need to change the wake interface or give it an easier way to 
>> pass those parameters as received.  The callback function isn't the 
>> right place to ignore those parameters.  It simply doesn't know why 
>> the caller is passing them in or what they mean under the 
>> circumstances.
> 
> We'll likely eliminate the 'sync' parameter from the scheduler. It's 
> not a flag that should be proliferated.

But it's still being used in quite hot paths (pipe, splice, socket)
and I don't really wanna mix up a change which can cause subtle
scheduling related performance regression into this patch.  How about
using the dummy waitqueue hack for now and when removing the @sync
param, switch it to one of wakeup APIs?  I'll be happy to add big /*
TODO */ comment in the function.

Thanks.

-- 
tejun
