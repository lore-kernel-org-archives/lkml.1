Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbYJUEUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbYJUEUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 00:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbYJUEU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 00:20:26 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:12928 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbYJUEUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 00:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=N1Qs540dN5OIc7tA7ZW5pW5PqH9iph00E+xoA/6PhBH8eumg/4TL2//uZV+lJZj3q7
         UTGm0wZMC317NM6soZ+WwxKonoyVyGlx0TOPfOJlbAR/MUwQNuhVmkRiBR6JLisuFNWr
         gAyn74cIUdPAJXntNQJux3dksV1ktp6wvQl2s=
Message-ID: <48FD580E.4080101@gmail.com>
Date: Tue, 21 Oct 2008 13:18:22 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Christian Mueller <Christian.Mueller@wdc.com>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [smartmontools-support] inactive SATA drives won't stay in standby
 or sleep, PATA models did. (fwd)
References: <D73D40172004714D95D7A84AC3E68EC802282133@wdscexbe03.sc.wdc.com>	<48EBFE9B.9070503@gmail.com>	<18674.4081.839329.116533@harpo.it.uu.se>	<48F2D9A8.1030502@gmail.com> <18683.50533.786782.474536@harpo.it.uu.se>
In-Reply-To: <18683.50533.786782.474536@harpo.it.uu.se>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mikael.

> --- linux-2.6.27/drivers/ata/sata_promise.c.~1~	2008-07-14 10:22:36.000000000 +0200
> +++ linux-2.6.27/drivers/ata/sata_promise.c	2008-10-20 00:20:58.000000000 +0200
> @@ -153,6 +153,7 @@ static void pdc_freeze(struct ata_port *
>  static void pdc_sata_freeze(struct ata_port *ap);
>  static void pdc_thaw(struct ata_port *ap);
>  static void pdc_sata_thaw(struct ata_port *ap);
> +static int pdc_prereset(struct ata_link *link, unsigned long deadline);
>  static void pdc_error_handler(struct ata_port *ap);
>  static void pdc_post_internal_cmd(struct ata_queued_cmd *qc);
>  static int pdc_pata_cable_detect(struct ata_port *ap);
> @@ -175,6 +176,7 @@ static const struct ata_port_operations 
>  	.sff_irq_clear		= pdc_irq_clear,
>  
>  	.post_internal_cmd	= pdc_post_internal_cmd,
> +	.prereset		= pdc_prereset,
>  	.error_handler		= pdc_error_handler,
>  };
>  
> @@ -691,6 +693,12 @@ static void pdc_sata_thaw(struct ata_por
>  	readl(host_mmio + hotplug_offset); /* flush */
>  }
>  
> +static int pdc_prereset(struct ata_link *link, unsigned long deadline)
> +{
> +	pdc_reset_port(link->ap);

I would put this into ->hardreset itself as the controller can also
get out of sync with reality during reset.  Other than that, looks
like the correct approach.

Thanks.

-- 
tejun
