Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbZCMJXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbZCMJXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZCMJXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:23:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55182 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbZCMJXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:23:01 -0400
Date: Fri, 13 Mar 2009 10:21:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       trenn@suse.de, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2] x86: mtrr: don't modify RdDram/WrDram bits of fixed
	MTRRs
Message-ID: <20090313092143.GC2571@elte.hu>
References: <20090311150027.GK10490@alberich.amd.com> <20090312163937.GH20716@alberich.amd.com> <20090313015856.GA18760@elte.hu> <20090313090450.GK20716@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313090450.GK20716@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> (1) The patch modifies an old fix from Bernhard Kaindl to get
>     suspend/resume working on some Acer Laptops. Bernhard's patch
>     tried to sync RdMem/WrMem bits of fixed MTRR registers and that
>     helped on those old Laptops. (Don't ask me why -- can't test it
>     myself). But this old problem was not the motivation for the
>     patch. (See http://lkml.org/lkml/2007/4/3/110)
> 
> (2) The more important effect is to fix issues on some more current systems.
> 
>     On those systems Linux panics or just freezes, see
> 
>     http://bugzilla.kernel.org/show_bug.cgi?id=11541
>     (and also duplicates of this bug:
>     http://bugzilla.kernel.org/show_bug.cgi?id=11737
>     http://bugzilla.kernel.org/show_bug.cgi?id=11714)
> 
>     The affected systems boot only using acpi=ht, acpi=off or
>     when the kernel is built with CONFIG_MTRR=n.
> 
>     The acpi options prevent full enablement of ACPI.  Obviously when
>     ACPI is enabled the BIOS/SMM modfies RdMem/WrMem bits.  When
>     CONFIG_MTRR=y Linux also accesses and modifies those bits when it
>     needs to sync fixed-MTRRs across cores (Bernhard's fix, see (1)).
>     How do you synchronize that? You can't. As a consequence Linux
>     shouldn't touch those bits at all (Rationale are AMD's BKDGs which
>     recommend to clear the bit that makes RdMem/WrMem accessible).
>     This is the purpose of this patch. And (so far) this suffices to
>     fix (1) and (2).

thanks - that's excellent info. I've amended the commit log with 
this.

It's still .29.1 material due to the general riskiness of MTRR 
changes - but the merge window will open in 1-2 weeks so it's 
not a 3 months delay.

	Ingo
