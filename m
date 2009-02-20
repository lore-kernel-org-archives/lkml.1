Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbZBTPmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbZBTPmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbZBTPmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:42:13 -0500
Received: from hosted02.westnet.com.au ([203.10.1.213]:60182 "EHLO
	hosted02.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbZBTPmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:42:12 -0500
From: Mike Lampard <mike@mtgambier.net>
Reply-To: mike@mtgambier.net
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: long-term regression with some usb mass storage devices
Date: Sat, 21 Feb 2009 02:12:03 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.28.3-desktop-1mnb; KDE/4.2.0; x86_64; ; )
Cc: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0902201012150.3071-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0902201012150.3071-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902210212.04737.mike@mtgambier.net>
X-PMX-Branch: TNG-Outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Feb 2009 01:45:37 am Alan Stern wrote:
> On Fri, 20 Feb 2009, Mike Lampard wrote:
> > On Fri, 20 Feb 2009 05:17:42 pm Mike Lampard wrote:
> > > Hi All,
> > >
> > > I recently plonked a dvd into my usb-attached Pioneer DVR-107d only to
> > > find that the current kernels no longer saw the drive as DVD capable. 
> > > In fact, the kernel no longer saw _any_ features of the drive: sr0:
> > > scsi3-mmc drive: 0x/0x caddy.  After much bisecting and even more blind
> > > luck I narrowed the problem down to this commit:
> > >
> > > commit bdb2b8cab4392ce41ddfbd6773a3da3334daf836
> > > Author: Alan Stern <stern@rowland.harvard.edu>
> > > Date:   Tue Jun 24 14:03:14 2008 -0400
> > >
> > >     [SCSI] erase invalid data returned by device
> > >
> > >     This patch (as1108) fixes a problem that can occur with certain USB
> > >     mass-storage devices: They return invalid data together with a
> > > residue indicating that the data should be ignored.  Rather than leave
> > > the invalid data in a transfer buffer, where it can get misinterpreted,
> > > the patch clears the invalid portion of the buffer.
> > >
> > >     This solves a problem (wrong write-protect setting detected)
> > > reported by Maciej Rutecki and Peter Teoh.
>
> If this affected your device then the device must not report residues
> correctly.  If you provide the device's entry in /proc/bus/usb/devices,
> I'll write a patch adding a blacklist entry for it.

Many thanks.

> It would help if you could also provide a usbmon trace showing what
> happens when you plug the drive in.  Instructions are in the kernel
> source file Documentation/usb/usbmon.txt.

/proc/bus/usb/devices: 
T:  Bus=01 Lev=01 Prnt=01 Port=06 Cnt=01 Dev#=  3 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=05e3 ProdID=0701 Rev= 0.02
S:  Manufacturer=Genesyslogic
S:  Product=USB Mass Storage Device
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr= 96mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=125us

I'll email the usbmod log directly, to save spamming the list with a 100kb 
attachment.

Mike
