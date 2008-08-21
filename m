Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbYHUVCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbYHUVCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbYHUVCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:02:40 -0400
Received: from n6b.bullet.mail.ac4.yahoo.com ([76.13.13.76]:46127 "HELO
	n6b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756117AbYHUVCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:02:38 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 180240.75401.bm@omp103.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=t//27GkWfLhKsLvLyTXcJxmc2H1PougYY67IAI3IqAiar8USxHAhFd+bTvN7yNTnVTKDPXZOGu/9dUm5GPXI1RGnryggnOzNS8y8+SP49YXk/gU5MtBtcO9MXwwGancXQmXql9zQRP3vhnstCIQAUv4CCwkQwb8avVTAP7SSpco=;
X-Mailer: YahooMailWebService/0.7.218
Date: Thu, 21 Aug 2008 14:02:35 -0700 (PDT)
From: amruth <amruth_pv@yahoo.com>
Reply-To: amruth_pv@yahoo.com
Subject: USB Serial device disconnect causes IRQ disable details captured
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200808210828.08182.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <318135.65419.qm@web45201.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
Oliver
I got the same issue once again. I have captured detail log and lusb -t with interrupts.
cat /proc/interrupts:

          CPU0       CPU1
  0:         86          0   IO-APIC-edge      timer
  1:       2355          0   IO-APIC-edge      i8042
  3:          2          0   IO-APIC-edge
  4:          4          0   IO-APIC-edge
  6:          7          0   IO-APIC-edge      floppy
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          4          0   IO-APIC-edge      i8042
 14:      13715          0   IO-APIC-edge      ide0
 15:      33574          0   IO-APIC-edge      ide1
 16:        598          0   IO-APIC-fasteoi   uhci_hcd:usb2, uhci_hcd:usb5
 18:          5          0   IO-APIC-fasteoi   ata_piix, uhci_hcd:usb4
 19:         52          0   IO-APIC-fasteoi   uhci_hcd:usb3
 23:        326     199675   IO-APIC-fasteoi   ehci_hcd:usb1
NMI:          0          0   Non-maskable interrupts
LOC:      77657     131843   Local timer interrupts
RES:      14882      15086   Rescheduling interrupts
CAL:        136        490   function call interrupts
TLB:      10750       2825   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0

lsusb -t:
Bus#  5
`-Dev#   1 Vendor 0x1d6b Product 0x0001
Bus#  4
`-Dev#   1 Vendor 0x1d6b Product 0x0001
Bus#  3
`-Dev#   1 Vendor 0x1d6b Product 0x0001
  `-Dev#   2 Vendor 0x413c Product 0x3010
Bus#  2
`-Dev#   1 Vendor 0x1d6b Product 0x0001
Bus#  1
`-Dev#   1 Vendor 0x1d6b Product 0x0002

dmesg:
sb 1-5: Magtek 75/Excella USB card reader converter now attached to ttyUSB1
drivers/usb/core/inode.c: creating file '012'
usb 1-5: New USB device found, idVendor=0801, idProduct=2231
usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5: Product: STX
usb 1-5: Manufacturer: MagTek
usb 1-5: SerialNumber: STX001
usb 2-2: uhci_result_common: failed with status 440000
/home/amr/linux-2.6.26/drivers/usb/serial/magtek.c: magtek_read_int_callback - p
ort 0
uhci_hcd 0000:00:1d.0: release dev 6 ep81-INT, period 8, phase 4, 61 us
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
uhci_hcd 0000:00:1d.0: port 2 portsc 008a,00
hub 2-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
usb 2-2: USB disconnect, address 6
usb 2-2: unregistering device
usb 2-2: usb_disable_device nuking all URBs
usb 2-2: unregistering interface 2-2:1.0
/home/amr/linux-2.6.26/drivers/usb/serial/magtek.c: magtek_shutdown
magtek ttyUSB0: Magtek 75/Excella USB card reader converter now disconnected from ttyUSB0
magtek 2-2:1.0: device disconnected
usb 2-2:1.0: uevent
usb 2-2: uevent
hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
usb usb2: suspend_rh (auto-stop)
ehci_hcd 0000:00:1d.7: devpath 5 ep2in 3strikes
/home/amr/linux-2.6.26/drivers/usb/serial/magtek.c: magtek_read_int_callback - port 1
usb 1-5: unlink qh0-00ff/dec56380 start 0 [1/0 us]
usb 1-5: link qh0-00ff/dec56380 start 0 [1/0 us]
usb 1-5: unlink qh0-00ff/dec56380 start 0 [1/0 us]
ehci_hcd 0000:00:1d.7: HC died; cleaning up
hub 1-0:1.0: state 0 ports 8 chg 0000 evt 0000
usb 1-4: USB disconnect, address 4
usb 1-4: unregistering device
usb 1-4: usb_disable_device nuking all URBs
usb 1-4: unregistering interface 1-4:1.0
usb 1-4:1.0: uevent
usb 1-4: uevent
usb 1-5: USB disconnect, address 12
usb 1-5: unregistering device
usb 1-4: usb_disable_device nuking all URBs
usb 1-4: unregistering interface 1-4:1.0
usb 1-4:1.0: uevent
usb 1-4: uevent
usb 1-5: USB disconnect, address 12
usb 1-5: unregistering device
usb 1-5: usb_disable_device nuking all URBs
usb 1-5: unregistering interface 1-5:1.0
/home/amr/linux-2.6.26/drivers/usb/serial/magtek.c: magtek_shutdown
magtek ttyUSB1: Magtek 75/Excella USB card reader converter now disconnected from ttyUSB1
magtek 1-5:1.0: device disconnected
usb 1-5:1.0: uevent
usb 1-5: uevent
irq 23: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.26kdbkgdb #1
 [<c0140300>] __report_bad_irq+0x2e/0x6f
 [<c0140514>] note_interrupt+0x1d3/0x207
 [<c013fa8a>] ? handle_IRQ_event+0x21/0x48
 [<c0140c3c>] handle_fasteoi_irq+0x8a/0xaa
 [<c010577e>] do_IRQ+0x71/0x8b
 [<c01024d4>] ? default_idle+0x0/0x42
 [<c010417b>] common_interrupt+0x23/0x28
 [<c01024d4>] ? default_idle+0x0/0x42
 [<c01024d4>] ? default_idle+0x0/0x42
 [<c0102405>] ? cpu_idle+0x4e/0xac
 [<c043ed6e>] start_secondary+0x156/0x15b
 =======================
handlers:
[<c0353bb7>] (usb_hcd_irq+0x0/0x58)
Disabling IRQ #23

Please let me know what might have caused this to fail.

Thanks
Amruth p.v


--- On Thu, 8/21/08, Oliver Neukum <oliver@neukum.org> wrote:

> From: Oliver Neukum <oliver@neukum.org>
> Subject: Re: USB Serial device disconnect causes IRQ disable
> To: amruth_pv@yahoo.com
> Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Thursday, August 21, 2008, 1:28 AM
> Am Donnerstag 21 August 2008 08:18:38 schrieb amruth:
> > > OK, do you have any other USB device on the same
> bus as
> > > your serial
> > > converter?
> > I have one USB storage flash key device nothing else.
> > The problem is coming from serial convertor and my
> driver did not handle interrupts.
> 
> But is this key on the same bus? What does "lsusb
> -t" say?
> Your driver is USB, isn't it? It cannot fail to handle
> PCI interrupts.
> There may be something fishy here.
> 
> 	Regards
> 		Oliver
> --
> To unsubscribe from this list: send the line
> "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html


      

