Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZKCTr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZKCTr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZKCTr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:47:59 -0500
Received: from smtp.roadtech.co.uk ([195.245.100.152]:45964 "EHLO
	viruswall-1.road-runner.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754725AbZKCTr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:47:58 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Nov 2009 14:47:57 EST
From: "J. David Rye of Roadtech" <d.rye@roadtech.co.uk>
Organization: Roadtech
To: linux-kernel@vger.kernel.org
Subject: Serial interfaces and the Multiple device RAID driver
Date: Tue, 3 Nov 2009 19:42:51 +0000
User-Agent: KMail/1.9.4
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911031942.52018.d.rye@roadtech.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This is a bit of a potshot, but I am hoping someone is going to be able to 
point me in an appropriate direction. I am having problems with serial 
heartbeats, and multi disk RAID1 arrays.

The issue shows up as corrupt messages on the serial heartbeats, and overrun 
messages in /var/log/messages

kernel: ttyS0: 2 input overrun(s)

I have 4 P4 computers that are very similar based around Supermicro P4SCT+  
motherboards with 3.2GHz P4 processors. The machines have two SATA 
controllers there are 2 ports on the Intel 6300ESB controller and 4 on a 
Marvel MV88SX5041 

The machines are arranged as two High Availability pairs.
The machines are currently running Fedora10 kernel 
2.6.27.37-170.2.104.fc10.i686

If I run the serial link in to a low spec 1GHz VIA box, with a single disk 
messages can be logged without any errors so it is not the serial cables or 
base band modems.

I have tried dropping the baud rate on machines 3 and 4 to 9600 rather than 
19200 this does not seam to make any difference.

Corruption shows up as both missing and corrupt characters.
slow response to serial port tinterupts will result in missing characters, 
though I have not in the past noted corrupt characters as a result.

Dropping the baud rate does not appear to make a difference.

Any helpfull suggestions would be appreciated.


Machine 1: only 3 or 4 overruns logged per day.

	sda Marvel controller single disk
	sdb Intel controller MD RAID
	sdc Intel controller MD RAID.

	md0=sdb1, sdc1
	md1=sdb2, sdc2
	md2=sdb3, sdc3

cat /proc/interrupts
           CPU0       CPU1
  0:        191          0   IO-APIC-edge      timer
  1:       6929          0   IO-APIC-edge      i8042
  3:          2          0   IO-APIC-edge
  4:          2          0   IO-APIC-edge
  6:          2          0   IO-APIC-edge      floppy
  7:          0          0   IO-APIC-edge      parport0
  8:          1          0   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 12:        678          0   IO-APIC-edge      i8042
 14:        585          0   IO-APIC-edge      ata_piix
 15:   15827158          0   IO-APIC-edge      ata_piix
 16:          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
 18:  342936579          0   IO-APIC-fasteoi   eth0
 19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 21: 2206183303          0   IO-APIC-fasteoi   serial
 23:          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
 24:   33838328          0   IO-APIC-fasteoi   eth4
 25: 1716154148          0   IO-APIC-fasteoi   eth1
 26: 2260299116          0   IO-APIC-fasteoi   eth2
 27:   25961661          0   IO-APIC-fasteoi   sata_mv, eth3
NMI:          0          0   Non-maskable interrupts
LOC:  345515518 1254623910   Local timer interrupts
RES:    1707850    4921652   Rescheduling interrupts
CAL:      80841      43449   function call interrupts
TLB:     306776     264832   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0
 

Machine 2: no overruns logged in last week.

	sda Intel controller MD RAID
	sdb Intel controller MD RAID.

	md0=sda1, sdb1
	md1=sda2, sdb2
	md2=sda3, sdb3


cat /proc/interrupts
           CPU0       CPU1
  0:        132          0   IO-APIC-edge      timer
  1:        132          0   IO-APIC-edge      i8042
  3:          2          0   IO-APIC-edge
  4:          2          0   IO-APIC-edge
  6:          2          0   IO-APIC-edge      floppy
  7:          0          0   IO-APIC-edge      parport0
  8:          1          0   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 12:        138          0   IO-APIC-edge      i8042
 14:    6680353          0   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
 18:    7901522          0   IO-APIC-fasteoi   eth0
 19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 21: 1597304083          0   IO-APIC-fasteoi   serial
 23:        367          0   IO-APIC-fasteoi   ehci_hcd:usb1
 25:  496342556          0   IO-APIC-fasteoi   eth1
 26:  493466471          0   IO-APIC-fasteoi   eth2
 27:    2456396          0   IO-APIC-fasteoi   sata_mv, eth3
NMI:          0          0   Non-maskable interrupts
LOC:  241045995   58231750   Local timer interrupts
RES:      89012     134076   Rescheduling interrupts
CAL:       4404       5700   function call interrupts
TLB:      11725      15424   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0


Machine 3: This is the most interesting, with drive C as part of the RAID 
array lots of errors with the array degraded just 1 or 2 per day like machine 
1

	sda Intel controller MD RAID
	sdb Intel controller MD RAID
	sdc Marvel controller MD RAID

	md0=sda1, sdb1, sdc1
	md1=sda2, sdb2, sdb1
	md2=sda3, sdb3, sdc1

cat /proc/interrupts
           CPU0
  0:        138   IO-APIC-edge      timer
  1:        281   IO-APIC-edge      i8042
  6:          2   IO-APIC-edge      floppy
  8:          1   IO-APIC-edge      rtc0
  9:          0   IO-APIC-fasteoi   acpi
 12:        121   IO-APIC-edge      i8042
 14:          0   IO-APIC-edge      ata_piix
 15:          0   IO-APIC-edge      ata_piix
 18:   51082134   IO-APIC-fasteoi   ata_piix, eth0
 21:   38470807   IO-APIC-fasteoi   serial
 25:   50309334   IO-APIC-fasteoi   eth1
 27:     127456   IO-APIC-fasteoi   sata_mv
NMI:          0   Non-maskable interrupts
LOC:   13833559   Local timer interrupts
RES:          0   Rescheduling interrupts
CAL:          0   function call interrupts
TLB:          0   TLB shootdowns
TRM:          0   Thermal event interrupts
SPU:          0   Spurious interrupts
ERR:          0
MIS:          0

Machine 4 In normal use only 3 or 4 overruns logged per day. However if 
workload transferred from Machine 3 this rises to lots.


	sda Marvel controller MD RAID
	sdb Marvel controller MD RAID
	sdc Marvel controller MD RAID

	md0=sda1, sdb1, sdc1
	md1=sda2, sdb2, sdb1
	md2=sda3, sdb3, sdc1

cat /proc/interrupts
           CPU0       CPU1
  0:        130          0   IO-APIC-edge      timer
  1:          9       8528   IO-APIC-edge      i8042
  3:          2          0   IO-APIC-edge
  4:          2          0   IO-APIC-edge
  6:          2          0   IO-APIC-edge      floppy
  7:          0          0   IO-APIC-edge      parport0
  8:          1          0   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 12:        142       3254   IO-APIC-edge      i8042
 14:          0          0   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
 18:        348  285725468   IO-APIC-fasteoi   ata_piix, eth0
 19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 21:  114647339      45683   IO-APIC-fasteoi   serial
 23:    1591213          0   IO-APIC-fasteoi   ehci_hcd:usb1
 25:  281669867          0   IO-APIC-fasteoi   eth1
 27:    5954853          0   IO-APIC-fasteoi   sata_mv
NMI:          0          0   Non-maskable interrupts
LOC:   84506497   72450763   Local timer interrupts
RES:     247607     206442   Rescheduling interrupts
CAL:       4544       2991   function call interrupts
TLB:       7501      26683   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0



