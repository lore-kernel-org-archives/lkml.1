Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbZCSPvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbZCSPvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 11:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZCSPvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 11:51:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41235 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbZCSPvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 11:51:00 -0400
Date: Thu, 19 Mar 2009 16:49:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christopher Schramm <debian@shakaweb.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: APIC problem report
Message-ID: <20090319154955.GA21034@elte.hu>
References: <49C1FE7D.9070605@shakaweb.org> <20090319100122.GA30358@elte.hu> <49C25712.9010509@shakaweb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C25712.9010509@shakaweb.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christopher Schramm <debian@shakaweb.org> wrote:

> Thanks for the quick replay, Ingo!
>
> Following your request, I installed Debian 5.0. Had to use noapic 
> again for getting the boot media to work (think it utilizes 
> 2.6.26).
>
> The kernel panic is the same for all three systems: "not syncing: 
> IO-APIC + timer doesn't work!".
>
> The installed system had the same problem (2.6.26 again), then I 
> compiled 2.6.28.8 (with default config). Booting that one with 
> APIC enabled throws the known "MP-BIOS bug" message, but then 
> continues booting - no kernel panic.
>
> I will try Knoppix' kernel config and your git code, when I find 
> some spare time.

By the looks of it, chances are that various APIC fixes and 
robustization patches might have fixed your problem:

 691874f: x86: I/O APIC: timer through 8259A second-chance
 03be750: x86: I/O APIC: keep the timer IRQ masked during set-up
 24742ec: x86: I/O APIC: unmask the second-chance timer interrupt
 d11d579: x86: I/O APIC: AEOI timer acknowledgement clean-ups

These first showed up in v2.6.27. Which would match your reported 
symptoms of v2.6.26 failig and 2.6.28 working. The bootup warning
about a BIOS problem is still there because there is an underlying 
problem - we just work it around and fall back more robustly.

	Ingo
