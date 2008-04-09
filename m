Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbYDIOba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbYDIOba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 10:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbYDIObU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 10:31:20 -0400
Received: from posthamster.phnxsoft.com ([195.227.45.4]:1191 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbYDIObS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 10:31:18 -0400
Message-ID: <47FCD2E1.20700@imap.cc>
Date: Wed, 09 Apr 2008 16:29:53 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: Re: 2.6.25-rc8-mm1: Intel SATA boot failure
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>	<47F56363.4090002@imap.cc> <20080403161733.c05dac53.akpm@linux-foundation.org>
In-Reply-To: <20080403161733.c05dac53.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD1F800192B0E8C522F36B91B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD1F800192B0E8C522F36B91B
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

This is taking longer than I hoped, so here's a little progress report.

On Thu, 3 Apr 2008 16:17:33 -0700, Andrew Morton wrote:
> On Fri, 04 Apr 2008 01:08:19 +0200
> Tilman Schmidt <tilman@imap.cc> wrote:
>=20
>> This fails to come up on my development machine, apparently because it=

>> has trouble accessing the SATA hard disks.
>> Hardware: Intel Pentium D940, Intel DQ965GF board, two SATA hard disks=
=2E
>> Some unusual things I noticed during the boot process:
>>=20
>> - a message "doing fast boot" that looked unfamiliar; unfortunately
>>   it scrolled off too quickly to note its context

That message doesn't make it into dmesg. It's apparently a Suse thing,
and perhaps normal, so let's ignore that for now.

>> - for each of the two SATA ports in use, a message
>>   "SATA port is slow to respond, please be patient"
>>   accompanied by about 10 secs wait

These messages seem to be a separate issue. I also get them with
a .config that otherwise brings up the system successfully. That
allowed me to capture a dmesg, so here are some possibly interesting
hunks of the diff between a mainline kernel and a working 2.6.25-rc8-mm1
one:

--- dmesg-2.6.25-rc8-git.nots-reordered 2008-04-09 15:29:52.000000000 +02=
00
+++ dmesg-2.6.25-rc8-mm1.nots   2008-04-09 00:48:42.000000000 +0200
@@ -1,4 +1,4 @@
- Linux version 2.6.25-rc8-testing-00210-g51ac03f (ts@xenon) (gcc version=
 4.2.1 (SUSE Linux)) #37 SMP PREEMPT Wed Apr 9 01:27:07 CEST 2008
+ Linux version 2.6.25-rc8-mm1-testing (ts@xenon) (gcc version 4.2.1 (SUS=
E Linux)) #6 SMP PREEMPT Wed Apr 9 00:24:23 CEST 2008
   BIOS-provided physical RAM map:
    BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
    BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)

[...]

@@ -244,12 +277,10 @@
   CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
   CPU1: Thermal monitoring enabled
   CPU1: Intel(R) Pentium(R) D CPU 3.20GHz stepping 04
- Total of 2 processors activated (12796.06 BogoMIPS).
+ Total of 2 processors activated (12796.87 BogoMIPS).
   ENABLING IO-APIC IRQs
   ..TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
