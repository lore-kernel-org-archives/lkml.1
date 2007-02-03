Return-Path: <linux-kernel-owner+w=401wt.eu-S1750863AbXBCKT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750863AbXBCKT3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 05:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbXBCKT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 05:19:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57373 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbXBCKT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 05:19:28 -0500
Date: Sat, 3 Feb 2007 11:03:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070203100351.GA30262@elte.hu>
References: <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org> <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021445410.15057@woody.linux-foundation.org> <20070202235531.GA18904@elte.hu> <Pine.LNX.4.64.0702021636410.15057@woody.linux-foundation.org> <20070203082308.GA6748@elte.hu> <20070203092540.GH16722@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070203092540.GH16722@waste.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4263]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Mackall <mpm@selenic.com> wrote:

> On Sat, Feb 03, 2007 at 09:23:08AM +0100, Ingo Molnar wrote:
> > The normal and most optimal workflow should be a user-space ring-buffer 
> > of these constant-size struct async_syscall entries:
> > 
> >   struct async_syscall ringbuffer[1024];
> > 
> >   LIST_HEAD(submitted);
> >   LIST_HEAD(pending);
> >   LIST_HEAD(completed);
> 
> It's wrong to call this a ring buffer as things won't be completed in
> any particular order. [...]

yeah, i realized this when i sent the mail. I wanted to say 'array of 
elements' - and it's clear from these list heads that it's fully out of 
order. (it should be an array so that the pages of those entries can be 
pinned and that completion can be manipulated from any context, 
anytime.)

(the queueing i described closely resembles Tux's "Tux syscall request" 
handling scheme.)

> [...] So you'll need a fourth list head for which buffer elements are 
> free. At which point, you might as well leave it entirely up to the 
> application to manage the allocation of async_syscall structs. It may 
> know it only needs two, or ten thousand, or five per client...

sure - it should be variable but still the array should be compact, and 
should be registered with the kernel. That way security checks can be 
done once, the pages can be pinned, accessed anytime, etc.

	Ingo
