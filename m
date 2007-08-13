Return-Path: <linux-kernel-owner+w=401wt.eu-S972198AbXHMMja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972198AbXHMMja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940827AbXHMHNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:13:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:48872 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940815AbXHMHNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:13:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Dq7XYOKIR4pvMpV2O5us+W7eXBbzIPyZ+P7GrvqmIBXbVWtsXR67IGXwEDdvhIsU2CLxuhVYFfr6HLCXaOaLTpD1R4c4iJlKSJermoD1mxhHglMWaqaRxHElRBIsg6gty5EGFFMWsfwWCPEwa45QnUFoJupcdXSkABUIluOnGkU=
Message-ID: <4bacf17f0708130013m67dcf91fx7136d0050aa08b82@mail.gmail.com>
Date: Mon, 13 Aug 2007 09:13:50 +0200
From: "=?ISO-8859-2?Q?Marcin_=A6lusarz?=" <marcin.slusarz@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.23-rc2: WARNING: at kernel/irq/resend.c:70 check_irq_resend()
Cc: "Jarek Poplawski" <jarkao2@o2.pl>, "Thomas Gleixner" <tglx@linutronix.de>,
       "John Stoffel" <john@stoffel.org>, linux-kernel@vger.kernel.org,
       shemminger@linux-foundation.org, vignaud@xandmail.fr,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-net@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20070810101641.GA31396@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18107.11431.838905.331157@stoffel.org>
	 <1186733140.12828.45.camel@chaos> <20070810082346.GD1764@ff.dom.local>
	 <20070810083050.GA4545@elte.hu> <20070810084924.GF1764@ff.dom.local>
	 <20070810085611.GA11639@elte.hu> <20070810091231.GH1764@ff.dom.local>
	 <20070810093353.GA19777@elte.hu> <20070810100513.GA3279@ff.dom.local>
	 <20070810101641.GA31396@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/8/10, Ingo Molnar <mingo@elte.hu>:
> Index: linux/arch/i386/kernel/io_apic.c
> ===================================================================
> --- linux.orig/arch/i386/kernel/io_apic.c
> +++ linux/arch/i386/kernel/io_apic.c
> @@ -735,7 +735,8 @@ void fastcall send_IPI_self(int vector)
>          * Wait for idle.
>          */
>         apic_wait_icr_idle();
> -       cfg = APIC_DM_FIXED | APIC_DEST_SELF | vector | APIC_DEST_LOGICAL;
> +       cfg = APIC_DM_FIXED | APIC_DEST_SELF | vector | APIC_DEST_LOGICAL |
> +               APIC_INT_LEVELTRIG;
>         /*
>          * Send the IPI. The write to APIC_ICR fires this off.
>          */
> Index: linux/arch/x86_64/kernel/genapic.c
> ===================================================================
> --- linux.orig/arch/x86_64/kernel/genapic.c
> +++ linux/arch/x86_64/kernel/genapic.c
> @@ -62,5 +62,6 @@ void __init setup_apic_routing(void)
>
>  void send_IPI_self(int vector)
>  {
> -       __send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
> +       __send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL |
> +                           APIC_INT_LEVELTRIG);
>  }
>
network card timed out as usual ;)

Marcin
