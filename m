Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbYBRNcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbYBRNcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759608AbYBRNbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:31:43 -0500
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:63416 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759353AbYBRNbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:31:42 -0500
Date: Mon, 18 Feb 2008 14:31:39 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Christian Krafft <krafft@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, parabelboi@bopserverein.de,
       linuxppc-dev@ozlabs.org
Subject: Re: [Patch 2/2] powerpc: i2c-isa: add access check to legacy
 ioports
Message-ID: <20080218143139.1ad6b82f@hyperion.delvare>
In-Reply-To: <20080213183701.254391cc@de.ibm.com>
References: <20080213182800.5c6940a8@de.ibm.com>
	<20080213183701.254391cc@de.ibm.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

On Wed, 13 Feb 2008 18:37:01 +0100, Christian Krafft wrote:
> when probing i2c-pca-isa writes to legacy ioports, which crashes the kernel
> if there is no device at that port.
> This patch adds a check_legacy_ioport call, so probe failes gracefully
> and thus prevents the oops.
> 
> Signed-off-by: Christian Krafft <krafft@de.ibm.com>
> 
> Index: linux.git/drivers/i2c/busses/i2c-pca-isa.c
> ===================================================================
> --- linux.git.orig/drivers/i2c/busses/i2c-pca-isa.c
> +++ linux.git/drivers/i2c/busses/i2c-pca-isa.c
> @@ -125,6 +125,13 @@ static int __devinit pca_isa_probe(struc
>  
>  	dev_info(dev, "i/o base %#08lx. irq %d\n", base, irq);
>  
> +#ifdef CONFIG_PPC_MERGE
> +	if (check_legacy_ioport(base)) {
> +		dev_err(dev, "I/O address %#08lx is not available\n", base);
> +		goto out;
> +	}
> +#endif
> +
>  	if (!request_region(base, IO_SIZE, "i2c-pca-isa")) {
>  		dev_err(dev, "I/O address %#08lx is in use\n", base);
>  		goto out;
> 

I can apply this, no problem. That being said, you might alternatively
just exclude this driver from PPC. It's for a rare device with no known
user, the driver is unmaintained and will hopefully be replaced soon by
a platform driver which will not probe random ports at load time.

-- 
Jean Delvare
