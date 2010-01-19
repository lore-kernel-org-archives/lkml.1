Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763Ab0ASVYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab0ASVYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721Ab0ASVY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:24:29 -0500
Received: from p01c11o148.mxlogic.net ([208.65.144.71]:52308 "EHLO
	p01c11o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630Ab0ASVY2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:24:28 -0500
X-MXL-Hash: 4b56230b75ddcd3c-ed21e35945685f3b4c4348fb3552aa997603867d
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.33 1/3] net: Micrel KSZ8841/2 PCI Ethernet driver
Date: Tue, 19 Jan 2010 13:22:54 -0800
Message-ID: <14385191E87B904DBD836449AA30269D580A93@MORGANITE.micrel.com>
In-Reply-To: <20100116145014.172ad340@lxorguk.ukuu.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.33 1/3] net: Micrel KSZ8841/2 PCI Ethernet driver
Thread-Index: AcqWuszJfYrqbhuWQRO9+nHJsiMvlgCh8cKw
References: <14385191E87B904DBD836449AA30269D021A4A@MORGANITE.micrel.com> <20100116145014.172ad340@lxorguk.ukuu.org.uk>
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Dave Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Jan 2010 21:24:21.0815 (UTC) FILETIME=[C4494C70:01CA994D]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010011101)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=x45bwnNEFwQA:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 ]
X-AnalysisOut: [a=iNwUhuJFgFR2d65fERoA:9 a=E_1s1oljD0_TIwC1U8QA:7 a=LAf_20]
X-AnalysisOut: [EtgkuhXkZ0_3NIJ6o3qg8A:4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> +/*
>> + * PCI Configuration Space Registers
>> + */
> 
> We have existing standard defines for most of these that should be
used instead where relevant.
> The code appears not use most of these defines for generic PCI stuff
anyway. 
> 
> 
>> +/*
>> + * Hardware register access macros
>> + */
>> +
>> +#define hw_dis_intr_sync(hw)	hw_dis_intr(hw)
>> +
>> +#define HW_R8(hw, addr, data)	(*(data) = readb((hw)->ioaddr +
(addr)))
>> +#define HW_W8(hw, addr, data)	writeb((data), (hw)->ioaddr +
(addr)) +
>> +#define HW_R16(hw, addr, data)	(*(data) = readw((hw)->ioaddr +
(addr)))
>> +#define HW_W16(hw, addr, data)	writew((data), (hw)->ioaddr +
(addr)) +
>> +#define HW_R32(hw, addr, data)	(*(data) = readl((hw)->ioaddr +
(addr)))
>> +#define HW_W32(hw, addr, data)	writel((data), (hw)->ioaddr +
(addr)) +
>> +#define HW_PCI_READ_BYTE(hw, addr, data)
\
>> +	pci_read_config_byte((struct pci_dev *) (hw)->pdev, addr, data)
+
>> +#define HW_PCI_READ_WORD(hw, addr, data)
\
>> +	pci_read_config_word((struct pci_dev *) (hw)->pdev, addr, data)
+
>> +#define HW_PCI_READ_DWORD(hw, addr, data)
\
>> +	pci_read_config_dword((struct pci_dev *) (hw)->pdev, addr, data)
+
>> +#define HW_PCI_WRITE_BYTE(hw, addr, data)
\
>> +	pci_write_config_byte((struct pci_dev *) (hw)->pdev, addr, data)
+
>> +#define HW_PCI_WRITE_WORD(hw, addr, data)
\
>> +	pci_write_config_word((struct pci_dev *) (hw)->pdev, addr, data)
+
>> +#define HW_PCI_WRITE_DWORD(hw, addr, data)
\
>> +	pci_write_config_dword((struct pci_dev *) (hw)->pdev, addr,
data)
> 
> This sort of stuff just obfuscates things so the defines ought to get
removed so the code is
> more readable to all (remember the Linux kernel code needs to be
generally readable not just
> readable by Micrel people)  
> 
> 
>> + * delay_milli - delay in millisecond
>> + * @millisec:	Number of milliseconds to delay.
>> + *
>> + * This routine delays in milliseconds.
>> + */
>> +static void delay_milli(uint millisec) {
>> +	unsigned long ticks = millisec * HZ / 1000;
>> +
>> +	if (!ticks || in_interrupt())
>> +		mdelay(millisec);
>> +	else {
>> +		set_current_state(TASK_INTERRUPTIBLE);
>> +		schedule_timeout(ticks);
> 
> msleep() is probably what you want for this part ? Note that you
really don't want to be
> spinning for milliseconds in the IRQ paths if at all possible. 
> 

The KSZ884X driver is modified from an old driver with shared code which
are used by other OS.  I will clean it up further.


> The DEBUG ioctl is a bit odd - you define it and it does nothing -
just a left over ?
> 
> 

The KSZ884X has features and configurations that are not accessible from
standard Linux interface.  The best way is probably using an application
to access the driver through ioctl interface.  As that application
exists outside the kernel, I removed some code in the ioctl function.  I
am still looking for a better solution to support those hardware
features.  See my procfs comments below.


> 
>> +
>> +#define PCI_VENDOR_ID_KS884X		0x16C6
>> +#define PCI_DEVICE_ID_KS8841		0x8841
>> +#define PCI_DEVICE_ID_KS8842		0x8842
> 
> Those belong in the pci device id header.
> 
> 

I do not quite understand your suggestion.  Do I need to put those IDs
in one of the kernel headers?


> In your pci init function you do the following
> 
>> +	hw->pdev = pdev;
> 
> 
> If you make a private copy of pdev in your struct you should refcount
it and use
> pci_dev_get/pci_dev_put when you take and release the reference. 
> 
> 

The old driver uses shared code which compile in other OS.  Those shared
functions use the hw structure, which does not use any OS dependent data
structures, as an anchor to access the hardware.  In a few situations
the driver needs to write to the PCI configuration registers.  That is
why the hw structure stores the pci device pointer as a generic pointer
variable.

I do not understand how pci_dev_get/pci_dev_put work.  Does the pdev
pointer actually change during the lifetime of the PCI driver?


> The proc stuff probably belongs in sysfs nowdays

I need a quick way to access KSZ884X's hardware features without using a
user application.  I use procfs as it is easy to implement.  I am aware
that sysfs is preferred.  But after trying it I do not think it is
appropriate for my purpose.

The sysfs interface requires just a filename, and read/write functions.
It does not provide a means to pass user-defined data.  So it is fine to
just modify a simple global variable that controls a driver behavior.

The KSZ884X driver has same settings for each individual port.  The
sysfs does not seem to have the capability to create an attribute with
filename like "port1/setting1," so an alternative is to use
"port1_setting1," "port1_setting2," and so on.  It does not look
organized.  (I used the DEVICE_ATTR macro, and the compiler complained
about the name.  I probably did it wrong.)  Also, as the attribute
access functions do not know anything about the port, the same identical
functions have to be created for each port.  It is not efficient.

I also like the attribute to associate with the network device rather
than the PCI device, as the KSZ8842 driver can create another virtual
network device.  I tried to pass the device pointer of the network
device to device_create_file function and the driver crashed.  I will
investigate this matter further.
