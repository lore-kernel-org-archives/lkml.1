Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbZBKWZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbZBKWZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbZBKWZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:25:37 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:11334 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbZBKWZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:25:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=BXHHJlux0f6rjfewebjw7EcC9WuxW52XL7h+foN6Kijt+zP1kxN3BI/G7TxPa4iloq
         fkalzMgoddXOZkaB+rhPYz2XGTh0OKSSrxB27iN1OLFvsau38eMblnIL3Z4LEtRCOYeI
         BdAqEClc7zRv7+KnoPsWByaRcQSpC6L4d1ge4=
MIME-Version: 1.0
Date: Wed, 11 Feb 2009 18:25:34 -0400
Message-ID: <e63fe7530902111425i68e8d139v8cc90289cd73331f@mail.gmail.com>
Subject: kernels 2.6.29.rc3 2.1 3.1 4.1 5.1 6.1 7.1 and rc4 8.1 Is ACPI broken 
	???????
From: rob koendering <susegebr@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all

the second posting went wrong due tot gmail problem (network)

this is /proc/interrupts

did the following run with full acpi

           CPU0       CPU1       CPU2       CPU3
  0:         97          0          0          0   IO-APIC-edge      timer
  1:       7310          0          0          0   IO-APIC-edge      i8042
  7:          1          0          0          0   IO-APIC-edge
  8:          1          0          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:        115      36083          0          0   IO-APIC-edge      i8042
 14:       8029          0          0          0   IO-APIC-edge      pata_amd
 15:          0          0          0          0   IO-APIC-edge      pata_amd
 16:      94270          0          0          0   IO-APIC-fasteoi
sym53c8xx, nvidia
 17:      13352          0          0          0   IO-APIC-fasteoi
0000:02:07.0
 19:          2          0          0          0   IO-APIC-fasteoi   ohci1394
 20:        108          0      15721          0   IO-APIC-fasteoi
ohci_hcd:usb1
 21:        190          0          0       4807   IO-APIC-fasteoi   sata_nv
 22:      76802          0          0          0   IO-APIC-fasteoi
sata_nv, HDA Intel
 23:        306       3394          0          0   IO-APIC-fasteoi
sata_nv, ehci_hcd:usb2
NMI:          0          0          0          0   Non-maskable interrupts
LOC:     386083     362373     201504     188108   Local timer interrupts
RES:       5424       3506       2743       2027   Rescheduling interrupts
CAL:       2916       3637       5086       5499   Function call interrupts
TLB:       1013       2101       1904       2128   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
SPU:          0          0          0          0   Spurious interrupts
ERR:          1
MIS:          0


then  run with no acpi


          CPU0       CPU1       CPU2       CPU3
  0:         88          0          0          0   IO-APIC-edge      timer
  1:         16          0          0          0   IO-APIC-edge      i8042
  2:          0          0          0          0    XT-PIC-XT        cascade
  5:      56805          0          0          0   IO-APIC-fasteoi
sata_nv, HDA Intel
  7:          3          0          0          0   IO-APIC-fasteoi
sata_nv, ohci1394
  8:          1          0          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-edge      acpi
 10:        299       5730          0          0   IO-APIC-fasteoi
sata_nv, ohci_hcd:usb1, nvidia
 11:        588          0          0       1174   IO-APIC-fasteoi
sym53c8xx, ehci_hcd:usb2, 0000:02:07.0
 12:        115          0       3843          0   IO-APIC-edge      i8042
 14:        684          0          0          0   IO-APIC-edge      pata_amd
 15:          0          0          0          0   IO-APIC-edge      pata_amd
NMI:          0          0          0          0   Non-maskable interrupts
LOC:      30438      23491      22784      25051   Local timer interrupts
RES:       1618        802        664        743   Rescheduling interrupts
CAL:       3828       1716       5318       5331   Function call interrupts
TLB:        598        737        659        927   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
SPU:          0          0          0          0   Spurious interrupts
ERR:          1
MIS:          0

in both cases irq-balancer is running

see the difference in  IO-APIC-edge      i8042


This is a raid 0 system
in the acpi run   irq 22 23 is the raid array

and in the no acpi  run  irq 5 7 is the raid array

all togethher  the no acpi run gives a more equal load on the 4 cpu's

as the acpi run gives 0 60 to 90 % load on cpu 0   the other cpu's not
more then 4 to 10 percent with intervals

hope this gives you more info in what i mean
2.6.27 kernels  acted more like the no acpi setting.
and no warning on the acpi tables in the bios


-- 
Robert Koendering
Willemstad
Curacao
