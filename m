Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbYJVOX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbYJVOX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYJVOXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:23:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36194 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbYJVOXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:23:19 -0400
Date: Wed, 22 Oct 2008 16:23:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Glauber Costa <glommer@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Max Kellermann <mk@cm4all.com>
Subject: Re: [PATCH -tip] x86: do_boot_cpu - check if we have ESR register
Message-ID: <20081022142312.GC26372@elte.hu>
References: <20081022140009.GA9639@localhost> <20081022141354.GA26372@elte.hu> <20081022141720.GB9639@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022141720.GB9639@localhost>
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

> | > -		apic_write(APIC_ESR, 0);
> | > -		apic_read(APIC_ESR);
> | > +		if (APIC_INTEGRATED(apic_version[phys_apicid])) {
> | > +			apic_write(APIC_ESR, 0);
> | > +			apic_read(APIC_ESR);
> | > +		}
> | 
> | i'm wondering - is the server there really that old, that it has no 
> | integrated lapic? I.e. it's an i486 SMP box or so? Or perhaps some 
> | other, weird SMP box?
> | 
> | 	Ingo
> | 
> 
> I was quite wondering too -- it's Xeon server.
> 
> >From http://lkml.org/lkml/2008/10/20/34
> >> Hardware: Compaq P4 Xeon server, Broadcom CMIC-WS / CIOB-X2 board.
> >> Tell me if you need more detailed information.

ah, Compaq - how many CPUs does that box support? If it's 8 or more then 
perhaps they turned off the real local APIC, fudged some chipset glue to 
emulate APIC functionality and thus were able to use 8 or more of these 
chips? The built-in lapic would only go up to 4 CPUs. (or maybe even 
just up to dual, depending on the model)

This reminds us that all the is-integrated-lapic checks still matter 
today.

	Ingo
