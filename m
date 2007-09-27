Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbXI0Axx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbXI0Axx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 20:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbXI0Axo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 20:53:44 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:54274 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbXI0Axn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 20:53:43 -0400
From: Konrad Rzeszutek <konrad@darnok.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Add iSCSI iBFT support.
Date: Wed, 26 Sep 2007 20:52:43 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com
References: <20070926184652.GA16369@andromeda.dapyr.net> <20070926142950.46bbfcd2.randy.dunlap@oracle.com>
In-Reply-To: <20070926142950.46bbfcd2.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709262052.44845.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +config ISCSI_IBFT
> > +	tristate "iSCSI Boot Firmware Table Attributes"
> > +	depends on X86
>
> why only on X86?

PowerPC exports this data via the OpenFirmware so it already shows in 
the /sysfs entries. I was thinking to combine those sysfs entries under this 
code, but that is something in the future.

In regards to all other platforms, I figured I would only make it supported 
under platforms that have been tested. Is there anything that stops this from 
working for example of IA64? Well no. The hardware that supports the iBFT is 
either in the BIOS or in NICs - so the SGI or HP boxes _should_ work, however 
I am not comfortable to make it supported unless I've tested it.

> > + * drivers/firmware/iscsi_ibft.c
>
> Don't repeat the file name.

OK. 
> > + * This code exposes the the iSCSI Boot Format Table to userland via
> > sysfs.
>
>                 ~~~~~~~
> yes.

Yup. 
> > +
>
> no blank line here.

Fixed.
> > +static ssize_t
> > +ibft_read_binary(struct kobject *kobj, struct bin_attribute *attr, char
> > *buf, +		 loff_t off, size_t count)
>
> Put 'static ssize_t' on same line as function name, then put parameters
> on following lines as needed.

Fixed.
> > +static int
> > +ibft_mmap_binary(struct kobject *kobj, struct bin_attribute *attr,
> > +		 struct vm_area_struct *vma)
>
> ditto.
Fixed.

> > +	/* Need PAGE_ALING for mmap functionality. */
>
>                 PAGE_ALIGN

Fixed.
> > +	printk(KERN_INFO "BIOS iBFT unloaded.\n");
>
> Drop the unload message.  ibft_init() is also quite noisy.

Fixed.
>
> Need blank line here... except why is this function in the header

Fixed blank line.
> file?  and why is it inline?

Q: "Why is this function in the header file"
If the find_ibft() was to be implemented in firmware/iscsi_ibft.c code the 
firmware-driver couldn't be compiled as a module (or rather it could, but 
when the vmlinuz was to be linked it would complain about missing symbol - 
find_ibft). I was thinking to let the user give the choice whether they want 
to load this firmware driver or have it built-in the kernel.

Q:"Why is it inline"
Uhh. It does not need to. I will remove the 'inline' part. 
>
> > +	unsigned long pos;
>
> add blank line here between data / code.

Fixed.

Randy,

Thank you for taking time to do such thoroughly review.
