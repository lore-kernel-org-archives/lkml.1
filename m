Return-Path: <linux-kernel-owner+w=401wt.eu-S1031205AbXDZMQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031205AbXDZMQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 08:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031203AbXDZMQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 08:16:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56779 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031201AbXDZMQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 08:16:39 -0400
Date: Thu, 26 Apr 2007 14:15:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>, Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070426121544.GA11487@elte.hu>
References: <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <1177582633.6814.29.camel@johannes.berg> <20070426113525.GA1332@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426113525.GA1332@infradead.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> > The interface isn't even 64/32-bit compatible...
> 
> It's not .  And it's one of the worst interface I've seen lately. Did 
> anyone actually review this crap before it went in?  I completely 
> agree with Linus that these kind of boundaries that lead to horribly 
> complex ioctl interface are totally wrong.

it's a bit hard to see the point of it anyway: the resume binary (much 
of the focus of the ioctls) fundamentally lives as an 'initrd binary' - 
and most of the stuff that wants to execute in an initrd is 
fundamentally tied to the kernel anyway.

Perhaps we should allow "in-kernel userspace" that would be allowed to 
grow ad-hoc interfaces and linking that would only be compatible with 
the kernel they are embedded into: e.g. the klibc stuff in linux/usr/* 
could link to the kernel (via whatever method) and just be in essence 
another type of kernel code - but happening to execute in user-space, 
having access to the normal user-space facilities and being able to link 
to (GPL) user-space libraries. Perhaps this would bridge the "i want to 
tinker in user-space because it's technically easier/cleaner there" and 
"fine but that needs formalized ABIs for your connection to 
kernel-space" gap.

> Now suspend2 wasn't exactly nice either when I last reviewed it, but 
> we should probably give it another attempt if we can sort out a proper 
> incremental merge.

yeah, it still has quite a bit of work left, but it looked fundamentally 
split-uppable.

	Ingo
