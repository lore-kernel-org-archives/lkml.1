Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbZBJMOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbZBJMOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 07:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZBJMOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 07:14:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58341 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbZBJMOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 07:14:21 -0500
Date: Tue, 10 Feb 2009 13:14:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Pierre Ossman <drzeus@drzeus.cx>, lkml <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] i8327: fix outb() parameter order
Message-ID: <20090210121404.GB19297@elte.hu>
References: <499138F3.9060903@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499138F3.9060903@ladisch.de>
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


* Clemens Ladisch <clemens@ladisch.de> wrote:

> In i8237A_resume(), when resetting the DMA controller, the parameters to
> dma_outb() were mixed up.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> 
> --- linux-2.6.orig/arch/x86/kernel/i8237.c
> +++ linux-2.6/arch/x86/kernel/i8237.c
> @@ -28,8 +28,8 @@ static int i8237A_resume(struct sys_devi
>  
>  	flags = claim_dma_lock();
>  
> -	dma_outb(DMA1_RESET_REG, 0);
> -	dma_outb(DMA2_RESET_REG, 0);
> +	dma_outb(0, DMA1_RESET_REG);
> +	dma_outb(0, DMA2_RESET_REG);
>  
>  	for (i = 0;i < 8;i++) {
>  		set_dma_addr(i, 0x000000);

Good catch, applied to tip:x86/urgent, thanks!

	Ingo