- checking TSC synchronization [CPU#0 -> CPU#1]:
- Measured 560 cycles TSC warp between CPUs, turning off TSC clock.
- Marking TSC unstable due to: check_tsc_sync_source failed.
+ checking TSC synchronization [CPU#0 -> CPU#1]: passed.
   Brought up 2 CPUs
   CPU0 attaching sched-domain:
    domain 0: span 03

[Nice - at last a kernel that likes my TSC; not sure if it matters though=
=2E]

@@ -846,26 +880,36 @@
   PCI: Setting latency timer of device 0000:00:1f.2 to 64
   scsi0 : ahci
   PM: Adding info for No Bus:host0
+ PM: Adding info for No Bus:host0
   scsi1 : ahci
   PM: Adding info for No Bus:host1
+ PM: Adding info for No Bus:host1
   scsi2 : ahci
   PM: Adding info for No Bus:host2
+ PM: Adding info for No Bus:host2
   scsi3 : ahci
   PM: Adding info for No Bus:host3
+ PM: Adding info for No Bus:host3
   scsi4 : ahci
   PM: Adding info for No Bus:host4
+ PM: Adding info for No Bus:host4
   scsi5 : ahci
   PM: Adding info for No Bus:host5
+ PM: Adding info for No Bus:host5
   ata1: SATA max UDMA/133 abar m2048@0x92c25000 port 0x92c25100 irq 217
   ata2: SATA max UDMA/133 abar m2048@0x92c25000 port 0x92c25180 irq 217
   ata3: SATA max UDMA/133 abar m2048@0x92c25000 port 0x92c25200 irq 217
   ata4: SATA max UDMA/133 abar m2048@0x92c25000 port 0x92c25280 irq 217
   ata5: SATA max UDMA/133 abar m2048@0x92c25000 port 0x92c25300 irq 217
   ata6: SATA max UDMA/133 abar m2048@0x92c25000 port 0x92c25380 irq 217
+ ata1: port is slow to respond, please be patient (Status 0x80)
+ ata1: COMRESET failed (errno=3D-16)
   ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
   ata1.00: ATA-7: ST380811AS, 3.AAE, max UDMA/133
   ata1.00: 156301488 sectors, multi 0: LBA48 NCQ (depth 31/32)
   ata1.00: configured for UDMA/133
+ ata2: port is slow to respond, please be patient (Status 0x80)
+ ata2: COMRESET failed (errno=3D-16)
   ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
   ata2.00: ATA-7: ST380811AS, 3.AAE, max UDMA/133
   ata2.00: 156301488 sectors, multi 0: LBA48 NCQ (depth 31/32)
@@ -877,15 +921,22 @@
   PM: Adding info for No Bus:target0:0:0
   scsi 0:0:0:0: Direct-Access     ATA      ST380811AS       3.AA PQ: 0 A=
NSI: 5
   PM: Adding info for scsi:0:0:0:0
+ PM: Adding info for No Bus:0:0:0:0
+ PM: Adding info for No Bus:0:0:0:0
   PM: Adding info for No Bus:target1:0:0
   scsi 1:0:0:0: Direct-Access     ATA      ST380811AS       3.AA PQ: 0 A=
NSI: 5
   PM: Adding info for scsi:1:0:0:0
+ PM: Adding info for No Bus:1:0:0:0
+ PM: Adding info for No Bus:1:0:0:0
+ modprobe used greatest stack depth: 2200 bytes left
   ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 17
   PCI: Setting latency timer of device 0000:02:00.0 to 64
   scsi6 : pata_marvell
   PM: Adding info for No Bus:host6
+ PM: Adding info for No Bus:host6
   scsi7 : pata_marvell
   PM: Adding info for No Bus:host7
+ PM: Adding info for No Bus:host7
   ata7: PATA max UDMA/100 cmd 0x2018 ctl 0x2024 bmdma 0x2000 irq 17
   ata8: DUMMY
   BAR5:00:00 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00=
 0B:00 0C:01 0D:00 0E:00 0F:00

After that, it quickly diverges because of major differences in the
ordering of device startup. Already, to get the diffs above I had to
shift a few blocks of lines around.

>> Before I try booting that kernel again, any instructions on what to
>> watch out for? Is netconsole usable again?
>=20
> Yes, netconsole is usable again ;)

Good to know. I'm now looking in my netconsole setup for the reason
why I don't receive anything from it.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigD1F800192B0E8C522F36B91B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH/NLhQ3+did9BuFsRAhJ+AJ4i7pdl3Af65BpRsHrg3TUK6VgNfQCfdqsg
ZlG2GZAoN9Swmd1GMrhBdH0=
=ylOp
-----END PGP SIGNATURE-----

--------------enigD1F800192B0E8C522F36B91B--
