Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbZIONli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbZIONli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 09:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbZIONld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 09:41:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:45304 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZIONlc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:41:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=B+KQ+9jDj4hRbQNESkx+GK0aMcWOZIvaGu7KC6Ziz3xerSjdZM0ctCI+T3DJXZCUDN
         T4s0Lu3YPEJPf3+z7fw7IMgmQvEUNTNt+Q5dYcHL+XYa7+WLOo6A9dTES5gM5ql6lH4o
         n01MYzZ6Iv2gaToPW2Mpa+CKx2IoVvyIfCGgU=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Steve Chen <schen@mvista.com>
Subject: Re: [PATCH] arm: remove unused code in delay.S
Date: Tue, 15 Sep 2009 15:41:08 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.30-1-amd64; KDE/4.3.1; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Felipe Contreras <felipe.contreras@gmail.com>,
       Jamie Lokier <jamie@shareable.org>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com> <20090915103739.GA19519@elf.ucw.cz> <1253017761.3273.117.camel@linux-1lbu>
In-Reply-To: <1253017761.3273.117.camel@linux-1lbu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909151541.08852.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Út 15. září 2009 14:29:21 Steve Chen napsal(a):
> On Tue, 2009-09-15 at 12:37 +0200, Pavel Machek wrote:
> > > >> > Because then you get it whenever you configure for V4 as the
> > > >> > lowest denominator CPU, which leads to the buggy behaviour on
> > > >> > better CPUs. It's far better to leave it as is and just accept
> > > >> > that the old CPUs will have longer than necessary delays.  If
> > > >> > people really really care (and there's likely to only be a small
> > > >> > minority of them now) changing the '0' to a '1' is a very simple
> > > >> > change for them to carry in their local tree.  Unlike getting the
> > > >> > right unrolling etc.
> > > >>
> > > >> Well, they can also 'git revert' this patch. If somebody really
> > > >> cares I think they should shout now and provide a better patch,
> > > >> otherwise this one should be merged.
> > > >
> > > > On the other hand, having the code there as it currently stands is
> > > > not harmful in any way, so leaving it there is just as easy.
> > >
> > > It makes the code less understandable. I'm not sure about linux's
> > > practices, but an #if 0 generally means somebody is being lazy.
> >
> > Not in this case, as you was explained to you. You may want to add
> > explaining comment above #if 0....
> > 								Pavel
> 
> Perhaps we can document with something like..
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index aef63c8..ca8d535 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -813,6 +813,14 @@ config ARM_ERRATA_460075
>  	  ACTLR register. Note that setting specific bits in the ACTLR
> register
>  	  may not be available in non-secure mode.
> 
> +config OLD_CPU_DELAY
> +	depends on CPU_32v3 || CPU_32v4 || CPU_32v4T
> +	bool "Accurate delays for older CPU"
> +	def_bool n
> +	help
> +	  Enable if observing longer than expected delays and need more
> +	  accurate delays on older CPUs.
> +
>  endmenu
> 
>  source "arch/arm/common/Kconfig"
> diff --git a/arch/arm/lib/delay.S b/arch/arm/lib/delay.S
> index 8d6a876..8b3fa63 100644
> --- a/arch/arm/lib/delay.S
> +++ b/arch/arm/lib/delay.S
> @@ -42,7 +42,7 @@ ENTRY(__const_udelay)				@ 0 <= r0 <= 0x7fffff06
>  @ Delay routine
>  ENTRY(__delay)
>  		subs	r0, r0, #1
> -#if 0
> +#if CONFIG_OLD_CPU_DELAY

ifdef please

>  		movls	pc, lr
>  		subs	r0, r0, #1
>  		movls	pc, lr
> 
