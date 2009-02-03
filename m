Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbZBCSIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbZBCSIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 13:08:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZBCSHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 13:07:52 -0500
Received: from kroah.org ([198.145.64.141]:52416 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752133AbZBCSHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 13:07:52 -0500
Date: Tue, 3 Feb 2009 09:37:01 -0800
From: Greg KH <greg@kroah.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Stack trace with kernel 2.6.29-rc2
Message-ID: <20090203173701.GA30687@kroah.com>
References: <20090202192823.GA3181@ime.usp.br> <alpine.LRH.1.10.0902031345410.22097@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LRH.1.10.0902031345410.22097@twin.jikos.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 01:46:06PM +0100, Jiri Kosina wrote:
> 
> [ added linux-usb to CC ]
> 
> On Mon, 2 Feb 2009, Rogério Brito wrote:
> 
> > Dear people,
> > 
> > I have compiled a kernel 2.6.29-rc2 here and my girlfriend's cell phone
> > had a photo that she wanted me to retouch with GIMP.
> > 
> > Upon plugging the phone (a Sony-Ericsson W580i), I got the following
> > stack trace:
> > 
> > - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> > [   43.301629] [drm] Initialized i915 1.6.0 20080730 on minor 0
> > [   70.296125] hfs: Filesystem was not cleanly unmounted, running fsck.hfsplus is recommended.  mounting read-only.
> > [47560.223207] RPC: Registered udp transport module.
> > [47560.223213] RPC: Registered tcp transport module.
> > [64006.505015] usb 4-1: new full speed USB device using uhci_hcd and address 2
> > [64006.683960] usb 4-1: New USB device found, idVendor=0fce, idProduct=d089
> > [64006.683968] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> > [64006.683972] usb 4-1: Product: Sony Ericsson W580
> > [64006.683975] usb 4-1: Manufacturer: Sony Ericsson
> > [64006.683977] usb 4-1: SerialNumber: 3538320239844940
> > [64006.684265] usb 4-1: configuration #3 chosen from 1 choice
> > [64017.954045] usb 4-1: USB disconnect, address 2
> > [64019.944014] usb 4-1: new full speed USB device using uhci_hcd and address 3
> > [64020.104164] usb 4-1: New USB device found, idVendor=0fce, idProduct=e089
> > [64020.104170] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> > [64020.104174] usb 4-1: Product: Memory Stick
> > [64020.104177] usb 4-1: Manufacturer: Sony Ericsson
> > [64020.104180] usb 4-1: SerialNumber: 3538320239844940
> > [64020.104854] usb 4-1: configuration #2 chosen from 1 choice
> > [64020.194618] SCSI subsystem initialized
> > [64020.206166] Initializing USB Mass Storage driver...
> > [64020.206805] scsi0 : SCSI emulation for USB Mass Storage devices
> > [64020.210153] usb-storage: device found at 3
> > [64020.210157] usb-storage: waiting for device to settle before scanning
> > [64020.210182] usbcore: registered new interface driver usb-storage
> > [64020.210189] USB Mass Storage support registered.
> > [64025.211305] usb-storage: device scan complete
> > [64025.214298] scsi 0:0:0:0: Direct-Access     Sony Eri Memory Stick     0000 PQ: 0 ANSI: 0
> > [64025.300302] Driver 'sd' needs updating - please use bus_type methods
> > [64025.306246] sd 0:0:0:0: [sda] 958999 512-byte hardware sectors: (491 MB/468 MiB)
> > [64025.313247] sd 0:0:0:0: [sda] Test WP failed, assume Write Enabled
> > [64025.313253] sd 0:0:0:0: [sda] Assuming drive cache: write through
> > [64025.322240] sd 0:0:0:0: [sda] 958999 512-byte hardware sectors: (491 MB/468 MiB)
> > [64025.329243] sd 0:0:0:0: [sda] Test WP failed, assume Write Enabled
> > [64025.329249] sd 0:0:0:0: [sda] Assuming drive cache: write through
> > [64025.329254]  sda: sda1
> > [64025.338262] sda: p1 size 958999 limited to end of disk
> > [64025.341192] sd 0:0:0:0: [sda] Attached SCSI removable disk
> > [64025.510204] ------------[ cut here ]------------
> > [64025.510211] WARNING: at drivers/usb/storage/transport.c:584 last_sector_hacks+0xfd/0x155 [usb_storage]()
> > [64025.510214] Hardware name:  

I think this message happened when it was plugged in, not removed.

It's a known issue and will be addressed in the next -rc.

thanks,

greg k-h
