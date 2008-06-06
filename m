Return-Path: <linux-kernel-owner+w=401wt.eu-S1764328AbYFFSka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764328AbYFFSka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 14:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbYFFSkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 14:40:21 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40443 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751713AbYFFSkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 14:40:20 -0400
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: chris2553@googlemail.com, LKML <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080606110345.581fdc77.akpm@linux-foundation.org>
References: <200806010415.05290.chris2553@googlemail.com>
	 <20080605221709.f248eb90.akpm@linux-foundation.org>
	 <200806060607.29460.chris2553@googlemail.com>
	 <20080605232145.cdae753f.akpm@linux-foundation.org>
	 <20080605232538.fb85021e.akpm@linux-foundation.org>
	 <1212765742.16182.8.camel@localhost.localdomain>
	 <20080606110345.581fdc77.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf8
Date: Fri, 06 Jun 2008 13:40:12 -0500
Message-Id: <1212777612.16182.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-06 at 11:03 -0700, Andrew Morton wrote:
> On Fri, 06 Jun 2008 10:22:22 -0500 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Thu, 2008-06-05 at 23:25 -0700, Andrew Morton wrote:
> > > On Thu, 5 Jun 2008 23:21:45 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > <watches wodim wibble for five minutes then report "CD/DVD-Recorder
> > > > not ready."  Pretends not to have noticed.>
> > > 
> > > It goes much better when the CD is inserted upside up.
> > 
> > So I can close this regression if I send you a pack of CD ring labels
> > with "other way up" on them for you to affix to the underside of your
> > CDs ... ?
> > 
> 
> Would prefer double-sided CDs.

I just discovered my budget only runs to a permanent marker for you to
write the instructions on the rim yourself ...

> Is this 20-second-delay thing known-about/expected/etc?

If it's not the scsi_bus_uevent problem, then no, it isn't.

The odd thing is that it occurs in the middle of USB initialisation from
the log:

> ﻿Jun  6 17:25:19 upstairs kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller 
> Jun  6 17:25:19 upstairs kernel: uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1 
> Jun  6 17:25:19 upstairs kernel: uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000a800 
> Jun  6 17:25:19 upstairs kernel: usb usb1: configuration #1 chosen from 1 choice 
> Jun  6 17:25:19 upstairs kernel: hub 1-0:1.0: USB hub found 
> Jun  6 17:25:19 upstairs kernel: hub 1-0:1.0: 2 ports detected 
> Jun  6 17:25:44 upstairs kernel: ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver 
> Jun  6 17:25:44 upstairs kernel: usb usb1: New USB device found, idVendor=1d6b, idProduct=0001 
> Jun  6 17:25:44 upstairs kernel: usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
> Jun  6 17:25:44 upstairs kernel: usb usb1: Product: UHCI Host Controller 
> Jun  6 17:25:44 upstairs kernel: usb usb1: Manufacturer: Linux 2.6.26-rc5 uhci_hcd 

Note the jump from 19 to 44 seconds.

There's another one here:


> ﻿Jun  6 17:25:44 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
> Jun  6 17:25:44 upstairs kernel: Adding 4096532k swap on /dev/sda5.  Priority:-1 extents:1 across:4096532k 
> Jun  6 17:25:44 upstairs kernel: eth0: link up, 100Mbps, full-duplex, lpa 0x45E1 
> Jun  6 17:25:44 upstairs kernel: ip_tables: (C) 2000-2006 Netfilter Core Team 
> Jun  6 17:25:44 upstairs kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max) 
> Jun  6 17:25:44 upstairs kernel: parport_pc 00:06: disabled 
> Jun  6 17:25:44 upstairs kernel: pnp: the driver 'parport_pc' has been unregistered 
> Jun  6 17:25:44 upstairs kernel: ieee1394: Node removed: ID:BUS[0-00:1023]  GUID[00110666000013cc] 
> Jun  6 17:26:31 upstairs kernel: usb 11-2: new high speed USB device using ehci_hcd and address 3 
> Jun  6 17:26:31 upstairs kernel: usb 11-2: configuration #1 chosen from 1 choice 
> Jun  6 17:26:31 upstairs kernel: usb 11-2: New USB device found, idVendor=0930, idProduct=6545 
> Jun  6 17:26:31 upstairs kernel: usb 11-2: New USB device strings: Mfr=0, Product=2, SerialNumber=3 
> Jun  6 17:26:31 upstairs kernel: usb 11-2: Product: USB Flash Memory 
> Jun  6 17:26:31 upstairs kernel: usb 11-2: SerialNumber: 0EC065712361A91E 


I'm a bit baffled as to how that could be SCSI related, but I suppose it
could be udev related somehow.  Perhaps turning on driver core debugging
might help (that's CONFIG_DEBUG DRIVER ... it depends on
CONFIG_DEBUG_KERNEL for activation).  Hopefully the verbose kernel logs
from here might tell us what's going on in the lacunae.

James


