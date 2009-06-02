Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbZFBOPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbZFBOPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbZFBOO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:14:58 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:46650 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbZFBOOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:14:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ehF1YSfaxhCsN2aT85n4DkzeQgpuAVYTL+MwA72GIWuzhk7CPaZPYborPA9M3f43DP
         AyzFFx9+j3hLf1EWnnDVdBFoUcaovd2UAqRV0UaXVkcShnXtxC69KXmKMIuf+IuqUJfv
         uMJQXvWUmrTziV3NZSIaJmXgfFp90r1ZN+RxI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/3] drivers/ide/ide-core: Convert printk(KERN_<level> to pr_<level>
Date: Tue, 2 Jun 2009 16:02:42 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090522-05935-g4d19128; KDE/4.2.3; i686; ; )
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, Tejun Heo <tj@kernel.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1243062772.git.joe@perches.com> <ad29856101ea7fec73e2df4fd09708c55afb989a.1243062772.git.joe@perches.com>
In-Reply-To: <ad29856101ea7fec73e2df4fd09708c55afb989a.1243062772.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906021602.42848.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 May 2009 09:41:14 Joe Perches wrote:

> --- a/drivers/ide/setup-pci.c
> +++ b/drivers/ide/setup-pci.c
> @@ -39,18 +39,18 @@ static int ide_setup_pci_baseregs(struct pci_dev *dev, const char *name)
>  	if (pci_read_config_byte(dev, PCI_CLASS_PROG, &progif) ||
>  			 (progif & 5) != 5) {
>  		if ((progif & 0xa) != 0xa) {
> -			printk(KERN_INFO "%s %s: device not capable of full "
> +			pr_info("%s %s: device not capable of full "
>  				"native PCI mode\n", name, pci_name(dev));
>  			return -EOPNOTSUPP;
>  		}
> -		printk(KERN_INFO "%s %s: placing both ports into native PCI "
> +		pr_info("%s %s: placing both ports into native PCI "
>  			"mode\n", name, pci_name(dev));
>  		(void) pci_write_config_byte(dev, PCI_CLASS_PROG, progif|5);
>  		if (pci_read_config_byte(dev, PCI_CLASS_PROG, &progif) ||
>  		    (progif & 5) != 5) {
> -			printk(KERN_ERR "%s %s: rewrite of PROGIF failed, "
> -				"wanted 0x%04x, got 0x%04x\n",
> -				name, pci_name(dev), progif | 5, progif);
> +			pr_err("%s %s: rewrite of PROGIF failed, "
> +			       "wanted 0x%04x, got 0x%04x\n",
> +			       name, pci_name(dev), progif | 5, progif);
>  			return -EOPNOTSUPP;
>  		}
>  	}
> @@ -92,8 +92,8 @@ unsigned long ide_pci_dma_base(ide_hwif_t *hwif, const struct ide_port_info *d)
>  		dma_base = pci_resource_start(dev, baridx);
>  
>  		if (dma_base == 0) {
> -			printk(KERN_ERR "%s %s: DMA base is invalid\n",
> -				d->name, pci_name(dev));
> +			pr_err("%s %s: DMA base is invalid\n",
> +			       d->name, pci_name(dev));
>  			return 0;
>  		}
>  	}
> @@ -115,7 +115,7 @@ int ide_pci_check_simplex(ide_hwif_t *hwif, const struct ide_port_info *d)
>  
>  	if (d->host_flags & IDE_HFLAG_CLEAR_SIMPLEX) {
>  		if (ide_pci_clear_simplex(hwif->dma_base, d->name))
> -			printk(KERN_INFO "%s %s: simplex device: DMA forced\n",
> +			pr_info("%s %s: simplex device: DMA forced\n",
>  				d->name, pci_name(dev));
>  		goto out;
>  	}
> @@ -132,7 +132,7 @@ int ide_pci_check_simplex(ide_hwif_t *hwif, const struct ide_port_info *d)
>  	 */
>  	dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
>  	if ((dma_stat & 0x80) && hwif->mate && hwif->mate->dma_base) {
> -		printk(KERN_INFO "%s %s: simplex device: DMA disabled\n",
> +		pr_info("%s %s: simplex device: DMA disabled\n",
>  			d->name, pci_name(dev));
>  		return -1;
>  	}
> @@ -155,8 +155,8 @@ int ide_pci_set_master(struct pci_dev *dev, const char *name)
>  
>  		if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd) ||
>  		    (pcicmd & PCI_COMMAND_MASTER) == 0) {
> -			printk(KERN_ERR "%s %s: error updating PCICMD\n",
> -				name, pci_name(dev));
> +			pr_err("%s %s: error updating PCICMD\n",
> +			       name, pci_name(dev));
>  			return -EIO;
>  		}
>  	}
> @@ -168,7 +168,7 @@ EXPORT_SYMBOL_GPL(ide_pci_set_master);
>  
>  void ide_setup_pci_noise(struct pci_dev *dev, const struct ide_port_info *d)
>  {
> -	printk(KERN_INFO "%s %s: IDE controller (0x%04x:0x%04x rev 0x%02x)\n",
> +	pr_info("%s %s: IDE controller (0x%04x:0x%04x rev 0x%02x)\n",
>  		d->name, pci_name(dev),
>  		dev->vendor, dev->device, dev->revision);
>  }
> @@ -195,12 +195,12 @@ static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
>  	if (pci_enable_device(dev)) {
>  		ret = pci_enable_device_io(dev);
>  		if (ret < 0) {
> -			printk(KERN_WARNING "%s %s: couldn't enable device\n",
> -				d->name, pci_name(dev));
> +			pr_warning("%s %s: couldn't enable device\n",
> +				   d->name, pci_name(dev));
>  			goto out;
>  		}
> -		printk(KERN_WARNING "%s %s: BIOS configuration fixed\n",
> -			d->name, pci_name(dev));
> +		pr_warning("%s %s: BIOS configuration fixed\n",
> +			   d->name, pci_name(dev));
>  	}
>  
>  	/*
> @@ -210,8 +210,8 @@ static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
>  	 */
>  	ret = pci_set_dma_mask(dev, DMA_BIT_MASK(32));
>  	if (ret < 0) {
> -		printk(KERN_ERR "%s %s: can't set DMA mask\n",
> -			d->name, pci_name(dev));
> +		pr_err("%s %s: can't set DMA mask\n",
> +		       d->name, pci_name(dev));
>  		goto out;
>  	}
>  
> @@ -229,8 +229,8 @@ static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
>  
>  	ret = pci_request_selected_regions(dev, bars, d->name);
>  	if (ret < 0)
> -		printk(KERN_ERR "%s %s: can't reserve resources\n",
> -			d->name, pci_name(dev));
> +		pr_err("%s %s: can't reserve resources\n",
> +		       d->name, pci_name(dev));
>  out:
>  	return ret;
>  }
> @@ -256,18 +256,18 @@ static int ide_pci_configure(struct pci_dev *dev, const struct ide_port_info *d)
>  	 */
>  	if (ide_setup_pci_baseregs(dev, d->name) ||
>  	    pci_write_config_word(dev, PCI_COMMAND, pcicmd | PCI_COMMAND_IO)) {
> -		printk(KERN_INFO "%s %s: device disabled (BIOS)\n",
> +		pr_info("%s %s: device disabled (BIOS)\n",
>  			d->name, pci_name(dev));
>  		return -ENODEV;
>  	}
>  	if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd)) {
> -		printk(KERN_ERR "%s %s: error accessing PCI regs\n",
> -			d->name, pci_name(dev));
> +		pr_err("%s %s: error accessing PCI regs\n",
> +		       d->name, pci_name(dev));
>  		return -EIO;
>  	}
>  	if (!(pcicmd & PCI_COMMAND_IO)) {
> -		printk(KERN_ERR "%s %s: unable to enable IDE controller\n",
> -			d->name, pci_name(dev));
> +		pr_err("%s %s: unable to enable IDE controller\n",
> +		       d->name, pci_name(dev));
>  		return -ENXIO;
>  	}
>  	return 0;
> @@ -322,9 +322,9 @@ static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
>  	if ((d->host_flags & IDE_HFLAG_ISA_PORTS) == 0) {
>  		if (ide_pci_check_iomem(dev, d, 2 * port) ||
>  		    ide_pci_check_iomem(dev, d, 2 * port + 1)) {
> -			printk(KERN_ERR "%s %s: I/O baseregs (BIOS) are "
> -				"reported as MEM for port %d!\n",
> -				d->name, pci_name(dev), port);
> +			pr_err("%s %s: I/O baseregs (BIOS) are "
> +			       "reported as MEM for port %d!\n",
> +			       d->name, pci_name(dev), port);
>  			return -EINVAL;
>  		}
>  
> @@ -337,8 +337,8 @@ static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
>  	}
>  
>  	if (!base || !ctl) {
> -		printk(KERN_ERR "%s %s: bad PCI BARs for port %d, skipping\n",
> -			d->name, pci_name(dev), port);
> +		pr_err("%s %s: bad PCI BARs for port %d, skipping\n",
> +		       d->name, pci_name(dev), port);
>  		return -EINVAL;
>  	}
>  
> @@ -426,15 +426,15 @@ static int ide_setup_pci_controller(struct pci_dev *dev,
>  
>  	ret = pci_read_config_word(dev, PCI_COMMAND, &pcicmd);
>  	if (ret < 0) {
> -		printk(KERN_ERR "%s %s: error accessing PCI regs\n",
> -			d->name, pci_name(dev));
> +		pr_err("%s %s: error accessing PCI regs\n",
> +		       d->name, pci_name(dev));
>  		goto out;
>  	}
>  	if (!(pcicmd & PCI_COMMAND_IO)) {	/* is device disabled? */
>  		ret = ide_pci_configure(dev, d);
>  		if (ret < 0)
>  			goto out;
> -		printk(KERN_INFO "%s %s: device enabled (Linux)\n",
> +		pr_info("%s %s: device enabled (Linux)\n",
>  			d->name, pci_name(dev));
>  	}
>  
> @@ -473,7 +473,7 @@ void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d,
>  
>  		if (e->reg && (pci_read_config_byte(dev, e->reg, &tmp) ||
>  		    (tmp & e->mask) != e->val)) {
> -			printk(KERN_INFO "%s %s: IDE port disabled\n",
> +			pr_info("%s %s: IDE port disabled\n",
>  				d->name, pci_name(dev));
>  			continue;	/* port not enabled */
>  		}
> @@ -519,14 +519,14 @@ static int do_ide_setup_pci_device(struct pci_dev *dev,
>  
>  	if (ide_pci_is_in_compatibility_mode(dev)) {
>  		if (noisy)
> -			printk(KERN_INFO "%s %s: not 100%% native mode: will "
> +			pr_info("%s %s: not 100%% native mode: will "
>  				"probe irqs later\n", d->name, pci_name(dev));
>  		pciirq = 0;
>  	} else if (!pciirq && noisy) {
> -		printk(KERN_WARNING "%s %s: bad irq (%d): will probe later\n",
> -			d->name, pci_name(dev), pciirq);
> +		pr_warning("%s %s: bad irq (%d): will probe later\n",
> +			   d->name, pci_name(dev), pciirq);
>  	} else if (noisy) {
> -		printk(KERN_INFO "%s %s: 100%% native mode on irq %d\n",
> +		pr_info("%s %s: 100%% native mode on irq %d\n",
>  			d->name, pci_name(dev), pciirq);
>  	}

Seems like it would be more beneficial to convert the above printk()s
to use dev_*(&dev->dev) instead (please note the "%s %s: " prefix).
