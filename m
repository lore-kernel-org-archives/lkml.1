Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbXK3Uoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbXK3Uoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 15:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbXK3UoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 15:44:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56552 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbXK3UoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 15:44:18 -0500
Date: Fri, 30 Nov 2007 21:43:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 0/3] Per cpu relocation to ZERO and x86_32 percpu ops
	on x86_64
Message-ID: <20071130204355.GA31865@elte.hu>
References: <20071130112429.GA3605@elte.hu> <20071130112645.GA7565@elte.hu> <Pine.LNX.4.64.0711300918250.32294@schroedinger.engr.sgi.com> <20071130180002.GB19571@elte.hu> <Pine.LNX.4.64.0711301019590.1743@schroedinger.engr.sgi.com> <20071130183512.GA8985@elte.hu> <Pine.LNX.4.64.0711301043380.1919@schroedinger.engr.sgi.com> <20071130194517.GD9928@elte.hu> <Pine.LNX.4.64.0711301147100.2242@schroedinger.engr.sgi.com> <20071130202622.GA15006@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130202622.GA15006@elte.hu>
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


btw., this is the list of patches i've picked up for testing:

modules-include-sectionsh-to-avoid-defining-linker-variables.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch

percpu1-percpu-use-a-kconfig-variable-to-signal-arch-specific-percpu-setup.patch
percpu1-percpu-move-arch-xx-per-cpu-xx-definitions-into-linux-percpu-h.patch
percpu1-percpu-make-the-asm-generic-percpu-h-more-generic-.patch
percpu1-x86-32-use-generic-percpu-h.patch
percpu1-x86-64-use-generic-percpu.patch
percpu1-s390-use-generic-percpu.patch
percpu1-powerpc-use-generic-per-cpu.patch
percpu1-sparc64-use-generic-percpu.patch
percpu1-ia64-use-generic-percpu.patch
percpu1-x86-unify-percpu-h.patch

percpu2-percpu-infrastructure-to-rebase-the-per-cpu-area-to-0ul.patch
percpu2-x86-64-declare-pda-as-per-cpu-data-thereby-moving-it-into-the-cpu-area.patch
percpu2-x86-64-make-the-x86-32-percpu-operations-usable-on-x86-64.patch

the first 3 are from -mm, the rest from lkml. This series applied 
cleanly without any rejects but i still got the spontaneous reboot 
during bootup on UP 32-bit x86.

So either i'm still missing some essential patch, or this tree somehow 
triggers the problem more likely than in -mm. I've bisected it down to:

 percpu1-percpu-move-arch-xx-per-cpu-xx-definitions-into-linux-percpu-h.patch

that patch looks harmless though. Anyway, we can certainly revisit this 
issue after you get back on Dec 13th.

	Ingo
