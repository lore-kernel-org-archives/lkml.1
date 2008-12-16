Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbYLPUss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbYLPUss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYLPUsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:48:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48492 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbYLPUsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:48:39 -0500
Date: Tue, 16 Dec 2008 21:48:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: make sure we really have an hpet mapping before
	using it
Message-ID: <20081216204829.GD14787@elte.hu>
References: <49481057.2030307@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49481057.2030307@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> When booting in Xen dom0, the hpet isn't really accessible, so make
> sure the mapping is non-NULL before use.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
> arch/x86/kernel/hpet.c |    5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
>
> ===================================================================
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -818,9 +818,10 @@
>
> 		hpet_address = force_hpet_address;
> 		hpet_enable();
> -		if (!hpet_virt_address)
> -			return -ENODEV;
> 	}
> +
> +	if (!hpet_virt_address)
> +		return -ENODEV;

hm, how can hpet_virt_address become non-NULL if hpet_address is zero?

	Ingo
