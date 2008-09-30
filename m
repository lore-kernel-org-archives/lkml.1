Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbYI3NOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbYI3NOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 09:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbYI3NOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 09:14:42 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:55146 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbYI3NOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 09:14:41 -0400
Date: Tue, 30 Sep 2008 14:14:40 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Jan Beulich <jbeulich@novell.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Check for %L for all integer formats (was:
	Re: [PATCH] fix printk format compiler warnings)
Message-ID: <20080930131440.GM14905@brain>
References: <48C13CE0.76E4.0078.0@novell.com> <Pine.LNX.4.64.0809301314270.6954@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0809301314270.6954@vixen.sonytel.be>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 01:29:44PM +0200, Geert Uytterhoeven wrote:
> On Fri, 5 Sep 2008, Jan Beulich wrote:
> > %llx and the like cannot be used on u64-derived data types - they must
> > be cast to long long explicitly for arch-es where u64 is a typedef of
> > unsigned long (ia64 is where I observed the problem).
> 
> > -		printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
> > +		printk(KERN_INFO "PCI: bridge %s io port: [%Lx, %Lx]\n",
> 
> > -		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
> > +		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%Lx, %Lx]\n",
> 
> > -		printk(KERN_INFO "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n", pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64)?"64":"32",res->start, res->end);
> > +		printk(KERN_INFO "PCI: bridge %s %dbit mmio pref: [%Lx, %Lx]\n",
> 
> > -		printk(KERN_INFO "bus: %02x index %x %s: [%llx, %llx]\n", bus->number, i, (res->flags & IORESOURCE_IO)? "io port":"mmio", res->start, res->end);
> > +		printk(KERN_INFO "bus: %02x index %x %s: [%Lx, %Lx]\n",
> 
> Why did you replace `%ll' by `%L'?
> 
> While `L' is used as an internal flag in Linux' vsnprintf() implementation and
> is still supported because of historical (pre-C99) reasons, the `L' conversion
> qualifier is meant for the `long double' floating point type, as per C99.
> The recommended conversion qualifier for the `long long' integer type is `ll'.
> 
> Perhaps checkpatch should check for this? Ah, it already does for some of the
> integer formats. The patch below adds checks for the missing ones.

[...]

Yes that looks entirly reasonable to me.  Will queue it up with my next
batch for Andrew.

Thanks.

-apw
