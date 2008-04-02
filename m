Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbYDBD57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbYDBD57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 23:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbYDBD5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 23:57:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:2286 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbYDBD5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 23:57:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=N2gbPeP43NJ96lDK/BOGzYSJb0+1+RPmfLh55zsMmpTic3uJ0bhY3+1vgfBShsY0NDQNLCCMAZP5iV/TDFKRWjDhbEjaQ+UocJ+/UthNmAhOPc0OhpAersUXFwZnU2OQ7b15WJBb1bmZ7Lv+6kXsage6QYEPrGLeXmhDQfYX28E=
Message-ID: <47F30438.40506@gmail.com>
Date: Wed, 02 Apr 2008 12:57:44 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200803191108.18577.volker.armin.hemmann@tu-clausthal.de> <47E0FC47.8040902@gmail.com> <200803191455.14380.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200803191455.14380.volker.armin.hemmann@tu-clausthal.de>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------080301080803060304050302"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080301080803060304050302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Volker Armin Hemmann wrote:
>On Mittwoch, 19. März 2008, Tejun Heo wrote:
>> Volker Armin Hemmann wrote:
>>> On Mittwoch, 19. März 2008, Tejun Heo wrote:
>>>> x UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200
>>>>
>>>>> irq 315
>>>>> [   38.125479] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port
>>>>> 0xf9dfc280 irq 315
>>>>> [   38.597035] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>>>> [   38.597732] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max
>>>>> UDMA/133 [   38.597775] ata1.00: 312581808 sectors, multi 16: LBA48
>>>>> [   38.598405] ata1.00: configured for UDMA/133
>>>>> [   39.069342] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>>>> [   39.084225] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
>>>>> [   39.084264] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth
>>>>> 0/32) [   39.086268] ata2.00: configured for UDMA/133
>>>> So, just to confirm.  With the updated patch, you don't see any problem,
>>>> right?
>>> Correct. With the updated patch I don't see problems in 'non-raid' mode.
>>> AHCI mode still has problems without nosmi. But that is an entirely
>>> different problem, right?
>> Yeap, can you please post the result of "lspci -nn"?
> 
> with AHCI+nosmi, 2.6.24.3:
> 00:0a.0 SATA controller [0106]: nVidia Corporation MCP65 AHCI Controller 
> [10de:044d] (rev a1)

Sorry about the long delay.  Can you please test the attached patch in 
both ahci and non-ahci modes w/o pci=nomsi and post resulting boot logs?

> I booted into systemrescuecd (which is the easiest way to get the error and be 
> able to safe the stuff) - lspci is of course identical, but /proc/interrupts 
> is not.
> 
> 2.6.24.3:
> cat /proc/interrupts
>            CPU0       CPU1
>   0:         57          1   IO-APIC-edge      timer
>   1:          1        544   IO-APIC-edge      i8042
>   8:          0          1   IO-APIC-edge      rtc
>   9:          0          1   IO-APIC-fasteoi   acpi
>  12:          0          3   IO-APIC-edge      i8042
>  17:         22      21598   IO-APIC-fasteoi   nvidia
>  18:          0          0   IO-APIC-fasteoi   EMU10K1
>  19:          5       1132   IO-APIC-fasteoi   eth0
>  22:         30      21627   IO-APIC-fasteoi   ehci_hcd:usb1
>  23:         29      23078   IO-APIC-fasteoi   ahci
> NMI:          0          0   Non-maskable interrupts
> LOC:      41299      60204   Local timer interrupts
> RES:      14872      22506   Rescheduling interrupts
> CAL:       1783        173   function call interrupts
> TLB:       2668       2406   TLB shootdowns
> TRM:          0          0   Thermal event interrupts
> THR:          0          0   Threshold APIC interrupts
> SPU:          0          0   Spurious interrupts
> ERR:          0

Does the 2.6.24.3 kernel have MSI turned on?

Thanks.

-- 
tejun

--------------080301080803060304050302
Content-Type: text/x-patch;
 name="mcp65-ahci-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mcp65-ahci-debug.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4851988..930fe22 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -7134,7 +7134,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 			ehi->probe_mask =
 				(1 << ata_link_max_devices(&ap->link)) - 1;
 			ehi->action |= ATA_EH_SOFTRESET;
-			ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
+			ehi->flags |= ATA_EHI_NO_AUTOPSY/* | ATA_EHI_QUIET*/;
 
 			ap->pflags &= ~ATA_PFLAG_INITIALIZING;
 			ap->pflags |= ATA_PFLAG_LOADING;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index a583032..bbf9273 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2190,6 +2190,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		}
 	}
 
+	ehc->i.action |= ATA_EH_HARDRESET;
+
 	/* prereset() might have modified ehc->i.action */
 	if (ehc->i.action & ATA_EH_HARDRESET)
 		reset = hardreset;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e887aa4..a43be09 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1855,6 +1855,8 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
 			PCI_DEVICE_ID_TIGON3_5715S,
 			quirk_msi_intx_disable_bug);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x044d,
+			quirk_msi_intx_disable_bug);
 
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4390,
 			quirk_msi_intx_disable_ati_bug);

--------------080301080803060304050302--
