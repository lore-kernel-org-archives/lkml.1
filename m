Return-Path: <linux-kernel-owner+w=401wt.eu-S1757015AbYFCKzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbYFCKzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbYFCKzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:55:33 -0400
Received: from www.tglx.de ([62.245.132.106]:37319 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbYFCKzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:55:32 -0400
Date: Tue, 3 Jun 2008 12:55:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Olaf Dabrunz <od@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>,
       LKML <linux-kernel@vger.kernel.org>, Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 6/7] disable pci legacy boot irq quirks on noapic boot
In-Reply-To: <12124107071424-git-send-email-od@suse.de>
Message-ID: <alpine.LFD.1.10.0806031254110.3235@apollo.tec.linutronix.de>
References: <12124107071847-git-send-email-od@suse.de> <12124107071424-git-send-email-od@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008, Olaf Dabrunz wrote:

> From: Stefan Assmann <sassmann@suse.de>
> 
> Don't enable pci boot irq quirks when falling back to pic, this would
> break interrupt routing.
> 
> Signed-off-by: Stefan Assmann <sassmann@suse.de>
> Signed-off-by: Olaf Dabrunz <od@suse.de>
> ---
>  include/asm-x86/io_apic.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-x86/io_apic.h b/include/asm-x86/io_apic.h
> index 5b1292f..461771c 100644
> --- a/include/asm-x86/io_apic.h
> +++ b/include/asm-x86/io_apic.h
> @@ -151,8 +151,11 @@ extern int skip_ioapic_setup;
>  /* 1 if the timer IRQ uses the '8259A Virtual Wire' mode */
>  extern int timer_through_8259;
>  
> +extern int nobootirqquirk;
> +

declarations in headers please.

>  static inline void disable_ioapic_setup(void)
>  {
> +	nobootirqquirk = 1;

This logic needs to be default disabled anyway.

>  	skip_ioapic_setup = 1;
>  }
>  
> -- 
> 1.5.2.4
> 
> -- 
> Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, N??rnberg
> 
