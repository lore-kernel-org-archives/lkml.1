Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbXCWTFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbXCWTFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932275AbXCWTFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:05:08 -0400
Received: from [81.2.110.250] ([81.2.110.250]:60147 "EHLO lxorguk.ukuu.org.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932067AbXCWTFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:05:05 -0400
Date: Fri, 23 Mar 2007 20:08:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       kyle@canonical.com
Subject: Re: HPA patches
Message-ID: <20070323200819.4e734f4f@lxorguk.ukuu.org.uk>
In-Reply-To: <20070323112411.f6a8a762.randy.dunlap@oracle.com>
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk>
	<20070323112411.f6a8a762.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static int ata_ignore_hpa = 0;
> 
> Don't init to 0.  Not needed, bloats binary files.

It'll be one for the final release 8)

> > +module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);
> > +MODULE_PARM_DESC(ignore_hpa, "Ignore HPA (0=off 1=on)");
> 
> So 1 = on = ignore, right?

Yes.

> > +	tf.command = ATA_CMD_READ_NATIVE_MAX_EXT;
> > +	tf.flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48 | ATA_TFLAG_ISADDR;
> > +	tf.protocol |= ATA_PROT_NODATA;
> > +	tf.device = 0x40;
> 
> What is 0x40?  can it be #defined (or enum-ed) instead of a magic
> value?  please?  (more of same below)

It's 0x40. Its a "command dependant bit" - no useful name.

> > +	u64 sectors = dev->n_sectors;
> > +	u64 hpa_sectors;
> > +	
> > +	if (ata_id_has_lba48(dev->id))
> > +		hpa_sectors = ata_read_native_max_address_ext(dev);
> > +	else
> > +		hpa_sectors = ata_read_native_max_address(dev);
> > +
> > +	/* if no hpa, both should be equal */
> > +	ata_dev_printk(dev, KERN_INFO, "%s 1: sectors = %lld, hpa_sectors = %lld\n",
> > +		__FUNCTION__, sectors, hpa_sectors);
> 
> (long long) or (unsigned long long) on sectors and hpa_sectors...

u64 is always unsigned long long (and its debug anyway)

> 
> > +
> > +	if (hpa_sectors > sectors) {
> > +		ata_dev_printk(dev, KERN_INFO,
> > +			"Host Protected Area detected:\n"
> > +			"\tcurrent size: %lld sectors\n"
> > +			"\tnative size: %lld sectors\n",
> > +			sectors, hpa_sectors);
> 
> printk format types ok?

Yes

> > +			if (hpa_sectors) {
> > +				ata_dev_printk(dev, KERN_INFO,
> > +					"native size increased to %lld sectors\n", hpa_sectors);
> 
> Line lengths < 80 and printk format types?

See above, and the 80 column fascists can suffer in the name of
readability. 

Alan
