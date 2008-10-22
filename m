Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbYJVOPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbYJVOPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYJVOOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:14:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57850 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbYJVOOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:14:12 -0400
Date: Wed, 22 Oct 2008 16:13:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Glauber Costa <glommer@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH -tip] x86: do_boot_cpu - check if we have ESR register
Message-ID: <20081022141354.GA26372@elte.hu>
References: <20081022140009.GA9639@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022140009.GA9639@localhost>
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

> We should touch ESR register if only we have it.
> The patch fixes the problem mentoined here
> 
> 	http://lkml.org/lkml/2008/10/17/147
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> CC: Glauber Costa <glommer@gmail.com>

> -		apic_write(APIC_ESR, 0);
> -		apic_read(APIC_ESR);
> +		if (APIC_INTEGRATED(apic_version[phys_apicid])) {
> +			apic_write(APIC_ESR, 0);
> +			apic_read(APIC_ESR);
> +		}

i'm wondering - is the server there really that old, that it has no 
integrated lapic? I.e. it's an i486 SMP box or so? Or perhaps some 
other, weird SMP box?

	Ingo
