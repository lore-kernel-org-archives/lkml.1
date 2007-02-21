Return-Path: <linux-kernel-owner+w=401wt.eu-S1423150AbXBUVcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423150AbXBUVcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423152AbXBUVcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:32:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35066 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423151AbXBUVcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:32:22 -0500
Date: Wed, 21 Feb 2007 21:32:21 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Prarit Bhargava <prarit@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@pol.net
Subject: Re: [PATCH]: change rivafb_remove to __devexit
In-Reply-To: <20070220161306.23688.53776.sendpatchset@prarit.boston.redhat.com>
Message-ID: <Pine.LNX.4.64.0702212131530.20620@pentafluge.infradead.org>
References: <20070220161306.23688.53776.sendpatchset@prarit.boston.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-By: James Simmons <jsimmons@infradead.org>

On Tue, 20 Feb 2007, Prarit Bhargava wrote:

> Resubmitting with wider audience (akpm & lkml).
> 
> Change rivafb_remove to __deviexit to fix MODPOST warnings:
> 
> WARNING: drivers/video/riva/rivafb.o - Section mismatch: reference to
> .exit.text:rivafb_remove from .data.rel.local after 'rivafb_driver' (at offset 0x28)
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> 
> --- linux-2.6.19.ia64.orig/drivers/video/riva/fbdev.c	2007-02-07 09:56:37.000000000 -0500
> +++ linux-2.6.19.ia64/drivers/video/riva/fbdev.c	2007-02-08 11:39:35.000000000 -0500
> @@ -2154,7 +2154,7 @@ err_ret:
>  	return ret;
>  }
>  
> -static void __exit rivafb_remove(struct pci_dev *pd)
> +static void __devexit rivafb_remove(struct pci_dev *pd)
>  {
>  	struct fb_info *info = pci_get_drvdata(pd);
>  	struct riva_par *par = info->par;
> @@ -2232,7 +2232,7 @@ static struct pci_driver rivafb_driver =
>  	.name		= "rivafb",
>  	.id_table	= rivafb_pci_tbl,
>  	.probe		= rivafb_probe,
> -	.remove		= __exit_p(rivafb_remove),
> +	.remove		= __devexit_p(rivafb_remove),
>  };
>  
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
