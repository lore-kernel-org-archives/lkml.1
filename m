Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934303Ab0BYWhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:37:43 -0500
Received: from perec.tyrell.hu ([66.197.149.104]:52386 "EHLO perec.tyrell.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934167Ab0BYWhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:37:41 -0500
Message-ID: <4B86FBB0.1080104@maroy.hu>
Date: Thu, 25 Feb 2010 23:37:36 +0100
From: =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <akos@maroy.hu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device 8087:0020
References: <20100225190452.GA4184@xanatos> <Pine.LNX.4.44L0.1002251430470.1686-100000@iolanthe.rowland.org> <20100225195249.GA5245@xanatos>
In-Reply-To: <20100225195249.GA5245@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sarah,

> True.  I can't tell exactly what's going on without
> CONFIG_USB_XHCI_HCD_DEBUGGING.  It's possible the xHCI host never
> notified the driver of the disconnect, or there's a bug in the xHCI hub
> emulation code.

after having turned this option on in the kernel, this is what I get
when plugging in the device:

Feb 25 23:32:14 tonkachi kernel: [  100.473783] Registered led device:
iwl-phy0::radio
Feb 25 23:32:14 tonkachi kernel: [  100.473812] Registered led device:
iwl-phy0::assoc
Feb 25 23:32:14 tonkachi kernel: [  100.473839] Registered led device:
iwl-phy0::RX
Feb 25 23:32:14 tonkachi kernel: [  100.473864] Registered led device:
iwl-phy0::TX
Feb 25 23:32:14 tonkachi kernel: [  100.497848] usb 2-4: new high speed
USB device using xhci_hcd and address 0
Feb 25 23:32:14 tonkachi kernel: [  100.520591] usb 2-4: New USB device
found, idVendor=058f, idProduct=6254
Feb 25 23:32:14 tonkachi kernel: [  100.520595] usb 2-4: New USB device
strings: Mfr=0, Product=0, SerialNumber=0
Feb 25 23:32:14 tonkachi kernel: [  100.520680] usb 2-4: configuration
#1 chosen from 1 choice
Feb 25 23:32:14 tonkachi kernel: [  100.520732] usb 2-4: ep 0x81 -
rounding interval to 2048 microframes
Feb 25 23:32:14 tonkachi kernel: [  100.522403] hub 2-4:1.0: USB hub found
Feb 25 23:32:14 tonkachi kernel: [  100.522930] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 23:32:14 tonkachi kernel: [  100.523156] hub 2-4:1.0: 3 ports
detected
Feb 25 23:32:14 tonkachi kernel: [  100.825758] usb 2-4.1: new high
speed USB device using xhci_hcd and address 0
Feb 25 23:32:14 tonkachi kernel: [  100.848327] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 23:32:14 tonkachi kernel: [  100.849375] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 23:32:14 tonkachi kernel: [  100.850370] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 23:32:14 tonkachi kernel: [  100.851366] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 23:32:14 tonkachi kernel: [  100.851782] usb 2-4.1: New USB
device found, idVendor=152d, idProduct=2339
Feb 25 23:32:14 tonkachi kernel: [  100.851785] usb 2-4.1: New USB
device strings: Mfr=1, Product=2, SerialNumber=5
Feb 25 23:32:14 tonkachi kernel: [  100.851790] usb 2-4.1: Product: USB
to ATA/ATAPI Bridge
Feb 25 23:32:14 tonkachi kernel: [  100.851792] usb 2-4.1: Manufacturer:
JMicron
Feb 25 23:32:14 tonkachi kernel: [  100.851795] usb 2-4.1: SerialNumber:
6A1713351FFF
Feb 25 23:32:14 tonkachi kernel: [  100.851873] usb 2-4.1: configuration
#1 chosen from 1 choice
Feb 25 23:32:14 tonkachi kernel: [  100.854283] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 23:32:14 tonkachi kernel: [  100.855037] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 23:32:14 tonkachi kernel: [  100.879271] Initializing USB Mass
Storage driver...
Feb 25 23:32:14 tonkachi kernel: [  100.879988] scsi6 : SCSI emulation
for USB Mass Storage devices
Feb 25 23:32:14 tonkachi kernel: [  100.880141] usbcore: registered new
interface driver usb-storage
Feb 25 23:32:14 tonkachi kernel: [  100.880147] USB Mass Storage support
registered.
Feb 25 23:32:19 tonkachi kernel: [  105.884853] scsi 6:0:0:0: CD-ROM
        hp       DVDRAM GT20L     DC05 PQ: 0 ANSI: 0
Feb 25 23:32:19 tonkachi kernel: <0: `MEM_WRITE_DWORD(3'b000,
32'hffffc90000hi0 00000.1fevhc anl0d0i  02-:e0x  t2);
Feb 25 23:32:19 tonkachi kernel: x1.0:  _ca0 00000000 01000000 02038000
Feb 25 23:32:19 tonkachi kernel: x1.0: `MEM_W_c70 000000 f__h:had
c2c]:00-:e0x  t3);
Feb 25 23:32:19 tonkachi kernel: _tist us:i 00Tx] 5b78b073ndxh0.0
_c.]70h ]00t0:xhcf3) 754'hf);x.23000:02:00.0: `MEM_WRITE_DWORD(3'b000,
32'hffffc90000c7c024, 32'h8, 4'hf);
Feb 25 23:32:19 tonkachi kernel: 603n00nt 0<05.898876] xhci_hcd
0000:00h00MEM_WRITE_10 wn.8eh:0c>78 0 i_0 013Ue9:020)
Feb 25 23:32:19 tonkachi kernel: 02:00.i0h00.0: New dequeue pointer =
0x375b78d0 (DMA)
Feb 25 23:32:19 tonkachi kernel: 19
Feb 25 23:32:19 tonkachi kernel: 3d07` 300ee e_ i7c67 o5.899445] 9fc
Crned from h:0t8]__0td h096:: cs0000c63,v 005a/ed scsi  0
0dd00M_WRITE_DWORD(3'b000, 32'h50ns 01en2  ]]h00s0n/27 00670009[
903541] xhci0 00:_WRITE_DWORD(3'b000, 32'hffffc90000c7c024, 32'h8, 4'hf);
Feb 25 23:32:19 tonkachi kernel: n (D005.r0000:024 0
0dd00M_WRITE_DWORD(3'b000, 32'hffffc950ns0en2   ]]h00s0n/57 0067009[
907215] x0 0_WRITE_DWORD(3'b000, 32'hffffc90000c7c024, 32'h8, 4'hf);
Feb 25 23:32:19 tonkachi kernel: = 0i_hcd 0000:02:00.0:
`MEM_WRITE_DWORD(3'b000, 32'hffffc90000c7c808, 32'h3, 4'hf);
Feb 25 23:32:19 tonkachi kernel: n (D00090.rom0000:024 0
0dd00M_WRITE_DWORD(3'b000, 32'hffffc90000c50ns 09en2   ]]h00s0n/97
00670009[  910899] x0 00:_WRITE_DWORD(3'b000, 32'hffffc90000c7c024,
32'h8, 4'hf);
Feb 25 23:32:19 tonkachi kernel: T5nt d:h0  c:0s0n/57 00.0I67009[
916128] x0 00:0_WRITE_DWORD(3'b000, 32'hffffc90000c7c024, 32'h8, 4'hf);
Feb 25 23:32:19 tonkachi kernel: 6 3]0D0xhci8hci_
0000:02:040]1000:02:00.0: In handle_tx_event
Feb 25 23:32:19 tonkachi kernel: [  105.922881] xhci_hcd0hch0:
`MEM_WRI>f0OS _tx.0:c0990c_xh.0 8b0002c= 0>DMA)>[  105.92000000ht0lo>2f
:n0e0cf0c40.09400[._> ee_1<0a1r000c700.xhci_hcd 0000:02:00.0: Endpoint
state = 0x1
Feb 25 23:32:19 tonkachi kernel: 2:0:00.0: In xhci_handle_event
Feb 25 23:32:19 tonkachi kernel: 19b lnd 6] :000 020300.0ic_ nn
=f0x10[10105.926503] xhci_hcd 0000:02:00.0: Event ring deq =  02hc::;3(:
c7c.r80h 1_d7  10xx.]0477x.:EWx 6:00>[ 5750c>000.0: @37805720 375b7a30
00`7>ff5.936369] 7dx0 0_e0 :434h1:EWx 6:007>[300700000.0: @37805730 37
<h05.936744] xhci_hcd 0000:02:00.0: xhci_handle_event - OS owns TRB
Feb 25 23:32:19 tonkachi kernel:
Feb 25 23:32:19 tonkachi kernel: 025<)nE_DW0vev8 urb= 0x1
Feb 25 23:32:19 tonkachi kernel: <750.07<h05.937960] xhci_hcd
0000:02:00.0: xhci_handle_event - OS owns TRB
Feb 25 23:32:19 tonkachi kernel:
Feb 25 23:32:19 tonkachi kernel: 025<)[nE_D0veve8 urb= 0x1
Feb 25 23:32:19 tonkachi kernel:
Feb 25 23:32:19 tonkachi kernel: 025<)[nE_D0vev8 urb= 0x1
Feb 25 23:32:19 tonkachi kernel: <750c.07<h05.945270] xhci_hcd
0000:02:00.0: xhci_handle_event - OS owns TRB
Feb 25 23:32:19 tonkachi kernel: se0D]<7>090<c xh: `MEM0'vcd
0000:02:00.0: xhci_handle_event - calling handle_tx_event
Feb 25 23:32:19 tonkachi kernel: <0.0: @37805430 375b7ad0 0,T:7>xhih [c
Feb 25 23:32:19 tonkachi kernel: 7x140 i6b 6:00l38,0.0:3]
xhci_01ie5R'vecd 0000:02:00.0: xhci_handle_event - calling handle_tx_event
Feb 25 23:32:19 tonkachi kernel: se0( 0:020i_h t  dma_hcd 0000:02:00.0:
`M50537805460 375i8R 05c 005.0 7c0  c0c[f0:
Feb 25 23:32:19 tonkachi kernel: <370oinhcd 005107805470 375b7b00
00000000 01000000 02038001
Feb 25 23:32:19 tonkachi kernel: <37800ointhcd 0000:15.17805480
375d61f_,DI5d00019
Feb 25 23:32:19 tonkachi kernel: 1>d4x2d0i f: c
Feb 25 23:32:19 tonkachi kernel: 370oinhcd 0000:2i
Feb 25 23:32:19 tonkachi kernel: 00f[ 02:00.0: xhci_handle_event -
calling handle_tx_event
Feb 25 23:32:19 tonkachi kernel: 370ohcd 0051078054c0 375b7b30 00000000
01000000 02038001
Feb 25 23:32:20 tonkachi kernel: 37800ohcd 00005.178054d0 _,DI5.d 00009
Feb 25 23:32:20 tonkachi kernel: 1>d8x2d0i f:c
Feb 25 23:32:20 tonkachi kernel: 3780x4en = 0f1uh:5178054e0 375b7b40
00000000 01000000 0203800_,DI5d 00019
Feb 25 23:32:20 tonkachi kernel: 1>d62c0c f: Gc
Feb 25 23:32:20 tonkachi kernel: 37800oinhcd 0000:5.178054f0 375b7b50
00000000 01000000 02038001
Feb 25 23:32:20 tonkachi kernel: 1>d3x2c0c f: c
Feb 25 23:32:20 tonkachi kernel: 37800ohcd 0000:02:00.0: `M5.17805500
_,DIn5d00029
Feb 25 23:32:20 tonkachi kernel: 1>d8x2d0i f:
Feb 25 23:32:20 tonkachi kernel: 3780ohcd 00084nt0'3n 0000:02:00.0:
xhci_handle_event - calling handle_tx_event
Feb 25 23:32:20 tonkachi kernel: 60#hc
Feb 25 23:32:20 tonkachi kernel: : d A)  105.965349] xhci_hcd0cic:
`MEM_WR[c.S1tx00i
Feb 25 23:32:20 tonkachi kernel: 669dh8c001,a0:7 0[MA[  10hh0:
`MEM_WRITE_DWORD(3'b000, 32'hffffc90000c7c024, 32'h8, 4'hf);
Feb 25 23:32:20 tonkachi kernel: [  106.005103] xhci_hcd 0000:02:00.0:
WARN: Stalled endpoint
Feb 25 23:32:22 tonkachi kernel: <7008.h8Dhr:0:0248 ]0 158e 3x)
0nsf:02:00.0: Event ring deq =t867n = 13, sa008hc11Dhr:0:0209 ]0 198pe
00s)n:02:0t97cn = 31, status = 0
Feb 25 23:32:22 tonkachi kernel: 0i4<1= TfC (f>es uhcd 0000:  f86c0, len
= 18, status = 0



with un-plugging, I get:

Feb 25 23:33:07 tonkachi kernel: [  153.205311] xhci_hcd 0000:02:00.0:
WARN: transfer error on endpoint
Feb 25 23:33:08 tonkachi kernel: [  154.008265] xhci_hcd 0000:02:00.0:
WARN: transfer error on endpoint
Feb 25 23:33:08 tonkachi kernel: [  154.008995] xhci_hcd 0000:02:00.0:
WARN: transfer error on endpoint



at this point, rmmod xhci doesn't even work anymore, I get stuff during
/ around the rmmod like:

Feb 25 23:34:24 tonkachi kernel: [  230.133711] xhci_hcd 0000:02:00.0:
remove, state 1
Feb 25 23:34:24 tonkachi kernel: [  230.133727] usb usb2: USB
disconnect, address 1
Feb 25 23:34:24 tonkachi kernel: [  230.133731] usb 2-4: USB disconnect,
address 2
Feb 25 23:34:24 tonkachi kernel: [  230.133735] usb 2-4.1: USB
disconnect, address 3



at the end, with rmmod still not returning, but doing a re-plug, I get:


Feb 25 23:36:37 tonkachi kernel: [  363.295298] rmmod         D
ffff88002834fa28     0  2818   2802 0x00000004
Feb 25 23:36:37 tonkachi kernel: [  363.295307]  ffff88022f581b88
0000000000000086 0000000000000000 0000000000000282
Feb 25 23:36:37 tonkachi kernel: [  363.295315]  00000000fffffffe
ffffffff81a0bf78 ffff88023fc3c8a0 00000000ffffe4be
Feb 25 23:36:37 tonkachi kernel: [  363.295323]  ffff8802332403c0
ffff88022f581fd8 000000000000fa28 ffff8802332403c0
Feb 25 23:36:37 tonkachi kernel: [  363.295331] Call Trace:
Feb 25 23:36:37 tonkachi kernel: [  363.295344]  [<ffffffff813b3ff5>]
usb_kill_urb+0x85/0xc0
Feb 25 23:36:37 tonkachi kernel: [  363.295353]  [<ffffffff8107d8b0>] ?
autoremove_wake_function+0x0/0x40
Feb 25 23:36:37 tonkachi kernel: [  363.295360]  [<ffffffff813b43c6>] ?
usb_get_urb+0x16/0x20
Feb 25 23:36:37 tonkachi kernel: [  363.295367]  [<ffffffff813b27db>]
usb_hcd_flush_endpoint+0xcb/0x1b0
Feb 25 23:36:37 tonkachi kernel: [  363.295374]  [<ffffffff813b4d18>]
usb_disable_endpoint+0x58/0x90
Feb 25 23:36:37 tonkachi kernel: [  363.295381]  [<ffffffff813b4dd9>]
usb_disable_device+0x89/0x1f0
Feb 25 23:36:37 tonkachi kernel: [  363.295388]  [<ffffffff813adc3d>]
usb_disconnect+0xfd/0x180
Feb 25 23:36:37 tonkachi kernel: [  363.295394]  [<ffffffff813adbff>]
usb_disconnect+0xbf/0x180
Feb 25 23:36:37 tonkachi kernel: [  363.295400]  [<ffffffff813b1a5d>]
usb_remove_hcd+0xcd/0x130
Feb 25 23:36:37 tonkachi kernel: [  363.295408]  [<ffffffff813c2236>]
usb_hcd_pci_remove+0x26/0xa0
Feb 25 23:36:37 tonkachi kernel: [  363.295416]  [<ffffffff812a0fdf>]
pci_device_remove+0x2f/0x60
Feb 25 23:36:37 tonkachi kernel: [  363.295433]  [<ffffffff81334bd3>]
__device_release_driver+0x53/0xb0
Feb 25 23:36:37 tonkachi kernel: [  363.295440]  [<ffffffff81334cf8>]
driver_detach+0xc8/0xd0
Feb 25 23:36:37 tonkachi kernel: [  363.295448]  [<ffffffff81333c65>]
bus_remove_driver+0x85/0xe0
Feb 25 23:36:37 tonkachi kernel: [  363.295456]  [<ffffffff813352ba>]
driver_unregister+0x5a/0x90
Feb 25 23:36:37 tonkachi kernel: [  363.295464]  [<ffffffff812a12d0>]
pci_unregister_driver+0x40/0xb0
Feb 25 23:36:37 tonkachi kernel: [  363.295476]  [<ffffffffa0048b80>]
xhci_unregister_pci+0x10/0x20 [xhci]
Feb 25 23:36:37 tonkachi kernel: [  363.295485]  [<ffffffffa004e459>]
xhci_hcd_cleanup+0x9/0xb [xhci]
Feb 25 23:36:37 tonkachi kernel: [  363.295493]  [<ffffffff81095768>]
sys_delete_module+0x1a8/0x270
Feb 25 23:36:37 tonkachi kernel: [  363.295500]  [<ffffffff81081bd9>] ?
up_read+0x9/0x10
Feb 25 23:36:37 tonkachi kernel: [  363.295510]  [<ffffffff81011f82>]
system_call_fastpath+0x16/0x1b




please let me know what other debugging I should do..


Akos
