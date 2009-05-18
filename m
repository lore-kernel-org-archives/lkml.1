Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbZERCcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbZERCcO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 22:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbZERCbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 22:31:39 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4785 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbZERCbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 22:31:36 -0400
Subject: Re: [PATCH 2/6] drivers/ide: Convert printk(KERN_INFO to pr_info(
From: Joe Perches <joe@perches.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Borislav Petkov <petkovbb@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <3e6c44e2b4365598d80940c292bef91a835ab30d.1242609803.git.joe@perches.com>
References: <cover.1242609803.git.joe@perches.com>
	 <3e6c44e2b4365598d80940c292bef91a835ab30d.1242609803.git.joe@perches.com>
Content-Type: text/plain
Date: Sun, 17 May 2009 19:31:33 -0700
Message-Id: <1242613893.29902.2.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-17 at 19:21 -0700, Joe Perches wrote:
> diff --git a/drivers/ide/aec62xx.c b/drivers/ide/aec62xx.c
> index 878f8ec..d2f9293 100644
> --- a/drivers/ide/aec62xx.c
> +++ b/drivers/ide/aec62xx.c
> @@ -273,8 +273,8 @@ static int __devinit aec62xx_init_one(struct pci_dev *dev, const struct pci_devi
>  		unsigned long dma_base = pci_resource_start(dev, 4);
>  
>  		if (inb(dma_base + 2) & 0x10) {
> -			printk(KERN_INFO DRV_NAME " %s: AEC6880%s card detected"
> -				"\n", pci_name(dev), (idx == 4) ? "R" : "");
> +			pr_info(DRV_NAME " %s: AEC6880%s card detected\n"
> +				pci_name(dev), (idx == 4) ? "R" : "");
>  			d.udma_mask = ATA_UDMA6;
>  		}
>  	}

Sorry, this one is bad.  It's missing a comma between the
end of the format string and pci_name.

I edited it in-place and neglected to remove the backup file.
git send-email sent the corrected patch and the backup file.

The other [patch 2/6] is correct.

