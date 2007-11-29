Return-Path: <linux-kernel-owner+w=401wt.eu-S933112AbXK2To6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbXK2To6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757719AbXK2Top
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:44:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34787 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757325AbXK2Too (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:44:44 -0500
Date: Thu, 29 Nov 2007 20:44:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, zach@vmware.com
Subject: Re: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current task
Message-ID: <20071129194416.GB15245@elte.hu>
References: <20071129003849.428E026F8E7@magilla.localdomain> <20071129004222.E49AD26F8E7@magilla.localdomain> <474EF824.3020806@redhat.com> <alpine.LFD.0.9999.0711290958110.8458@woody.linux-foundation.org> <474F01F6.2030509@zytor.com> <alpine.LFD.0.9999.0711291027070.8458@woody.linux-foundation.org> <474F08E1.2090806@zytor.com> <alpine.LFD.0.9999.0711291057320.8458@woody.linux-foundation.org> <474F1027.2020801@zytor.com> <20071129192721.GP24223@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129192721.GP24223@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> For i386 iirc Jeremy/Zach did the benchmarking and they settled on %fs 
> because it was faster for something (originally it was %gs too)

yep. IIRC, some CPUs only optimize %fs because that's what Windows uses 
and leaves Linux with %gs out in the cold. There's also a performance 
penalty for overlapping segment use, if the segment cache is single 
entry only with an additional optimization for NULL [which just hides 
the segment cache].

But if it's good for unification we could switch that to %gs again on 
32-bit. I was one of the people who advocated the use of the 'other' 
segment register, so that the hardware has less overlap, but clean and 
unified code trumps this concern. It shouldnt be an issue on reasonably 
modern CPUs anyway.

	Ingo
