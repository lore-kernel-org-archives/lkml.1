Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYHJL5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYHJL5y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 07:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYHJL5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 07:57:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:28115 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbYHJL5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 07:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nKtNl0lXGWS8IvAz8HpWTUjTN8mHFGS4VgRy3eoopTJH9z5nuRlbRnVygwnY8NfaAc
         YXv1mmEXDVLpcTM9DOrj/+1+vI3hW2oUP2n0n6YUFAW9fkzgJSxGhGZ+Wt1KBwpAtcJm
         Iu4te8T24Vvoz887tc4RRtJlJ3vEHtwtnviSE=
Message-ID: <6101e8c40808100457w50a907e5na9f3851f6798a433@mail.gmail.com>
Date: Sun, 10 Aug 2008 13:57:43 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Grant Coady" <gcoady.lk@gmail.com>
Subject: Re: [RFC PATCH] cleanup Serial ATA and Parallel ATA Kconfig try4
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <em9t94trh139dvqdva2tlhu7h3ghsijrbm@4ax.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <njhp94pr4ha1nfgmj11n662enalpd9663h@4ax.com>
	 <alpine.LFD.1.10.0808081911080.3254@localhost.localdomain>
	 <20080809103331.1d475d5c@lxorguk.ukuu.org.uk>
	 <m3zlnm75u1.fsf@maximus.localdomain>
	 <20080809141028.14db9bc7@lxorguk.ukuu.org.uk>
	 <m3skteuhod.fsf@maximus.localdomain>
	 <20080809215918.32f25c4b@lxorguk.ukuu.org.uk>
	 <nifs94lqm5a3qjr3rm2p9mks5tad33cbmi@4ax.com>
	 <cu4t94hi8ei77t57vbmc9am4f2bpsrjtrh@4ax.com>
	 <em9t94trh139dvqdva2tlhu7h3ghsijrbm@4ax.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant!

in ATA_PIIX-s help text is a little "old", and not contained the
ich9/10s "help text"


On 8/10/08, Grant Coady <grant_lkml@dodo.com.au> wrote:
> Hi there,
> Like try3 only the right patch this time, somehow I scrambled try3.
> Grant.
>
> From: Grant Coady <gcoady.lk@gmail.com>
>
> Cleanup ATA Kconfig, this patch replaces earlier RFC patches.
>
> Cleanup ATA Kconfig, hide the SFF option behind new PATA and SATA menu
> items, sort drivers into a single list, add missing "if unsure, say..."
> help text, this version gets the items indented in make menuconfig, some
> inconsistent text resolved, and one long (>80 col) help line split.
>
> Signed-off-by: Grant Coady <gcoady.lk@gmail.com>
>
> ---
>  Kconfig |  592
> +++++++++++++++++++++++++++++++++-------------------------------
>  1 files changed, 311 insertions(+), 281 deletions(-)
>
> --- linux-2.6.27-rc2/drivers/ata/Kconfig	2008-07-14 07:51:29.000000000 +1000
> +++ linux-2.6.27-rc2e/drivers/ata/Kconfig	2008-08-10 18:12:52.495604924
> +1000
> @@ -3,7 +3,7 @@
>  #

[...]

> -config PATA_HPT3X3_DMA
> -	bool "HPT 343/363 DMA support (Experimental)"
> -	depends on PATA_HPT3X3
> +config ATA_PIIX
> +	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
> +	depends on PCI && (ATA_SFF_PATA_SUPPORT || ATA_SFF_SATA)
>  	help
> -	  This option enables DMA support for the HPT343/363
> -	  controllers. Enable with care as there are still some
> -	  problems with DMA on this chipset.
> +	  This option enables support for ICH5/6/7/8 Serial ATA <<--

-->>  This option enables support for ICH5/6/7/8/9/10 Serial ATA<<--

> +	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
> +	  host controllers.
> +
> +	  If unsure, say N.
> +
> +config PATA_MPIIX
> +	tristate "Intel PATA MPIIX support"
> +	depends on ATA_SFF_PATA && PCI
> +	help
> +	  This option enables support for MPIIX PATA support.
> +
> +	  If unsure, say N.

[...]

-- 
Thanks,
Oliver
