Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbYCKAwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbYCKAwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 20:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbYCKAwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 20:52:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50899 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320AbYCKAwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 20:52:14 -0400
Message-ID: <47D5D7BB.1070206@pobox.com>
Date: Mon, 10 Mar 2008 20:52:11 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Roel Kluin <12o3l@tiscali.nl>
CC: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ATA: logical-bitwise and confusion in ahci_save_initial_config()
References: <47D44BC0.2090906@tiscali.nl>
In-Reply-To: <47D44BC0.2090906@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> logical-bitwise & confusion
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 8a49835..1b73307 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -672,7 +672,7 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
>  		cap &= ~HOST_CAP_NCQ;
>  	}
>  
> -	if ((cap && HOST_CAP_PMP) && (hpriv->flags & AHCI_HFLAG_NO_PMP)) {
> +	if ((cap & HOST_CAP_PMP) && (hpriv->flags & AHCI_HFLAG_NO_PMP)) {
>  		dev_printk(KERN_INFO, &pdev->dev,
>  			   "controller can't do PMP, turning off CAP_PMP\n");
>  		cap &= ~HOST_CAP_PMP;

applied


