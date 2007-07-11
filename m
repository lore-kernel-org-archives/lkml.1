Return-Path: <linux-kernel-owner+w=401wt.eu-S934824AbXGKX3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934824AbXGKX3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932643AbXGKX33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:29:29 -0400
Received: from www.osadl.org ([213.239.205.134]:44265 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765496AbXGKX32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:29:28 -0400
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <alpine.LFD.0.999.0707111558250.20061@woody.linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
	 <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org>
	 <1184191488.12353.160.camel@chaos>
	 <alpine.LFD.0.999.0707111518020.20061@woody.linux-foundation.org>
	 <1184194219.12353.170.camel@chaos>
	 <alpine.LFD.0.999.0707111558250.20061@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 01:29:25 +0200
Message-Id: <1184196565.12353.195.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Wed, 2007-07-11 at 16:07 -0700, Linus Torvalds wrote:
> Why not just fix up the HPET code so that it can be shared *first*. 
> Without the other conversion? Really - What's so wrong with the hpet.c 
> changes in the *absense* of conversion to clockevents? Those changes seem 
> to be totally independent - just abstracting ou tthe 
> "hpet_get_virt_address()" stuff etc.
> 
> None of that has anything to do with clockevents, as far as I can see.
>
> In other words, you now change a i386-only file, and maybe it breaks 
> subtly on i386 as a result. Wouldn't it be nicer to see that breakage as a 
> separate event?

Sure, I meant to do the HPET changes to i386 separate as a preparatory
patch.

Sharing HPET before the conversion is nasty at best (it involves a ton
of ifdeffery at least).

> Then, the x86-64 clockevents code will switch over entirely, but now it 
> switches over to something we can say has gotten testing, and we know the 
> switch-over won't break any 32-bit code, because the switch-over literally 
> didn't change anything at all for that case.

Well, we know that it works on i386, but once we turn on the x64 switch
we have not tested the shared code for x64 yet.

I try to find some practicable compromise between the big bang patch and
the theoretical gradual optimum.

> The same is true of a lot of the APIC timer code. Sure, that patch has the 
> actual conversion in it, and you don't have the cross-architecture issues, 
> but more than 50% of the patch seems to be just cleanup that is 
> independent of the actual switch-over, no?

I said before, that I'm going to split them further.

	tglx


