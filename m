Return-Path: <linux-kernel-owner+w=401wt.eu-S1760849AbXGIX5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760849AbXGIX5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 19:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759362AbXGIX5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 19:57:33 -0400
Received: from mail.beimborn.com ([70.84.38.100]:36886 "EHLO mail.beimborn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759334AbXGIX5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 19:57:32 -0400
X-Greylist: delayed 1281 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jul 2007 19:57:32 EDT
Date: Tue, 10 Jul 2007 00:35:35 +0100
From: Adam Spiers <smartmontools@adamspiers.org>
To: Bruce Allen <ballen@gravity.phys.uwm.edu>
Cc: Mark Lord <liml@rtr.ca>, David Greaves <david@dgreaves.com>,
       Douglas Gilbert <dougg@torque.net>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kai Makisara <Kai.Makisara@kolumbus.fi>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Klaus Fuerstberger <kfuerstberger@arcor.de>,
       Jan Dvorak <fermentol@gmail.com>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       Bruce Allen <bruce.allen@aei.mpg.de>
Subject: Re: [smartmontools-support] SMART problems in 2.6.22
Message-ID: <20070709233535.GA5020@atlantic.linksys.moosehall>
Reply-To: Adam Spiers <smartmontools@adamspiers.org>
Mail-Followup-To: Bruce Allen <ballen@gravity.phys.uwm.edu>,
	Mark Lord <liml@rtr.ca>, David Greaves <david@dgreaves.com>,
	Douglas Gilbert <dougg@torque.net>, Tejun Heo <htejun@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Kai Makisara <Kai.Makisara@kolumbus.fi>,
	Jeff Garzik <jeff@garzik.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Klaus Fuerstberger <kfuerstberger@arcor.de>,
	Jan Dvorak <fermentol@gmail.com>,
	Smartmontools Mailing List <smartmontools-support@lists.sourceforge.net>,
	Bruce Allen <bruce.allen@aei.mpg.de>
References: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu> <Pine.LNX.4.63.0707082003360.23123@trinity.phys.uwm.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0707082003360.23123@trinity.phys.uwm.edu>
X-OS: Linux
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 08:14:10PM -0500, Bruce Allen wrote:
> On Sun, 8 Jul 2007, Bruce Allen wrote:
> > I'm afraid that there may be some problem with SMART + libata in the 2.6.22 
> > kernel.  An hour ago I discovered that I missed a month of correspondence 
> > (some LKML, some private) about this problem which Alan, Tejun, Jeff, Mark 
> > and others copied to me -- it was automatically shoved into one of my 
> > mailboxes by my mail client.  Sorry about that.  So I am trying to catch up 
> > to see if there is some real problem or not.
> >
> > Here is a typical bug report that worries me:
> > http://article.gmane.org/gmane.linux.utilities.smartmontools/4712
> >
> > Here is another similar report:
> > http://thread.gmane.org/gmane.linux.utilities.smartmontools/4713
> >
> > And another report:
> > http://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg358354.html
> >
> > From some of the earlier threads that I missed (below) I have the impression 
> > that the problem may be a very simple one, namely that starting with 2.6.22 
> > one needs to run a command to enable SMART when a box is first booted -- the 
> > kernel no longer does this as part of the init/setup of the disks. But that 
> > is NOT consistent with the first two reports above, which show 'SMART 
> > ENABLED'.

[snipped]

> Here is another similar report:
> 
> http://article.gmane.org/gmane.linux.utilities.smartmontools/4704/match=diamondmax
> 
> Again, this indicates that SMART is enabled.  But it's not clear what the 
> kernel version here is.  The report indicates that the problem started 
> with an FC7 kernel upgrade

That was me, and the kernel in question is 2.6.21-1.3194.fc7.  I tried
Jeff's noacpi suggestion, and here is the outcome.  I am sure it comes
as no surprise that his patch to support the boot-time parameter
libata.noacpi is not included in this kernel:

  Kernel command line: ro root=/dev/vg0/fc-root rhgb selinux=0 nodmraid libata.noacpi=1
  Unknown boot option `libata.noacpi=1': ignoring

However, the module option is there:

  # modinfo libata
  filename:       /lib/modules/2.6.21-1.3194.fc7/kernel/drivers/ata/libata.ko
  version:        2.20
  license:        GPL
  description:    Library module for ATA devices
  author:         Jeff Garzik
  srcversion:     44DAFFD701701A15EB2D574
  depends:        scsi_mod
  vermagic:       2.6.21-1.3194.fc7 SMP mod_unload 686 4KSTACKS
  parm:           atapi_enabled:Enable discovery of ATAPI devices (0=off, 1=on) (int)
  parm:           atapi_dmadir:Enable ATAPI DMADIR bridge support (0=off, 1=on) (int)
  parm:           fua:FUA support (0=off, 1=on) (int)
  parm:           ignore_hpa:Ignore HPA (0=keep BIOS setting 1=ignore it) (int)
  parm:           ata_probe_timeout:Set ATA probing timeout (seconds) (int)
  parm:           noacpi:Disables the use of ACPI in suspend/resume when set (int)

And when used via:

  # cat /etc/modprobe.d/libata
  options libata noacpi=1

I still see the same problem:

  smartctl version 5.37 [i686-redhat-linux-gnu] Copyright (C) 2002-6 Bruce Allen
  Home page is http://smartmontools.sourceforge.net/

  === START OF INFORMATION SECTION ===
  Model Family:     Maxtor DiamondMax 10 family (ATA/133 and SATA/150)
  Device Model:     Maxtor 6L250S0
  Serial Number:    L50A1B8H
  Firmware Version: BANC1G10
  User Capacity:    251,000,193,024 bytes
  Device is:        In smartctl database [for details use: -P show]
  ATA Version is:   7
  ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 0
  Local Time is:    Mon Jul  9 23:39:25 2007 BST
  SMART support is: Available - device has SMART capability.
  SMART support is: Enabled

  Error SMART Status command failed
  Please get assistance from http://smartmontools.sourceforge.net/
  Register values returned from SMART Status command are:
  CMD=0x50
  FR =0x00
  NS =0x00
  SC =0x00
  CL =0xc2
  CH =0x00
  SEL=0x00
  A mandatory SMART command failed: exiting. To continue, add one or more '-T permissive' options.

Regarding Kai's very recent analysis elsewhere in this thread:

> sata_nc has been changed between 2.6.21 and 2.6.22-rc1 and this 
> particular smartctl problem may or may not be specific to CK804.

I should note that this particular machine is indeed using that chipset:

  00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev a3)
  00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev a3)

HTH,
Adam
