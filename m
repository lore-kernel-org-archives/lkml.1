Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbZHMDqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbZHMDqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 23:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZHMDqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 23:46:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58261
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655AbZHMDqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 23:46:11 -0400
Date: Wed, 12 Aug 2009 20:46:21 -0700 (PDT)
Message-Id: <20090812.204621.87530668.davem@davemloft.net>
To: dfeng@redhat.com
Cc: john.ronciak@intel.com, peter.p.waskiewicz.jr@intel.com,
       bruce.w.allan@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] e1000e: fix use of pci_enable_pcie_error_reporting
From: David Miller <davem@davemloft.net>
In-Reply-To: <1249637774-32419-1-git-send-email-dfeng@redhat.com>
References: <1249637774-32419-1-git-send-email-dfeng@redhat.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaotian Feng <dfeng@redhat.com>
Date: Fri,  7 Aug 2009 17:36:14 +0800

> commit 111b9dc5 introduces pcie aer support for e1000e, but it is not
> reasonable to disable it in e1000_remove but enable it in e1000_resume.
> This patch enables aer support in e1000_probe.
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>

In moving this block of code, you've corrupted the indentation,
making it more indented than it should be.

In any event, I expect the Intel folks to pick this up.

> diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
> index 63415bb..e2f0304 100644
> --- a/drivers/net/e1000e/netdev.c
> +++ b/drivers/net/e1000e/netdev.c
> @@ -4670,14 +4670,6 @@ static int e1000_resume(struct pci_dev *pdev)
>  		return err;
>  	}
>  
> -	/* AER (Advanced Error Reporting) hooks */
> -	err = pci_enable_pcie_error_reporting(pdev);
> -	if (err) {
> -		dev_err(&pdev->dev, "pci_enable_pcie_error_reporting failed "
> -		                    "0x%x\n", err);
> -		/* non-fatal, continue */
> -	}
> -
>  	pci_set_master(pdev);
>  
>  	pci_enable_wake(pdev, PCI_D3hot, 0);
> @@ -4990,6 +4982,14 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
>  	if (err)
>  		goto err_pci_reg;
>  
> +        /* AER (Advanced Error Reporting) hooks */
> +        err = pci_enable_pcie_error_reporting(pdev);
> +        if (err) {
> +                dev_err(&pdev->dev, "pci_enable_pcie_error_reporting failed "
> +                                    "0x%x\n", err);
> +                /* non-fatal, continue */
> +        }
> +
>  	pci_set_master(pdev);
>  	/* PCI config space info */
>  	err = pci_save_state(pdev);
> -- 
> 1.6.2.5
> 
