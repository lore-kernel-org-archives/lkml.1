Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbYHaJO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbYHaJO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 05:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbYHaJOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 05:14:20 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:38021 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbYHaJOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 05:14:18 -0400
X-Greylist: delayed 1955 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Aug 2008 05:14:18 EDT
Date: Sun, 31 Aug 2008 10:41:36 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Bug #11358] net: forcedeth call restore mac addr in
	nv_shutdown path
Message-ID: <20080831084135.GA2698@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Jeff Garzik <jeff@garzik.org>, Yinghai Lu <yhlu.kernel@gmail.com>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik> <N8SeMoDzuxC.A.nFF.0ibuIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <N8SeMoDzuxC.A.nFF.0ibuIB@albercik>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11358
> Subject		: net: forcedeth call restore mac addr in nv_shutdown path
> Submitter	: Yinghai Lu <yhlu.kernel@gmail.com>
> Date		: 2008-08-17 3:30 (14 days old)
> References	: http://marc.info/?l=linux-kernel&m=121894389018584&w=4
> Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>
> Patch		: http://marc.info/?l=linux-kernel&m=121894389018584&w=4

I got around to try kexec and found that on 2.6.27-rc5, without
Yinghai Lu's patch, when I kexec while forecdeth is loaded I get the
following when the new kernel tries to load the module (on my Asus
M2N-SLI Deluxe):

|Aug 31 10:10:42 melchior kernel: [   10.578053] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
|Aug 31 10:10:42 melchior kernel: [   10.578256] forcedeth 0000:00:08.0: BAR 0: error updating (0xfe02a000 != 0x000000)
|Aug 31 10:10:42 melchior kernel: [   10.580901] forcedeth 0000:00:08.0: enabling device (0000 -> 0003)
|Aug 31 10:10:42 melchior kernel: [   10.581405] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
|Aug 31 10:10:42 melchior kernel: [   10.581509] forcedeth 0000:00:08.0: PCI INT A -> Link[APCH] -> GSI 22 (level, low) -> IRQ 22
|Aug 31 10:10:42 melchior kernel: [   10.581699] forcedeth 0000:00:08.0: setting latency timer to 64
|Aug 31 10:10:42 melchior kernel: [   10.581748] forcedeth 0000:00:08.0: Invalid Mac address detected: ff:ff:ff:ff:ff:ff
|Aug 31 10:10:42 melchior kernel: [   10.581936] forcedeth 0000:00:08.0: Please complain to your hardware vendor. Switching to a random MAC.
|Aug 31 10:10:42 melchior kernel: [   15.981960] forcedeth 0000:00:08.0: open: Could not find a valid PHY.
|Aug 31 10:10:42 melchior kernel: [   15.982131] forcedeth 0000:00:08.0: PCI INT A disabled
|Aug 31 10:10:42 melchior kernel: [   15.982283] forcedeth: probe of 0000:00:08.0 failed with error -12
|Aug 31 10:10:42 melchior kernel: [   16.017545] forcedeth 0000:00:09.0: BAR 0: error updating (0xfe027000 != 0x000000)
|Aug 31 10:10:42 melchior kernel: [   16.017766] forcedeth 0000:00:09.0: enabling device (0000 -> 0003)
|Aug 31 10:10:42 melchior kernel: [   16.018720] ACPI: PCI Interrupt Link [AMC1] enabled at IRQ 21
|Aug 31 10:10:42 melchior kernel: [   16.018839] forcedeth 0000:00:09.0: PCI INT A -> Link[AMC1] -> GSI 21 (level, low) -> IRQ 21
|Aug 31 10:10:42 melchior kernel: [   16.019050] forcedeth 0000:00:09.0: setting latency timer to 64
|Aug 31 10:10:42 melchior kernel: [   16.019129] forcedeth 0000:00:09.0: Invalid Mac address detected: ff:ff:ff:ff:ff:ff
|Aug 31 10:10:42 melchior kernel: [   16.019339] forcedeth 0000:00:09.0: Please complain to your hardware vendor. Switching to a random MAC.
|Aug 31 10:10:42 melchior kernel: [   21.399400] forcedeth 0000:00:09.0: open: Could not find a valid PHY.
|Aug 31 10:10:42 melchior kernel: [   21.399572] forcedeth 0000:00:09.0: PCI INT A disabled
|Aug 31 10:10:42 melchior kernel: [   21.399723] forcedeth: probe of 0000:00:09.0 failed with error -12

If I rmmod forcedeth before kexec, it loads fine later.
This is with MSI enabled:
|           CPU0       
|  0:         99   IO-APIC-edge      timer
|  1:          2   IO-APIC-edge      i8042
|  7:          1   IO-APIC-edge    
|  8:          1   IO-APIC-edge      rtc
|  9:          0   IO-APIC-fasteoi   acpi
| 12:          3   IO-APIC-edge      i8042
| 14:         53   IO-APIC-edge      pata_amd
| 15:          0   IO-APIC-edge      pata_amd
| 16:      76975   IO-APIC-fasteoi   ahci, radeon@pci:0000:02:00.0
| 18:          0   IO-APIC-fasteoi   EMU10K1
| 20:          6   IO-APIC-fasteoi   ehci_hcd:usb1
| 21:         54   IO-APIC-fasteoi   sata_nv
| 22:          0   IO-APIC-fasteoi   sata_nv
| 23:      11230   IO-APIC-fasteoi   sata_nv, ohci_hcd:usb2
|284:      81038   PCI-MSI-edge      eth1
|285:      74728   PCI-MSI-edge      eth0
|NMI:          0   Non-maskable interrupts
|LOC:      29209   Local timer interrupts
|TRM:          0   Thermal event interrupts
|THR:          0   Threshold APIC interrupts
|SPU:          0   Spurious interrupts
|ERR:          1

Maybe also calling nv_restore_phy() and/or pci_release_regions() in
the shutdown hook would help.

TODO:
Try with the patch, maybe try nv_restore_phy, test if WOL is
affected by the patch.

HTH,

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
