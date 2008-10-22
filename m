Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbYJVPEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbYJVPEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbYJVPEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:04:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53014 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbYJVPEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:04:30 -0400
Date: Wed, 22 Oct 2008 17:04:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Glauber Costa <glommer@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Max Kellermann <mk@cm4all.com>
Subject: Re: [PATCH -tip] x86: do_boot_cpu - check if we have ESR register
Message-ID: <20081022150416.GF23060@elte.hu>
References: <20081022140009.GA9639@localhost> <20081022141354.GA26372@elte.hu> <20081022141720.GB9639@localhost> <20081022142312.GC26372@elte.hu> <20081022145909.GA7224@elte.hu> <20081022150251.GE9639@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022150251.GE9639@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Ingo Molnar - Wed, Oct 22, 2008 at 04:59:09PM +0200]
> | 
> | > > | > -		apic_write(APIC_ESR, 0);
> | > > | > -		apic_read(APIC_ESR);
> | > > | > +		if (APIC_INTEGRATED(apic_version[phys_apicid])) {
> | > > | > +			apic_write(APIC_ESR, 0);
> | > > | > +			apic_read(APIC_ESR);
> | > > | > +		}
> | 
> | this wouldnt build with certain configs:
> | 
> | arch/x86/kernel/smpboot.c: In function 'do_boot_cpu':
> | arch/x86/kernel/smpboot.c:897: error: 'phys_apicid' undeclared (first use in this function)
> | arch/x86/kernel/smpboot.c:897: error: (Each undeclared identifier is reported only once
> | arch/x86/kernel/smpboot.c:897: error: for each function it appears in.)
> | include/asm/io_32.h: In function 'memcpy_fromio':
> | 
> | because phys_apicid is not available in the !WAKE_SECONDARY_VIA_INIT 
> | case. Changed it to boot_cpu_physical_apicid - that should be good 
> | enough.
> | 
> | 	Ingo
> | 
> 
> Did you fixed it? (oh... actually I've been compilling the patch
> but had this CONFIG turned on and didn't catch this issue)

yeah, fixed it up, dont worry about it.

	Ingo
