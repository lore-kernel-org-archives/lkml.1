Return-Path: <linux-kernel-owner+w=401wt.eu-S965778AbXBOK1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965778AbXBOK1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 05:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965785AbXBOK1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 05:27:51 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42354 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965778AbXBOK1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 05:27:50 -0500
Date: Thu, 15 Feb 2007 02:27:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: minyard@acm.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/4] ipmi: add pci remove handling
Message-Id: <20070215022745.648ab8cb.akpm@linux-foundation.org>
In-Reply-To: <20070214200624.GC5364@localdomain>
References: <20070214200624.GC5364@localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007 14:06:24 -0600 Corey Minyard <minyard@acm.org> wrote:

> Add pci_remove handling to the driver, so it will clean up if
> the device is hot-removed.
> 
> Signed-off-by: Corey Minyard <minyard@acm.org>
> 
> Index: linux-2.6.19/drivers/char/ipmi/ipmi_si_intf.c
> ===================================================================
> --- linux-2.6.19.orig/drivers/char/ipmi/ipmi_si_intf.c
> +++ linux-2.6.19/drivers/char/ipmi/ipmi_si_intf.c
> @@ -2191,12 +2191,15 @@ static int __devinit ipmi_pci_probe(stru
>  		info->irq_setup = std_irq_setup;
>  
>  	info->dev = &pdev->dev;
> +	pdev->dev->driver_data = info;
>  
>  	return try_smi_init(info);
>  }
>  
>  static void __devexit ipmi_pci_remove(struct pci_dev *pdev)
>  {
> +	struct smi_info *info = pdev->dev->driver_data;
> +	cleanup_one_si(info);
>  }

drivers/char/ipmi/ipmi_si_intf.c: In function 'ipmi_pci_probe':
drivers/char/ipmi/ipmi_si_intf.c:2192: error: invalid type argument of '->'
drivers/char/ipmi/ipmi_si_intf.c: In function 'ipmi_pci_remove':
drivers/char/ipmi/ipmi_si_intf.c:2199: error: invalid type argument of '->'

Judging from the patch headers you were working against 2.6.19, which is
most optimistic.  Please always prepare and test patches against the
latest kernel.
