Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713Ab0ARRuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab0ARRuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715Ab0ARRuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:50:13 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35963 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753673Ab0ARRuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:50:11 -0500
Date: Mon, 18 Jan 2010 17:52:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/64] pata_atiixp: enable parallel scan
Message-ID: <20100118175256.32096b44@lxorguk.ukuu.org.uk>
In-Reply-To: <20100118171447.14623.47438.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
	<20100118171447.14623.47438.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	const struct ata_port_info *ppi[] = { &info, &info };
> +	struct ata_host *host;
> +	int rc;
>  
> -	return ata_pci_sff_init_one(pdev, ppi, &atiixp_sht, NULL);
> +	/* enable device and prepare host */
> +	rc = pcim_enable_device(pdev);
> +	if (rc)
> +		return rc;
> +
> +	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
> +	if (rc)
> +		return rc;
> +
> +	host->flags |= ATA_HOST_PARALLEL_SCAN;
> +
> +	pci_set_master(pdev);
> +
> +	return ata_pci_sff_activate_host(host, ata_sff_interrupt, &atiixp_sht);
>  }

Adding a small essay to each host that activates parallel scan doesn't
make sense. This should be a helper (ignore that if you make it a helper
later in the patch set...)
