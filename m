Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbZIOUjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbZIOUjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 16:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbZIOUjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 16:39:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:23623 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbZIOUjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 16:39:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=nv+Du9N5s9KzocSAXHXCucdioFkKgDeE7o0jne9TSKLWM8rl/ZcrMwkuLnGoJ0gMuW
         r9LwY9Gm7grNaUYEHSBG8SKAchuMsO5CLO8WSlKSHMlXUVWAkIdct1mCNndU8prVmnG/
         4IIPts+N74aw7jXDKvVW/E2mqFlzxfc+e5hW4=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Steve Chen <schen@mvista.com>
Subject: Re: [PATCH] arm: remove unused code in delay.S
Date: Tue, 15 Sep 2009 22:39:19 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.30-1-amd64; KDE/4.3.1; x86_64; ; )
Cc: Felipe Contreras <felipe.contreras@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Jamie Lokier <jamie@shareable.org>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com> <94a0d4530909151158y489a96e3x63ff932c713822b0@mail.gmail.com> <1253043875.3273.131.camel@linux-1lbu>
In-Reply-To: <1253043875.3273.131.camel@linux-1lbu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909152239.19543.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Út 15. září 2009 21:44:35 Steve Chen napsal(a):
> Felipe,
> 
> Here is the updated patch.  If you don't mind add your signed-off, I can
> submit the patch.

Do you guys really have so much free time on your hands to argue about this? 
btw. here's my nitpick then -- 'accurate delays' is really bad way to call it 
;-)
> 
> Regards,
> 
> Steve
> 
> Document #if 0 code block in delay.S and make it selectable for compile.
> 
> Signed-off-by: Steve Chen <schen@mvista.com>
> 
> ---
> 
>  arch/arm/Kconfig     |    8 ++++++++
>  arch/arm/lib/delay.S |    2 +-
>  2 files changed, 9 insertions(+), 1 deletions(-)
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
> +	bool "Accurate delays"
> +	def_bool n
> +	help
> +	  Enable if observing longer than expected delays and need more
> +	  accuracy.  This only applies to older CPUs.
> +
>  endmenu
> 
>  source "arch/arm/common/Kconfig"
> diff --git a/arch/arm/lib/delay.S b/arch/arm/lib/delay.S
> index 8d6a876..67e679b 100644
> --- a/arch/arm/lib/delay.S
> +++ b/arch/arm/lib/delay.S
> @@ -42,7 +42,7 @@ ENTRY(__const_udelay)				@ 0 <= r0 <= 0x7fffff06
>  @ Delay routine
>  ENTRY(__delay)
>  		subs	r0, r0, #1
> -#if 0
> +#ifdef CONFIG_OLD_CPU_DELAY
>  		movls	pc, lr
>  		subs	r0, r0, #1
>  		movls	pc, lr
> 
