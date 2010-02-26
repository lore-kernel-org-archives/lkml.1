Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934718Ab0BZAQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:16:52 -0500
Received: from mga10.intel.com ([192.55.52.92]:5520 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934690Ab0BZAQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:16:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,542,1262592000"; 
   d="scan'208";a="776035023"
Date: Thu, 25 Feb 2010 16:16:21 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: =?iso-8859-1?Q?=C1kos_Mar=F3y?= <akos@maroy.hu>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device
 8087:0020
Message-ID: <20100226001621.GA6060@xanatos>
References: <20100225190452.GA4184@xanatos>
 <Pine.LNX.4.44L0.1002251430470.1686-100000@iolanthe.rowland.org>
 <20100225195249.GA5245@xanatos>
 <4B86FBB0.1080104@maroy.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B86FBB0.1080104@maroy.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 11:37:36PM +0100, Ákos Maróy wrote:
> Sarah,
> 
> > True.  I can't tell exactly what's going on without
> > CONFIG_USB_XHCI_HCD_DEBUGGING.  It's possible the xHCI host never
> > notified the driver of the disconnect, or there's a bug in the xHCI hub
> > emulation code.
> 
> after having turned this option on in the kernel, this is what I get
> when plugging in the device:
> 
> Feb 25 23:32:14 tonkachi kernel: [  100.473783] Registered led device:
> iwl-phy0::radio
> Feb 25 23:32:14 tonkachi kernel: [  100.473812] Registered led device:
> iwl-phy0::assoc
> Feb 25 23:32:14 tonkachi kernel: [  100.473839] Registered led device:
> iwl-phy0::RX
> Feb 25 23:32:14 tonkachi kernel: [  100.473864] Registered led device:
> iwl-phy0::TX
> Feb 25 23:32:14 tonkachi kernel: [  100.497848] usb 2-4: new high speed
> USB device using xhci_hcd and address 0
> Feb 25 23:32:14 tonkachi kernel: [  100.520591] usb 2-4: New USB device
> found, idVendor=058f, idProduct=6254
> Feb 25 23:32:14 tonkachi kernel: [  100.520595] usb 2-4: New USB device
> strings: Mfr=0, Product=0, SerialNumber=0
> Feb 25 23:32:14 tonkachi kernel: [  100.520680] usb 2-4: configuration
> #1 chosen from 1 choice
> Feb 25 23:32:14 tonkachi kernel: [  100.520732] usb 2-4: ep 0x81 -
> rounding interval to 2048 microframes
> Feb 25 23:32:14 tonkachi kernel: [  100.522403] hub 2-4:1.0: USB hub found
> Feb 25 23:32:14 tonkachi kernel: [  100.522930] xhci_hcd 0000:02:00.0:
> WARN: short transfer on control ep
> Feb 25 23:32:14 tonkachi kernel: [  100.523156] hub 2-4:1.0: 3 ports
> detected
> Feb 25 23:32:14 tonkachi kernel: [  100.825758] usb 2-4.1: new high
> speed USB device using xhci_hcd and address 0
> Feb 25 23:32:14 tonkachi kernel: [  100.848327] xhci_hcd 0000:02:00.0:
> WARN: short transfer on control ep
> Feb 25 23:32:14 tonkachi kernel: [  100.849375] xhci_hcd 0000:02:00.0:
> WARN: short transfer on control ep
> Feb 25 23:32:14 tonkachi kernel: [  100.850370] xhci_hcd 0000:02:00.0:
> WARN: short transfer on control ep
> Feb 25 23:32:14 tonkachi kernel: [  100.851366] xhci_hcd 0000:02:00.0:
> WARN: short transfer on control ep
> Feb 25 23:32:14 tonkachi kernel: [  100.851782] usb 2-4.1: New USB
> device found, idVendor=152d, idProduct=2339
> Feb 25 23:32:14 tonkachi kernel: [  100.851785] usb 2-4.1: New USB
> device strings: Mfr=1, Product=2, SerialNumber=5
> Feb 25 23:32:14 tonkachi kernel: [  100.851790] usb 2-4.1: Product: USB
> to ATA/ATAPI Bridge
> Feb 25 23:32:14 tonkachi kernel: [  100.851792] usb 2-4.1: Manufacturer:
> JMicron
> Feb 25 23:32:14 tonkachi kernel: [  100.851795] usb 2-4.1: SerialNumber:
> 6A1713351FFF
> Feb 25 23:32:14 tonkachi kernel: [  100.851873] usb 2-4.1: configuration
> #1 chosen from 1 choice
> Feb 25 23:32:14 tonkachi kernel: [  100.854283] xhci_hcd 0000:02:00.0:
> WARN: short transfer on control ep
> Feb 25 23:32:14 tonkachi kernel: [  100.855037] xhci_hcd 0000:02:00.0:
> WARN: short transfer on control ep
> Feb 25 23:32:14 tonkachi kernel: [  100.879271] Initializing USB Mass
> Storage driver...
> Feb 25 23:32:14 tonkachi kernel: [  100.879988] scsi6 : SCSI emulation
> for USB Mass Storage devices
> Feb 25 23:32:14 tonkachi kernel: [  100.880141] usbcore: registered new
> interface driver usb-storage
> Feb 25 23:32:14 tonkachi kernel: [  100.880147] USB Mass Storage support
> registered.
> Feb 25 23:32:19 tonkachi kernel: [  105.884853] scsi 6:0:0:0: CD-ROM
>         hp       DVDRAM GT20L     DC05 PQ: 0 ANSI: 0
> Feb 25 23:32:19 tonkachi kernel: <0: `MEM_WRITE_DWORD(3'b000,
> 32'hffffc90000hi0 00000.1fevhc anl0d0i  02-:e0x  t2);

> Feb 25 23:32:19 tonkachi kernel: x1.0:  _ca0 00000000 01000000 02038000
> Feb 25 23:32:19 tonkachi kernel: x1.0: `MEM_W_c70 000000 f__h:had
> c2c]:00-:e0x  t3);
> Feb 25 23:32:19 tonkachi kernel: _tist us:i 00Tx] 5b78b073ndxh0.0
> _c.]70h ]00t0:xhcf3) 754'hf);x.23000:02:00.0: `MEM_WRITE_DWORD(3'b000,
> 32'hffffc90000c7c024, 32'h8, 4'hf);
> Feb 25 23:32:19 tonkachi kernel: 603n00nt 0<05.898876] xhci_hcd
> 0000:00h00MEM_WRITE_10 wn.8eh:0c>78 0 i_0 013Ue9:020)
> Feb 25 23:32:19 tonkachi kernel: 02:00.i0h00.0: New dequeue pointer =
> 0x375b78d0 (DMA)
> Feb 25 23:32:19 tonkachi kernel: 19
> Feb 25 23:32:19 tonkachi kernel: 3d07` 300ee e_ i7c67 o5.899445] 9fc

It looks like you're getting log corruption from the xHCI driver being
too verbose now. :(  I've been meaning to make a log level patch for the
driver and cut out the less-than-useful bits for while.  Let me do a
quick pass at that so we can get the interesting information.

> with un-plugging, I get:
> 
> Feb 25 23:33:07 tonkachi kernel: [  153.205311] xhci_hcd 0000:02:00.0:
> WARN: transfer error on endpoint
> Feb 25 23:33:08 tonkachi kernel: [  154.008265] xhci_hcd 0000:02:00.0:
> WARN: transfer error on endpoint
> Feb 25 23:33:08 tonkachi kernel: [  154.008995] xhci_hcd 0000:02:00.0:
> WARN: transfer error on endpoint

There should be a lot more debugging here.  Perhaps you were collecting
only the warning-level kernel messages?  Did you send the full dmesg
from /var/log/kern.log or run `dmesg -n 8` before capturing the dmesg
input?

Actually, I wonder if 2.6.32 stable needs commit bcef3fd from 2.6.33.
If the xHCI driver wasn't cleaning up the endpoint rings properly after
a transfer error, I suppose the hardware could get wedged.

> at this point, rmmod xhci doesn't even work anymore, I get stuff during
> / around the rmmod like:
> 
> Feb 25 23:34:24 tonkachi kernel: [  230.133711] xhci_hcd 0000:02:00.0:
> remove, state 1

Aw, man, it looks like your xHCI disconnected from the bus.  Something
was seriously wrong with the hardware.  Still, the xHCI driver should
have failed gracefully in that case.  That should have been handled by
commits c526d0d, e34b2fb, and e4ab05d, which are in 2.6.32 and 2.6.33.

> Feb 25 23:34:24 tonkachi kernel: [  230.133727] usb usb2: USB
> disconnect, address 1
> Feb 25 23:34:24 tonkachi kernel: [  230.133731] usb 2-4: USB disconnect,
> address 2
> Feb 25 23:34:24 tonkachi kernel: [  230.133735] usb 2-4.1: USB
> disconnect, address 3
> 
> 
> 
> at the end, with rmmod still not returning, but doing a re-plug, I get:
> 
> 
> Feb 25 23:36:37 tonkachi kernel: [  363.295298] rmmod         D
> ffff88002834fa28     0  2818   2802 0x00000004
> Feb 25 23:36:37 tonkachi kernel: [  363.295307]  ffff88022f581b88
> 0000000000000086 0000000000000000 0000000000000282
> Feb 25 23:36:37 tonkachi kernel: [  363.295315]  00000000fffffffe
> ffffffff81a0bf78 ffff88023fc3c8a0 00000000ffffe4be
> Feb 25 23:36:37 tonkachi kernel: [  363.295323]  ffff8802332403c0
> ffff88022f581fd8 000000000000fa28 ffff8802332403c0
> Feb 25 23:36:37 tonkachi kernel: [  363.295331] Call Trace:
> Feb 25 23:36:37 tonkachi kernel: [  363.295344]  [<ffffffff813b3ff5>]
> usb_kill_urb+0x85/0xc0
> Feb 25 23:36:37 tonkachi kernel: [  363.295353]  [<ffffffff8107d8b0>] ?
> autoremove_wake_function+0x0/0x40
> Feb 25 23:36:37 tonkachi kernel: [  363.295360]  [<ffffffff813b43c6>] ?
> usb_get_urb+0x16/0x20
> Feb 25 23:36:37 tonkachi kernel: [  363.295367]  [<ffffffff813b27db>]
> usb_hcd_flush_endpoint+0xcb/0x1b0
> Feb 25 23:36:37 tonkachi kernel: [  363.295374]  [<ffffffff813b4d18>]
> usb_disable_endpoint+0x58/0x90
> Feb 25 23:36:37 tonkachi kernel: [  363.295381]  [<ffffffff813b4dd9>]
> usb_disable_device+0x89/0x1f0
> Feb 25 23:36:37 tonkachi kernel: [  363.295388]  [<ffffffff813adc3d>]
> usb_disconnect+0xfd/0x180
> Feb 25 23:36:37 tonkachi kernel: [  363.295394]  [<ffffffff813adbff>]
> usb_disconnect+0xbf/0x180
> Feb 25 23:36:37 tonkachi kernel: [  363.295400]  [<ffffffff813b1a5d>]
> usb_remove_hcd+0xcd/0x130
> Feb 25 23:36:37 tonkachi kernel: [  363.295408]  [<ffffffff813c2236>]
> usb_hcd_pci_remove+0x26/0xa0
> Feb 25 23:36:37 tonkachi kernel: [  363.295416]  [<ffffffff812a0fdf>]
> pci_device_remove+0x2f/0x60
> Feb 25 23:36:37 tonkachi kernel: [  363.295433]  [<ffffffff81334bd3>]
> __device_release_driver+0x53/0xb0
> Feb 25 23:36:37 tonkachi kernel: [  363.295440]  [<ffffffff81334cf8>]
> driver_detach+0xc8/0xd0
> Feb 25 23:36:37 tonkachi kernel: [  363.295448]  [<ffffffff81333c65>]
> bus_remove_driver+0x85/0xe0
> Feb 25 23:36:37 tonkachi kernel: [  363.295456]  [<ffffffff813352ba>]
> driver_unregister+0x5a/0x90
> Feb 25 23:36:37 tonkachi kernel: [  363.295464]  [<ffffffff812a12d0>]
> pci_unregister_driver+0x40/0xb0
> Feb 25 23:36:37 tonkachi kernel: [  363.295476]  [<ffffffffa0048b80>]
> xhci_unregister_pci+0x10/0x20 [xhci]
> Feb 25 23:36:37 tonkachi kernel: [  363.295485]  [<ffffffffa004e459>]
> xhci_hcd_cleanup+0x9/0xb [xhci]
> Feb 25 23:36:37 tonkachi kernel: [  363.295493]  [<ffffffff81095768>]
> sys_delete_module+0x1a8/0x270
> Feb 25 23:36:37 tonkachi kernel: [  363.295500]  [<ffffffff81081bd9>] ?
> up_read+0x9/0x10
> Feb 25 23:36:37 tonkachi kernel: [  363.295510]  [<ffffffff81011f82>]
> system_call_fastpath+0x16/0x1b

If the hardware wasn't responding properly to commands, then URBs
wouldn't have been able to be killed, the USB core would have sat around
waiting on those URBs, and rmmod could never exit.  I need a more
detailed log to figure out exactly why the hardware is wedged though.
Let me make the less-verbose debugging patch so you don't get log
corruption, and then we'll see what's going on.

Sarah Sharp
