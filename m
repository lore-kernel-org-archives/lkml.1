Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbZFBTVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbZFBTVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 15:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbZFBTVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 15:21:31 -0400
Received: from www.tglx.de ([62.245.132.106]:47140 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbZFBTVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 15:21:30 -0400
Date: Tue, 2 Jun 2009 21:14:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Mason <chris.mason@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
In-Reply-To: <20090602141802.GC3914@think>
Message-ID: <alpine.LFD.2.00.0906022100130.3419@localhost.localdomain>
References: <4A0B62F7.5030802@goop.org> <20090525091527.GA7535@elte.hu> <4A1C3805.7060404@goop.org> <20090528061702.GB6920@wotan.suse.de> <20090530102330.GC16913@elte.hu> <20090602141802.GC3914@think>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009, Chris Mason wrote:
> I'm not suggesting we should take broken code, or that we should lower
> standards just for xen.  But, expecting the xen developers to fix the 1%
> hit on a very specific micro-benchmark is not a way to promote new
> projects for the kernel, and it isn't a good way to convince people to
> do continued development in mainline instead of in private trees.
> 
> Please reconsider.  Keeping these patches out is only making it harder
> on the people that want to make them better.

You are missing one subtle point. 

I read several times, that A, B and C can not be changed design wise
to allow newer kernels to run on older hypervisors. That's what
frightens me:

   dom0 imposes a kind of ABI which we can not change anymore. 

So where is the room for the improvements which you expect when dom0
is merged ? It's not about micro benchmark results, it's about the
inability to fix the existing design decisions in the near future.

You can change the internals of btrfs as often as you want, but you
can not change the on disk layout at will. And while you can invent
btrfs2 w/o any impact aside of grumpy users and a couple of thousand
lines self contained code, dom0v2 would just add a different layer of
intrusiveness into the x86 code base w/o removing the existing one.

Thanks,

	tglx
