Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbZJCPt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbZJCPt6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 11:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbZJCPt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 11:49:57 -0400
Received: from mga05.intel.com ([192.55.52.89]:4195 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753047AbZJCPt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 11:49:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,499,1249282800"; 
   d="scan'208";a="732742087"
Date: Sat, 3 Oct 2009 08:48:44 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: Annoying problems with lacie external hd (JMicron 0x2339?)
Message-ID: <20091003154844.GA24819@xanatos>
References: <94a0d4530910030335p2eae17a6wddf6d87b7f60b712@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94a0d4530910030335p2eae17a6wddf6d87b7f60b712@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 01:35:58PM +0300, Felipe Contreras wrote:
> Hi,
> 
> This is with 2.6.31.1.
> 
> I'm having a lot of problems with a lacie external hd[1]. It seems the
> actual disk is a seagate ST375064, and the bridge is a JMicron 2339.
> 
> In normal usage what I see is that if I don't use the disk after a
> while hear a loud click (as if something got stuck) and then I cannot
> use it any more; I have to turn it off and on again.
> 
> But then I started to see some problems on one fs, so I ran badblocks
> and I noticed a lot of strange behavior. It seems once I get a
> read/write error then I get more of them in a row, and after a while I
> hear another loud click, and then I only get read/write errors
> constantly.
> 
> I noticed in 'unusual_devs.h' there's already a quirk for another
> JMicron product, so I tried to do the same:
> 
> +UNUSUAL_DEV(  0x152d, 0x2339, 0x0000, 0xffff,
> +               "JMicron",
> +               "USB to ATA/ATAPI Bridge",
> +               US_SC_DEVICE, US_PR_DEVICE, NULL,
> +               US_FL_IGNORE_RESIDUE | US_FL_SANE_SENSE ),
> 
> This seemed to help with the consecutive errors, but not with the loud click.
> 
> This is what I get when this click happens:
> 
> Oct  3 13:14:54 annwn kernel: [  351.099096] usb 1-1: reset high speed
> USB device using ehci_hcd and address 3
> Oct  3 13:14:54 annwn kernel: [  351.213541] usb 1-1: device firmware changed
> Oct  3 13:14:54 annwn kernel: [  351.213588] usb 1-1: USB disconnect, address 3
> Oct  3 13:14:54 annwn kernel: [  351.213633] sd 4:0:0:0: Device
> offlined - not ready after error recovery
> Oct  3 13:14:54 annwn kernel: [  351.213650] sd 4:0:0:0: [sdb]
> Unhandled error code
> Oct  3 13:14:54 annwn kernel: [  351.213655] sd 4:0:0:0: [sdb] Result:
> hostbyte=DID_ABORT driverbyte=DRIVER_OK
> Oct  3 13:14:54 annwn kernel: [  351.213663] end_request: I/O error,
> dev sdb, sector 8596352
> Oct  3 13:14:54 annwn kernel: [  351.213774] sd 4:0:0:0: rejecting I/O
> to offline device
> Oct  3 13:14:54 annwn kernel: [  351.213816] sd 4:0:0:0: rejecting I/O
> to offline device
> Oct  3 13:14:54 annwn kernel: [  351.213852] sd 4:0:0:0: rejecting I/O
> to offline device
> Oct  3 13:14:54 annwn kernel: [  351.213891] sd 4:0:0:0: rejecting I/O
> to offline device
> Oct  3 13:14:54 annwn kernel: [  351.213927] sd 4:0:0:0: rejecting I/O
> to offline device
> Oct  3 13:14:54 annwn kernel: [  351.213962] sd 4:0:0:0: rejecting I/O
> to offline device
> Oct  3 13:14:54 annwn kernel: [  351.213997] sd 4:0:0:0: rejecting I/O
> to offline device
> Oct  3 13:14:54 annwn kernel: [  351.214202] sd 4:0:0:0: rejecting I/O
> to offline device
> Oct  3 13:14:55 annwn kernel: [  351.317278] usb 1-1: new high speed
> USB device using ehci_hcd and address 4
> Oct  3 13:14:55 annwn kernel: [  351.432192] usb 1-1: New USB device
> found, idVendor=152d, idProduct=2339
> Oct  3 13:14:55 annwn kernel: [  351.432196] usb 1-1: New USB device
> strings: Mfr=1, Product=2, SerialNumber=5
> Oct  3 13:14:55 annwn kernel: [  351.432199] usb 1-1: Product: USB to
> ATA/ATAPI Bridge
> Oct  3 13:14:55 annwn kernel: [  351.432202] usb 1-1: Manufacturer: JMicron
> Oct  3 13:14:55 annwn kernel: [  351.432204] usb 1-1: SerialNumber: 5D27FFFFFFFF
> Oct  3 13:14:55 annwn kernel: [  351.432321] usb 1-1: configuration #1
> chosen from 1 choice
> Oct  3 13:14:55 annwn kernel: [  351.432791] scsi5 : SCSI emulation
> for USB Mass Storage devices
> 
> Can anyone help? This disk is important for me =/

The log shows the device just disconnected from the system.  You should
post more of the logfile before the disconnect so we can see if it's an
issue with the USB core.  Did it work with a previous kernel?

It could be that your disk is just dying, and occasionally
disconnecting.  Or you could have a bad cable or a hub that's
introducing noise.  Can you try a different USB cable?

Sarah Sharp

> T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 62 Spd=480 MxCh= 0
> D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=152d ProdID=2339 Rev= 1.00
> S:  Manufacturer=JMicron
> S:  Product=USB to ATA/ATAPI Bridge
> S:  SerialNumber=152D203380B6
> C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=  2mA
> I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
> E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> 
> [1] http://www.lacie.com/us/products/product.htm?pid=11016
> 
> -- 
> Felipe Contreras
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
