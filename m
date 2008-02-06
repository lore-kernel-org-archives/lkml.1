Return-Path: <linux-kernel-owner+w=401wt.eu-S1763312AbYBFMFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763312AbYBFMFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 07:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762987AbYBFMEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 07:04:42 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:40567 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762974AbYBFMEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 07:04:41 -0500
Message-ID: <47A9A257.5000902@pobox.com>
Date: Wed, 06 Feb 2008 07:04:39 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] ata_piix.c:piix_init_one() must be __devinit
References: <20080130200202.GH29368@does.not.exist>
In-Reply-To: <20080130200202.GH29368@does.not.exist>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch fixes the following section mismatches:
> 
> <--  snip  -->
> 
> ...
> WARNING: drivers/ata/built-in.o(.text+0x15072): Section mismatch in reference from the function piix_init_one() to the function .devinit.text:piix_init_sata_map()
> WARNING: drivers/ata/built-in.o(.text+0x150dd): Section mismatch in reference from the function piix_init_one() to the function .devinit.text:piix_init_pcs()
> WARNING: drivers/ata/built-in.o(.text+0x150e5): Section mismatch in reference from the function piix_init_one() to the function .devinit.text:piix_init_sidpr()
> WARNING: drivers/ata/built-in.o(.text+0x15107): Section mismatch in reference from the function piix_init_one() to the function .devinit.text:piix_check_450nx_errata()
> ...
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 222e97f95d38ce7cb41980671cc4383df28b5f7a 
> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
> index a65c8ae..7a3b9ef 100644
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
> @@ -1595,7 +1595,8 @@ static void piix_iocfg_bit18_quirk(struct pci_dev *pdev)
>   *	Zero on success, or -ERRNO value.
>   */
>  
> -static int piix_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> +static int __devinit piix_init_one(struct pci_dev *pdev,
> +				   const struct pci_device_id *ent)
>  {
>  	static int printed_version;
>  	struct device *dev = &pdev->dev;
> 

applied


