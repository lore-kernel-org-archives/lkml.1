Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbXIXGdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbXIXGdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 02:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbXIXGdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 02:33:40 -0400
Received: from tag.witbe.net ([81.88.96.48]:49126 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbXIXGdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 02:33:39 -0400
Date: Mon, 24 Sep 2007 08:33:36 +0200
From: Paul Rolland (=?UTF-8?Q?=E3=83=9D=E3=83=BC=E3=83=AB=E3=83=BB?=
	=?UTF-8?Q?=E3=83=AD=E3=83=A9=E3=83=B3?=) <rol@witbe.net>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Cc: rol@witbe.net
Subject: 2.6.23-rc7 - _random_ IRQ23 : nobody cared
Message-ID: <20070924083336.7a08fd61@tux.DEF.witbe.net>
Organization: Witbe.net
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I already reported kernel 2.6.23-rcX warning about irq X : nobody cared, and
it seemed to have been fixed in 2.6.23-rc6... Unfortunately, just rebooting
with my 2.6.23-rc7, I got it appearing again, though the previous boot was
just fine, and I didn't change/recompile my kernel in between.

So, what changed ? I've compiled two modules : qc-usb-messenger, and
hsf-modem, to make sure all my hardware is fully supported.

And now, I have :
....
scsi 3:0:1:0: Direct-Access     ATA      ST3500641AS      3.AA PQ: 0 ANSI: 5 
sd 3:0:1:0: [sdd] 976773168 512-byte hardware sectors (500108 MB) 
sd 3:0:1:0: [sdd] Write Protect is off 
sd 3:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support
DPO or FUA 
sd 3:0:1:0: [sdd] 976773168 512-byte hardware sectors (500108 MB) 
sd 3:0:1:0: [sdd] Write Protect is off 
sd 3:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support
DPO or FUA 
irq 23: nobody cared (try booting with the "irqpoll" option) 
 
Call Trace: 
 <IRQ>  [<ffffffff8105d21b>] __report_bad_irq+0x30/0x72 
 [<ffffffff8105d46c>] note_interrupt+0x20f/0x253 
 [<ffffffff8105dd38>] handle_fasteoi_irq+0xa9/0xd1 
 [<ffffffff8100ec65>] do_IRQ+0xf1/0x160 
 [<ffffffff8100b25b>] mwait_idle+0x0/0x45 
 [<ffffffff8100c431>] ret_from_intr+0x0/0xa 
 <EOI>  [<ffffffff8100b29d>] mwait_idle+0x42/0x45 
 [<ffffffff8100b1f3>] cpu_idle+0xbd/0xe0 
 [<ffffffff8175ca8e>] start_kernel+0x2bb/0x2c7 
 [<ffffffff8175c140>] _sinittext+0x140/0x144 
 
handlers: 
[<ffffffff81307485>] (ata_interrupt+0x0/0x1d3) 
Disabling IRQ #23 
 sdd:<3>ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen 
ata4.01: cmd c8/00:08:00:00:00/00:00:00:00:00/f0 tag 0 cdb 0x0 data 4096 in 
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout) 
ata4: soft resetting port 
ata4.01: qc timeout (cmd 0x27) 
ata4.01: ata_hpa_resize 1: hpa sectors (0) is smaller than sectors
(976773168) ata4.00: failed to IDENTIFY (I/O error, err_mask=0x40) 
ata4: failed to recover some devices, retrying in 5 secs 
ata4: soft resetting port 
ata4.01: qc timeout (cmd 0x27) 

....


Booting with irqpoll is Ok, and I have :

2 [14:55] rol@donald:~> cat /proc/interrupts 
           CPU0       CPU1       
  0:      31263          0   IO-APIC-edge      timer
  1:        201          0   IO-APIC-edge      i8042
  4:        219          0   IO-APIC-edge      serial
  6:          5          0   IO-APIC-edge      floppy
  8:          1          0   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 12:        129       1124   IO-APIC-edge      i8042
 14:       7010       1235   IO-APIC-edge      libata
 15:          0          0   IO-APIC-edge      libata
 17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 19:       4250          0   IO-APIC-fasteoi   uhci_hcd:usb5, HDA Intel
 20:       1251         44   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
 21:        422        640   IO-APIC-fasteoi   pata_pdc2027x, firewire_ohci
 23:      24023          0   IO-APIC-fasteoi   libata, hsfpcibasic2
378:         93        108   PCI-MSI-edge      eth0
379:          1          0   PCI-MSI-edge      eth1
NMI:          0          0 
LOC:      31000      30803 
ERR:          0

Hell, IRQ 23 is shared between libata and my modem !!!

OK, just reboot, and see what happens.... Cool, now it is booting fine, 
no more complaint, even without irqpoll, IRQ 23 still shared...
Another one, and Ok again... So, this looks really random :(

Anything I could do to try to collect usefull traces ?

Paul
