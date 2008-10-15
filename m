Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbYJOOsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbYJOOsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbYJOOsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:48:00 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44867 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbYJOOrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:47:55 -0400
From: Peter Alfredsen <loki_val@gentoo.org>
To: Tejun Heo <tj@kernel.org>
Subject: Re: SATA Burner Pioneer DVR-216-DBK won't burn
Date: Wed, 15 Oct 2008 16:47:01 +0200
User-Agent: KMail/1.9.10
References: <200810052005.04920.loki_val@gentoo.org> <48F44706.7060701@kernel.org>
In-Reply-To: <48F44706.7060701@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2085285.TyOOzOxHvc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810151647.04059.loki_val@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2085285.TyOOzOxHvc
Content-Type: multipart/mixed;
  boundary="Boundary-01=_mJg9IkHDwO30YhV"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_mJg9IkHDwO30YhV
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I've tried to burn other things in the meantime. Some things, I'm
actually able to burn. But when I can't burn something, I have so far
been able to reproduce the failure. Very strange.

On Tuesday 14 October 2008, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> Peter Alfredsen wrote:
> > [please CC me on replies]
> > Linux loki 2.6.27-rc8 #5 SMP PREEMPT Sun Oct 5 17:56:00 CEST 2008
> > x86_64 Intel(R) Core(TM)2 Quad CPU Q9550 @ 2.83GHz GenuineIntel
> > GNU/Linux
> >
> > I recently acquired a DVR-216-DBK Pioneer SATA burner. With my old
> > burner, a DVR-110D,  I am able to burn a DVD. With the DVR-216DBK,
> > I'm not, it stops always at 98%, no matter which speed I burn at.
>
> Can you please attach kernel boot log?  And does the kernel whine
> about anything after the failure?

No, but when my harddrives have a lot of IO, sometimes the DVD drive
will reset itself. It's hard to duplicate and happens only when the
moon is right, but has never happened while the drive was actually in use:
Oct  5 23:45:50 loki kernel: [18287.041021] ata5.00: exception Emask 0x0 SA=
ct 0x0 SErr 0x0 action 0x6 frozen
Oct  5 23:45:50 loki kernel: [18287.041029] ata5.00: cmd a0/00:00:00:00:00/=
00:00:00:00:00/a0 tag 0
Oct  5 23:45:50 loki kernel: [18287.041030]          cdb 35 02 00 00 00 00 =
00 00  00 00 00 00 00 00 00 00
Oct  5 23:45:50 loki kernel: [18287.041031]          res 40/00:03:00:00:00/=
00:00:00:00:00/a0 Emask 0x4 (timeout)
Oct  5 23:45:50 loki kernel: [18287.041034] ata5.00: status: { DRDY }
Oct  5 23:45:50 loki kernel: [18287.041039] ata5: hard resetting link
Oct  5 23:45:50 loki kernel: [18287.499015] ata5: SATA link up 1.5 Gbps (SS=
tatus 113 SControl 300)
Oct  5 23:45:50 loki kernel: [18287.503347] ata5.00: configured for UDMA/66
Oct  5 23:45:50 loki kernel: [18287.503357] ata5: EH complete

> > My motherboard is a ASUS P5Q-EM, I have 8GB of ram and am running
> > Gentoo Linux. I've tried both cdrkit and cdrtools.
> > DVR-216-DBK Fails, connected to ICH10R AHCI SATA controller
> > DVR-110D Succeeds, connected to Marvell 6101 PATA_MARVELL
> > controller
>
> What if you swap the two?  Or is one SATA and the other PATA?

Yes.

> In=20
> that case, can you get a chip sil3152 controller (probably ~10USD)
> and see whether it works any better?

Sorry.

> > This seems to me to point to a problem with the AHCI driver's
> > interaction with the drive.
> >
> > Attached is lspci -k and debug output from K3B:
> >
> > 00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family)
> > SATA AHCI Controller
> >         Kernel driver in use: ahci
>
> I suppose the drive is hanging off this one, right?

Yes.

> >  3942252544/4008087552 (98.4%) @16.8x, remaining 0:03 RBU 100.0%
> > UBU 100.0%
> >
> > :-[ WRITE@LBA=3D1ddcd0h failed with SK=3D5h/ASC=3DA8h/ACQ=3D04h]:
> > : Input/output
> >
> > error
> >
> > :-( write failed: Input/output error
> >
> > /dev/sr0: flushing cache
>
> k3b doesn't really show which command failed.  I suppose it's
> WRITE(10).  The failure code is ILLEGAL REQUEST and the ASC/ASCQ are
> vendor specific and don't really tell us much detail about the
> failure.  :-(
>
> Can you please try wodim with "-pad -v -V" options?  It will generate
> a lot of output.  You'll probably want to redirect the output to a
> file and watch it using tail or less.

When I get around to finding something to burn that fails again, I will
take a look at this and see if I can get more detailed logs.

=2D-=20
/PA

--Boundary-01=_mJg9IkHDwO30YhV
Content-Type: text/plain;
  name="dmesg"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 2.6.27-rc8 (root@loki) (gcc version 4.3.2 (Gen=
too 4.3.2 p1.0) ) #5 SMP PREEMPT Sun Oct 5 17:56:00 CEST 2008
[    0.000000] Command line: clocksource=3Dhpet root=3D/dev/md3 md=3D1,/dev=
/sda1,/dev/sdb1 md=3D2,/dev/sda2,/dev/sdb2 md=3D3,/dev/sda3,/dev/sdb3 md=3D=
4,/dev/sda4,/dev/sdb4
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
[    0.000000]  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7d80000 (usable)
[    0.000000]  BIOS-e820: 00000000c7d80000 - 00000000c7d8e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000c7d8e000 - 00000000c7dd0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c7dd0000 - 00000000c7e00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
[    0.000000] last_pfn =3D 0x230000 max_arch_pfn =3D 0x3ffffffff
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] total RAM coverred: 8062M
[    0.000000]  gran_size: 1M   chunk_size: 1M  num_reg: 8      lose RAM: 4=
864M
[    0.000000]  gran_size: 1M   chunk_size: 2M  num_reg: 8      lose RAM: 4=
864M
[    0.000000]  gran_size: 1M   chunk_size: 4M  num_reg: 8      lose RAM: 4=
864M
[    0.000000]  gran_size: 1M   chunk_size: 8M  num_reg: 8      lose RAM: 4=
864M
[    0.000000]  gran_size: 1M   chunk_size: 16M         num_reg: 8      los=
e RAM: 4864M
[    0.000000]  gran_size: 1M   chunk_size: 32M         num_reg: 8      los=
e RAM: 4864M
[    0.000000]  gran_size: 1M   chunk_size: 64M         num_reg: 8      los=
e RAM: 4864M
[    0.000000]  gran_size: 1M   chunk_size: 128M        num_reg: 8      los=
e RAM: 4864M
[    0.000000]  gran_size: 1M   chunk_size: 256M        num_reg: 8      los=
e RAM: 4864M
[    0.000000]  gran_size: 1M   chunk_size: 512M        num_reg: 8      los=
e RAM: 4864M
[    0.000000]  gran_size: 1M   chunk_size: 1024M       num_reg: 8      los=
e RAM: 4864M
[    0.000000]  gran_size: 1M   chunk_size: 2048M       num_reg: 8      los=
e RAM: 4864M
[    0.000000]  gran_size: 1M   chunk_size: 4096M       num_reg: 8      los=
e RAM: 4864M
[    0.000000]  gran_size: 2M   chunk_size: 2M  num_reg: 8      lose RAM: 4=
864M
[    0.000000]  gran_size: 2M   chunk_size: 4M  num_reg: 8      lose RAM: 4=
864M
[    0.000000]  gran_size: 2M   chunk_size: 8M  num_reg: 8      lose RAM: 4=
864M
[    0.000000]  gran_size: 2M   chunk_size: 16M         num_reg: 8      los=
e RAM: 4864M
[    0.000000]  gran_size: 2M   chunk_size: 32M         num_reg: 8      los=
e RAM: 4864M
[    0.000000]  gran_size: 2M   chunk_size: 64M         num_reg: 8      los=
e RAM: 4864M
[    0.000000]  gran_size: 2M   chunk_size: 128M        num_reg: 8      los=
e RAM: 4864M
[    0.000000]  gran_size: 2M   chunk_size: 256M        num_reg: 8      los=
e RAM: 4864M
[    0.000000]  gran_size: 2M   chunk_size: 512M        num_reg: 8      los=
e RAM: 4864M
[    0.000000]  gran_size: 2M   chunk_size: 1024M       num_reg: 8      los=
e RAM: 4864M
[    0.000000]  gran_size: 2M   chunk_size: 2048M       num_reg: 8      los=
e RAM: 4864M
[    0.000000]  gran_size: 2M   chunk_size: 4096M       num_reg: 8      los=
e RAM: 4864M
[    0.000000]  gran_size: 4M   chunk_size: 4M  num_reg: 8      lose RAM: 7=
70M
[    0.000000]  gran_size: 4M   chunk_size: 8M  num_reg: 8      lose RAM: 7=
70M
[    0.000000]  gran_size: 4M   chunk_size: 16M         num_reg: 8      los=
e RAM: 770M
[    0.000000]  gran_size: 4M   chunk_size: 32M         num_reg: 8      los=
e RAM: 770M
[    0.000000]  gran_size: 4M   chunk_size: 64M         num_reg: 8      los=
e RAM: 770M
[    0.000000]  gran_size: 4M   chunk_size: 128M        num_reg: 8      los=
e RAM: 770M
[    0.000000]  gran_size: 4M   chunk_size: 256M        num_reg: 8      los=
e RAM: 770M
[    0.000000]  gran_size: 4M   chunk_size: 512M        num_reg: 8      los=
e RAM: 770M
[    0.000000]  gran_size: 4M   chunk_size: 1024M       num_reg: 8      los=
e RAM: 770M
[    0.000000]  gran_size: 4M   chunk_size: 2048M       num_reg: 8      los=
e RAM: 770M
[    0.000000]  gran_size: 4M   chunk_size: 4096M       num_reg: 8      los=
e RAM: 770M
[    0.000000]  gran_size: 8M   chunk_size: 8M  num_reg: 8      lose RAM: 2=
62M
[    0.000000]  gran_size: 8M   chunk_size: 16M         num_reg: 8      los=
e RAM: 262M
[    0.000000]  gran_size: 8M   chunk_size: 32M         num_reg: 8      los=
e RAM: 262M
[    0.000000]  gran_size: 8M   chunk_size: 64M         num_reg: 8      los=
e RAM: 262M
[    0.000000]  gran_size: 8M   chunk_size: 128M        num_reg: 8      los=
e RAM: 262M
[    0.000000]  gran_size: 8M   chunk_size: 256M        num_reg: 8      los=
e RAM: 262M
[    0.000000]  gran_size: 8M   chunk_size: 512M        num_reg: 8      los=
e RAM: 262M
[    0.000000] *BAD* gran_size: 8M      chunk_size: 1024M       num_reg: 8 =
     lose RAM: -250M
[    0.000000]  gran_size: 8M   chunk_size: 2048M       num_reg: 8      los=
e RAM: 262M
[    0.000000]  gran_size: 8M   chunk_size: 4096M       num_reg: 8      los=
e RAM: 262M
[    0.000000]  gran_size: 16M  chunk_size: 16M         num_reg: 8      los=
e RAM: 14M
[    0.000000]  gran_size: 16M  chunk_size: 32M         num_reg: 8      los=
e RAM: 14M
[    0.000000]  gran_size: 16M  chunk_size: 64M         num_reg: 8      los=
e RAM: 14M
[    0.000000]  gran_size: 16M  chunk_size: 128M        num_reg: 8      los=
e RAM: 14M
[    0.000000]  gran_size: 16M  chunk_size: 256M        num_reg: 8      los=
e RAM: 14M
[    0.000000]  gran_size: 16M  chunk_size: 512M        num_reg: 8      los=
e RAM: 14M
[    0.000000]  gran_size: 16M  chunk_size: 1024M       num_reg: 8      los=
e RAM: 14M
[    0.000000]  gran_size: 16M  chunk_size: 2048M       num_reg: 8      los=
e RAM: 14M
[    0.000000]  gran_size: 16M  chunk_size: 4096M       num_reg: 8      los=
e RAM: 14M
[    0.000000]  gran_size: 32M  chunk_size: 32M         num_reg: 7      los=
e RAM: 30M
[    0.000000]  gran_size: 32M  chunk_size: 64M         num_reg: 7      los=
e RAM: 30M
[    0.000000]  gran_size: 32M  chunk_size: 128M        num_reg: 7      los=
e RAM: 30M
[    0.000000]  gran_size: 32M  chunk_size: 256M        num_reg: 7      los=
e RAM: 30M
[    0.000000]  gran_size: 32M  chunk_size: 512M        num_reg: 7      los=
e RAM: 30M
[    0.000000]  gran_size: 32M  chunk_size: 1024M       num_reg: 7      los=
e RAM: 30M
[    0.000000]  gran_size: 32M  chunk_size: 2048M       num_reg: 7      los=
e RAM: 30M
[    0.000000]  gran_size: 32M  chunk_size: 4096M       num_reg: 7      los=
e RAM: 30M
[    0.000000]  gran_size: 64M  chunk_size: 64M         num_reg: 6      los=
e RAM: 62M
[    0.000000]  gran_size: 64M  chunk_size: 128M        num_reg: 6      los=
e RAM: 62M
[    0.000000]  gran_size: 64M  chunk_size: 256M        num_reg: 6      los=
e RAM: 62M
[    0.000000]  gran_size: 64M  chunk_size: 512M        num_reg: 6      los=
e RAM: 62M
[    0.000000]  gran_size: 64M  chunk_size: 1024M       num_reg: 6      los=
e RAM: 62M
[    0.000000]  gran_size: 64M  chunk_size: 2048M       num_reg: 6      los=
e RAM: 62M
[    0.000000]  gran_size: 64M  chunk_size: 4096M       num_reg: 6      los=
e RAM: 62M
[    0.000000]  gran_size: 128M         chunk_size: 128M        num_reg: 5 =
     lose RAM: 126M
[    0.000000]  gran_size: 128M         chunk_size: 256M        num_reg: 5 =
     lose RAM: 126M
[    0.000000]  gran_size: 128M         chunk_size: 512M        num_reg: 5 =
     lose RAM: 126M
[    0.000000]  gran_size: 128M         chunk_size: 1024M       num_reg: 5 =
     lose RAM: 126M
[    0.000000]  gran_size: 128M         chunk_size: 2048M       num_reg: 5 =
     lose RAM: 126M
[    0.000000]  gran_size: 128M         chunk_size: 4096M       num_reg: 5 =
     lose RAM: 126M
[    0.000000]  gran_size: 256M         chunk_size: 256M        num_reg: 5 =
     lose RAM: 126M
[    0.000000]  gran_size: 256M         chunk_size: 512M        num_reg: 5 =
     lose RAM: 126M
[    0.000000]  gran_size: 256M         chunk_size: 1024M       num_reg: 5 =
     lose RAM: 126M
[    0.000000]  gran_size: 256M         chunk_size: 2048M       num_reg: 5 =
     lose RAM: 126M
[    0.000000]  gran_size: 256M         chunk_size: 4096M       num_reg: 5 =
     lose RAM: 126M
[    0.000000]  gran_size: 512M         chunk_size: 512M        num_reg: 4 =
     lose RAM: 382M
[    0.000000]  gran_size: 512M         chunk_size: 1024M       num_reg: 4 =
     lose RAM: 382M
[    0.000000]  gran_size: 512M         chunk_size: 2048M       num_reg: 4 =
     lose RAM: 382M
[    0.000000]  gran_size: 512M         chunk_size: 4096M       num_reg: 4 =
     lose RAM: 382M
[    0.000000]  gran_size: 1024M        chunk_size: 1024M       num_reg: 3 =
     lose RAM: 894M
[    0.000000]  gran_size: 1024M        chunk_size: 2048M       num_reg: 3 =
     lose RAM: 894M
[    0.000000]  gran_size: 1024M        chunk_size: 4096M       num_reg: 3 =
     lose RAM: 894M
[    0.000000]  gran_size: 2048M        chunk_size: 2048M       num_reg: 2 =
     lose RAM: 1918M
[    0.000000]  gran_size: 2048M        chunk_size: 4096M       num_reg: 2 =
     lose RAM: 1918M
[    0.000000] mtrr_cleanup: can not find optimal value
[    0.000000] please specify mtrr_gran_size/mtrr_chunk_size
[    0.000000] last_pfn =3D 0xc7d80 max_arch_pfn =3D 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000]  0000000000 - 00c7c00000 page 2M
[    0.000000]  00c7c00000 - 00c7d80000 page 4k
[    0.000000] kernel direct mapping tables up to c7d80000 @ 8000-e000
[    0.000000] last_map_addr: c7d80000 end: c7d80000
[    0.000000] init_memory_mapping
[    0.000000]  0100000000 - 0230000000 page 2M
[    0.000000] kernel direct mapping tables up to 230000000 @ c000-16000
[    0.000000] last_map_addr: 230000000 end: 230000000
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000FBA20, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT C7D80100, 0064 (r1 A_M_I_ OEMXSDT   7000825 MSFT =
      97)
[    0.000000] ACPI: FACP C7D80290, 00F4 (r3 A_M_I_ OEMFACP   7000825 MSFT =
      97)
[    0.000000] ACPI: DSDT C7D80440, 90CE (r1  A0982 A0982043       43 INTL =
20060113)
[    0.000000] ACPI: FACS C7D8E000, 0040
[    0.000000] ACPI: APIC C7D80390, 006C (r1 A_M_I_ OEMAPIC   7000825 MSFT =
      97)
[    0.000000] ACPI: MCFG C7D80400, 003C (r1 A_M_I_ OEMMCFG   7000825 MSFT =
      97)
[    0.000000] ACPI: OEMB C7D8E040, 0089 (r1 A_M_I_ AMI_OEM   7000825 MSFT =
      97)
[    0.000000] ACPI: HPET C7D89510, 0038 (r1 A_M_I_ OEMHPET   7000825 MSFT =
      97)
[    0.000000] ACPI: GSCI C7D8E0D0, 2024 (r1 A_M_I_ GMCHSCI   7000825 MSFT =
      97)
[    0.000000] ACPI: OSFR C7D89550, 00B0 (r1 A_M_I_ OEMOSFR   7000825 MSFT =
      97)
[    0.000000] ACPI: SSDT C7D90A00, 0A7C (r1 DpgPmm    CpuPm       12 INTL =
20060113)
[    0.000000] (6 early reservations) =3D=3D> bootmem [0000000000 - 0230000=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00008acc34]    TEXT DATA BSS =3D=3D> [000=
0200000 - 00008acc34]
[    0.000000]   #3 [000009cc00 - 0000100000]    BIOS reserved =3D=3D> [000=
009cc00 - 0000100000]
[    0.000000]   #4 [0000008000 - 000000c000]          PGTABLE =3D=3D> [000=
0008000 - 000000c000]
[    0.000000]   #5 [000000c000 - 0000011000]          PGTABLE =3D=3D> [000=
000c000 - 0000011000]
[    0.000000] found SMP MP-table at [ffff8800000ff780] 000ff780
[    0.000000]  [ffffe20000000000-ffffe20007bfffff] PMD -> [ffff88002820000=
0-ffff88002fdfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00230000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009c
[    0.000000]     0: 0x00000100 -> 0x000c7d80
[    0.000000]     0: 0x00100000 -> 0x00230000
[    0.000000] On node 0 totalpages: 2063644
[    0.000000]   DMA zone: 2119 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 800184 pages, LIFO batch:31
[    0.000000]   Normal zone: 1228160 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at c8000000 (gap: c7e00000=
:37000000)
[    0.000000] PERCPU: Allocating 45792 bytes of per cpu data
[    0.000000] NR_CPUS: 4, nr_cpu_ids: 4, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 2030463
[    0.000000] Kernel command line: clocksource=3Dhpet root=3D/dev/md3 md=
=3D1,/dev/sda1,/dev/sdb1 md=3D2,/dev/sda2,/dev/sdb2 md=3D3,/dev/sda3,/dev/s=
db3 md=3D4,/dev/sda4,/dev/sdb4
[    0.000000] md: Will configure md1 (super-block) from /dev/sda1,/dev/sdb=
1, below.
[    0.000000] md: Will configure md2 (super-block) from /dev/sda2,/dev/sdb=
2, below.
[    0.000000] md: Will configure md3 (super-block) from /dev/sda3,/dev/sdb=
3, below.
[    0.000000] md: Will configure md4 (super-block) from /dev/sda4,/dev/sdb=
4, below.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC: PIT calibration confirmed by PMTIMER.
[    0.000000] TSC: using PMTIMER calibration value
[    0.000000] Detected 2832.996 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 1048576 (order: 11, 8388608=
 bytes)
[    0.000999] Inode-cache hash table entries: 524288 (order: 10, 4194304 b=
ytes)
[    0.000999] Checking aperture...
[    0.000999] No AGP bridge found
[    0.000999] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000999] Placing software IO TLB between 0x20000000 - 0x24000000
[    0.000999] Memory: 8040840k/9175040k available (3842k kernel code, 2130=
68k reserved, 1892k data, 348k init)
[    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
[    0.000999] SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D4, Nodes=3D1
[    0.000999] hpet clockevent registered
[    0.000999] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 5665.99 BogoMIPS (lpj=3D2832996)
[    0.000999] Mount-cache hash table entries: 256
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 6144K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 0
[    0.000999] CPU0: Thermal monitoring enabled (TM2)
[    0.000999] using mwait in idle threads.
[    0.000999] ACPI: Core revision 20080609
[    0.011340] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
=2D1
[    0.021866] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q9550  @ 2.83GHz steppi=
ng 07
[    0.021956] Using local APIC timer interrupts.
[    0.022997] APIC timer calibration result 20830842
[    0.022998] Detected 20.830 MHz APIC timer.
[    0.023112] Booting processor 1/1 ip 6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 7932.09 Bog=
oMIPS (lpj=3D3966049)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 6144K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] CPU1: Thermal monitoring enabled (TM2)
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060007=
0106
[    0.095442] CPU1: Intel(R) Core(TM)2 Quad  CPU   Q9550  @ 2.83GHz steppi=
ng 07
[    0.095982] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.096041] Booting processor 2/2 ip 6000
[    0.000999] Initializing CPU#2
[    0.000999] Calibrating delay using timer specific routine.. 5665.83 Bog=
oMIPS (lpj=3D2832916)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 6144K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 2
[    0.000999] CPU2: Thermal monitoring enabled (TM2)
[    0.000999] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x701060007=
0106
[    0.168697] CPU2: Intel(R) Core(TM)2 Quad  CPU   Q9550  @ 2.83GHz steppi=
ng 07
[    0.169056] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.170011] Booting processor 3/3 ip 6000
[    0.000999] Initializing CPU#3
[    0.000999] Calibrating delay using timer specific routine.. 5665.83 Bog=
oMIPS (lpj=3D2832916)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 6144K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 3
[    0.000999] CPU3: Thermal monitoring enabled (TM2)
[    0.000999] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x701060007=
0106
[    0.242728] CPU3: Intel(R) Core(TM)2 Quad  CPU   Q9550  @ 2.83GHz steppi=
ng 07
[    0.243045] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.243970] Brought up 4 CPUs
[    0.244023] Total of 4 processors activated (24929.75 BogoMIPS).
[    0.244126] net_namespace: 584 bytes
[    0.244126] NET: Registered protocol family 16
[    0.245034] No dock devices found.
[    0.245097] ACPI: bus type pci registered
[    0.245097] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.245097] PCI: Not using MMCONFIG.
[    0.245097] PCI: Using configuration type 1 for base access
[    0.247493] ACPI: EC: Look up EC in DSDT
[    0.258828] ACPI: Interpreter enabled
[    0.258879] ACPI: (supports S0 S5)
[    0.258961] ACPI: Using IOAPIC for interrupt routing
[    0.259057] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.261327] PCI: MCFG area at e0000000 reserved in ACPI motherboard reso=
urces
[    0.264254] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.271077] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.271114] PCI: 0000:00:02.0 reg 10 64bit mmio: [fe400000, fe7fffff]
[    0.271114] PCI: 0000:00:02.0 reg 18 32bit mmio: [d0000000, dfffffff]
[    0.271114] PCI: 0000:00:02.0 reg 20 io port: [cc00, cc07]
[    0.271114] PCI: 0000:00:02.1 reg 10 64bit mmio: [fe800000, fe8fffff]
[    0.271114] PCI: 0000:00:1a.0 reg 20 io port: [c480, c49f]
[    0.271162] PCI: 0000:00:1a.1 reg 20 io port: [c800, c81f]
[    0.272010] PCI: 0000:00:1a.2 reg 20 io port: [c880, c89f]
[    0.272059] PCI: 0000:00:1a.7 reg 10 32bit mmio: [fe3fbc00, fe3fbfff]
[    0.272095] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.272152] pci 0000:00:1a.7: PME# disabled
[    0.272225] PCI: 0000:00:1b.0 reg 10 64bit mmio: [fe3f4000, fe3f7fff]
[    0.272251] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.272308] pci 0000:00:1b.0: PME# disabled
[    0.272391] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.272447] pci 0000:00:1c.0: PME# disabled
[    0.272533] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.272589] pci 0000:00:1c.4: PME# disabled
[    0.272672] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.272728] pci 0000:00:1c.5: PME# disabled
[    0.272811] PCI: 0000:00:1d.0 reg 20 io port: [c000, c01f]
[    0.272857] PCI: 0000:00:1d.1 reg 20 io port: [c080, c09f]
[    0.272902] PCI: 0000:00:1d.2 reg 20 io port: [c400, c41f]
[    0.272951] PCI: 0000:00:1d.7 reg 10 32bit mmio: [fe3fb800, fe3fbbff]
[    0.272990] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.273047] pci 0000:00:1d.7: PME# disabled
[    0.273211] PCI: 0000:00:1f.2 reg 10 io port: [b880, b887]
[    0.273215] PCI: 0000:00:1f.2 reg 14 io port: [b800, b803]
[    0.273219] PCI: 0000:00:1f.2 reg 18 io port: [b480, b487]
[    0.273222] PCI: 0000:00:1f.2 reg 1c io port: [b400, b403]
[    0.273226] PCI: 0000:00:1f.2 reg 20 io port: [b080, b09f]
[    0.273230] PCI: 0000:00:1f.2 reg 24 32bit mmio: [fe3fa800, fe3fafff]
[    0.273246] pci 0000:00:1f.2: PME# supported from D3hot
[    0.273301] pci 0000:00:1f.2: PME# disabled
[    0.273364] PCI: 0000:00:1f.3 reg 10 64bit mmio: [fe3fb400, fe3fb4ff]
[    0.273374] PCI: 0000:00:1f.3 reg 20 io port: [400, 41f]
[    0.273417] PCI: bridge 0000:00:1c.0 64bit mmio pref: [fdf00000, fdfffff=
f]
[    0.273454] PCI: 0000:02:00.0 reg 10 io port: [ec00, ec07]
[    0.273460] PCI: 0000:02:00.0 reg 14 io port: [e880, e883]
[    0.273466] PCI: 0000:02:00.0 reg 18 io port: [e800, e807]
[    0.273472] PCI: 0000:02:00.0 reg 1c io port: [e480, e483]
[    0.273478] PCI: 0000:02:00.0 reg 20 io port: [e400, e40f]
[    0.273484] PCI: 0000:02:00.0 reg 24 32bit mmio: [feaffc00, feaffdff]
[    0.273509] pci 0000:02:00.0: supports D1
[    0.273510] pci 0000:02:00.0: PME# supported from D0 D1 D3hot
[    0.273567] pci 0000:02:00.0: PME# disabled
[    0.273640] PCI: bridge 0000:00:1c.4 io port: [e000, efff]
[    0.273642] PCI: bridge 0000:00:1c.4 32bit mmio: [fea00000, feafffff]
[    0.273681] PCI: 0000:01:00.0 reg 10 io port: [d800, d8ff]
[    0.273697] PCI: 0000:01:00.0 reg 18 64bit mmio: [fe9ff000, fe9fffff]
[    0.273704] PCI: 0000:01:00.0 reg 20 32bit mmio: [fdef0000, fdefffff]
[    0.273715] PCI: 0000:01:00.0 reg 30 32bit mmio: [fe9c0000, fe9dffff]
[    0.273737] pci 0000:01:00.0: supports D1
[    0.273738] pci 0000:01:00.0: supports D2
[    0.273739] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.273797] pci 0000:01:00.0: PME# disabled
[    0.273871] PCI: bridge 0000:00:1c.5 io port: [d000, dfff]
[    0.273873] PCI: bridge 0000:00:1c.5 32bit mmio: [fe900000, fe9fffff]
[    0.273877] PCI: bridge 0000:00:1c.5 64bit mmio pref: [fde00000, fdeffff=
f]
[    0.273905] PCI: 0000:04:03.0 reg 10 32bit mmio: [febff000, febfffff]
[    0.273937] pci 0000:04:03.0: supports D1
[    0.273938] pci 0000:04:03.0: supports D2
[    0.273939] pci 0000:04:03.0: PME# supported from D0 D1 D2 D3hot
[    0.273960] pci 0000:04:03.0: PME# disabled
[    0.274039] pci 0000:00:1e.0: transparent bridge
[    0.274093] PCI: bridge 0000:00:1e.0 32bit mmio: [feb00000, febfffff]
[    0.274109] bus 00 -> node 0
[    0.274114] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.274286] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.274376] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.274457] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    0.274534] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.290069] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14=
 15)
[    0.290433] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14=
 15)
[    0.291057] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 =
*15)
[    0.291407] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14=
 15)
[    0.291759] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 =
15) *0, disabled.
[    0.292191] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 *14=
 15)
[    0.292540] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14=
 15)
[    0.292890] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14=
 15)
[    0.293192] ACPI Warning (tbutils-0217): Incorrect checksum in table [OE=
MB] - F0, should be E8 [20080609]
[    0.294176] ACPI: WMI: Mapper loaded
[    0.294176] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.294176] pnp: PnP ACPI init
[    0.294176] ACPI: bus type pnp registered
[    0.297277] pnp: PnP ACPI: found 15 devices
[    0.297329] ACPI: ACPI bus type pnp unregistered
[    0.297389] SCSI subsystem initialized
[    0.297968] libata version 3.00 loaded.
[    0.297973] usbcore: registered new interface driver usbfs
[    0.298029] usbcore: registered new interface driver hub
[    0.298029] usbcore: registered new device driver usb
[    0.298029] PCI: Using ACPI for IRQ routing
[    0.302971] PCI-GART: No AMD northbridge found.
[    0.303028] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.303172] hpet0: 4 64-bit timers, 14318180 Hz
[    0.304959] Switched to high resolution mode on CPU 0
[    0.305035] Switched to high resolution mode on CPU 1
[    0.305294] Switched to high resolution mode on CPU 2
[    0.305334] Switched to high resolution mode on CPU 3
[    0.308016] system 00:01: iomem range 0xfed14000-0xfed19fff has been res=
erved
[    0.308080] system 00:07: ioport range 0x290-0x29f has been reserved
[    0.308147] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.308203] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.308261] system 00:08: ioport range 0x500-0x57f has been reserved
[    0.308316] system 00:08: iomem range 0xfed08000-0xfed08fff has been res=
erved
[    0.308372] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been res=
erved
[    0.308431] system 00:08: iomem range 0xfed20000-0xfed3ffff has been res=
erved
[    0.308488] system 00:08: iomem range 0xfed50000-0xfed8ffff has been res=
erved
[    0.308546] system 00:0b: iomem range 0xffc00000-0xffefffff has been res=
erved
[    0.308604] system 00:0c: iomem range 0xfec00000-0xfec00fff has been res=
erved
[    0.308661] system 00:0c: iomem range 0xfee00000-0xfee00fff could not be=
 reserved
[    0.308746] system 00:0d: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.308804] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
[    0.308860] system 00:0e: iomem range 0xc0000-0xcffff has been reserved
[    0.308916] system 00:0e: iomem range 0xe0000-0xfffff could not be reser=
ved
[    0.308972] system 00:0e: iomem range 0x100000-0xc7dfffff could not be r=
eserved
[    0.309061] system 00:0e: iomem range 0xe0000000-0xffffffff could not be=
 reserved
[    0.314243] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:03
[    0.314300] pci 0000:00:1c.0:   IO window: disabled
[    0.314355] pci 0000:00:1c.0:   MEM window: disabled
[    0.314412] pci 0000:00:1c.0:   PREFETCH window: 0x000000fdf00000-0x0000=
00fdffffff
[    0.314499] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:02
[    0.314554] pci 0000:00:1c.4:   IO window: 0xe000-0xefff
[    0.314609] pci 0000:00:1c.4:   MEM window: 0xfea00000-0xfeafffff
[    0.314665] pci 0000:00:1c.4:   PREFETCH window: disabled
[    0.314721] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:01
[    0.314776] pci 0000:00:1c.5:   IO window: 0xd000-0xdfff
[    0.314832] pci 0000:00:1c.5:   MEM window: 0xfe900000-0xfe9fffff
[    0.314887] pci 0000:00:1c.5:   PREFETCH window: 0x000000fde00000-0x0000=
00fdefffff
[    0.314974] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:04
[    0.315034] pci 0000:00:1e.0:   IO window: disabled
[    0.315088] pci 0000:00:1e.0:   MEM window: 0xfeb00000-0xfebfffff
[    0.315147] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.315209] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.315270] pci 0000:00:1c.0: setting latency timer to 64
[    0.315274] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.315331] pci 0000:00:1c.4: setting latency timer to 64
[    0.315336] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.315397] pci 0000:00:1c.5: setting latency timer to 64
[    0.315401] pci 0000:00:1e.0: setting latency timer to 64
[    0.315403] bus: 00 index 0 io port: [0, ffff]
[    0.315455] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    0.315508] bus: 03 index 0 mmio: [0, 0]
[    0.315559] bus: 03 index 1 mmio: [0, 0]
[    0.316113] bus: 03 index 2 mmio: [fdf00000, fdffffff]
[    0.316169] bus: 03 index 3 mmio: [0, 0]
[    0.316220] bus: 02 index 0 io port: [e000, efff]
[    0.316275] bus: 02 index 1 mmio: [fea00000, feafffff]
[    0.316328] bus: 02 index 2 mmio: [0, 0]
[    0.316380] bus: 02 index 3 mmio: [0, 0]
[    0.316431] bus: 01 index 0 io port: [d000, dfff]
[    0.316483] bus: 01 index 1 mmio: [fe900000, fe9fffff]
[    0.316536] bus: 01 index 2 mmio: [fde00000, fdefffff]
[    0.316589] bus: 01 index 3 mmio: [0, 0]
[    0.316639] bus: 04 index 0 mmio: [0, 0]
[    0.316690] bus: 04 index 1 mmio: [feb00000, febfffff]
[    0.316743] bus: 04 index 2 mmio: [0, 0]
[    0.316793] bus: 04 index 3 io port: [0, ffff]
[    0.316845] bus: 04 index 4 mmio: [0, ffffffffffffffff]
[    0.316903] NET: Registered protocol family 2
[    0.327028] IP route cache hash table entries: 262144 (order: 9, 2097152=
 bytes)
[    0.327387] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    0.328377] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.328760] TCP: Hash tables configured (established 262144 bind 65536)
[    0.328816] TCP reno registered
[    0.331062] NET: Registered protocol family 1
[    0.332659] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet=
=2Eco.uk>
[    0.333209] audit: initializing netlink socket (disabled)
[    0.333281] type=3D2000 audit(1223392688.333:1): initialized
[    0.333883] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.336418] msgmni has been set to 15706
[    0.336611] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 254)
[    0.336698] io scheduler noop registered
[    0.336751] io scheduler anticipatory registered
[    0.336805] io scheduler deadline registered
[    0.336904] io scheduler cfq registered (default)
[    0.336966] pci 0000:00:02.0: Boot video device
[    0.336973] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup =3D 0x0f30
[    0.336974] pci 0000:00:1a.0: Performing full reset
[    0.336988] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup =3D 0x0030
[    0.336990] pci 0000:00:1a.1: Performing full reset
[    0.337003] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup =3D 0x0030
[    0.337005] pci 0000:00:1a.2: Performing full reset
[    0.337041] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup =3D 0x0f30
[    0.337042] pci 0000:00:1d.0: Performing full reset
[    0.337056] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup =3D 0x0030
[    0.337057] pci 0000:00:1d.1: Performing full reset
[    0.337070] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup =3D 0x0030
[    0.337072] pci 0000:00:1d.2: Performing full reset
[    0.337199] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.337226] pcieport-driver 0000:00:1c.0: found MSI capability
[    0.337313] pci_express 0000:00:1c.0:pcie00: allocate port service
[    0.337353] pci_express 0000:00:1c.0:pcie02: allocate port service
[    0.337393] pci_express 0000:00:1c.0:pcie03: allocate port service
[    0.337477] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.337503] pcieport-driver 0000:00:1c.4: found MSI capability
[    0.337584] pci_express 0000:00:1c.4:pcie00: allocate port service
[    0.337622] pci_express 0000:00:1c.4:pcie02: allocate port service
[    0.337660] pci_express 0000:00:1c.4:pcie03: allocate port service
[    0.337744] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    0.337769] pcieport-driver 0000:00:1c.5: found MSI capability
[    0.337850] pci_express 0000:00:1c.5:pcie00: allocate port service
[    0.337887] pci_express 0000:00:1c.5:pcie02: allocate port service
[    0.337924] pci_express 0000:00:1c.5:pcie03: allocate port service
[    0.338339] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00=
/input/input0
[    0.338436] ACPI: Power Button (FF) [PWRF]
[    0.338568] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/P=
NP0C0C:00/input/input1
[    0.338658] ACPI: Power Button (CM) [PWRB]
[    0.339277] ACPI: SSDT C7D90100, 0235 (r1 DpgPmm  P001Ist       11 INTL =
20060113)
[    0.339963] processor ACPI0007:00: registered as cooling_device0
[    0.340399] ACPI: SSDT C7D90340, 0235 (r1 DpgPmm  P002Ist       12 INTL =
20060113)
[    0.341064] processor ACPI0007:01: registered as cooling_device1
[    0.341484] ACPI: SSDT C7D90580, 0235 (r1 DpgPmm  P003Ist       12 INTL =
20060113)
[    0.342149] processor ACPI0007:02: registered as cooling_device2
[    0.342581] ACPI: SSDT C7D907C0, 0235 (r1 DpgPmm  P004Ist       12 INTL =
20060113)
[    0.343244] processor ACPI0007:03: registered as cooling_device3
[    0.383547] Real Time Clock Driver v1.12ac
[    0.383743] hpet_resources: 0xfed00000 is busy
[    0.383861] Non-volatile memory driver v1.2
[    0.383915] Linux agpgart interface v0.103
[    0.383979] agpgart-intel 0000:00:00.0: Intel G45/G43 Chipset
[    0.385886] agpgart-intel 0000:00:00.0: detected 131072K stolen memory
[    0.393711] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.393873] ipmi message handler version 39.2
[    0.393935] ipmi device interface
[    0.394060] IPMI System Interface driver.
[    0.404453] ipmi_si: Unable to find any System Interface(s)
[    0.404556] [drm] Initialized drm 1.1.0 20060810
[    0.404671] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.404731] pci 0000:00:02.0: setting latency timer to 64
[    0.404870] [drm] Initialized i915 1.6.0 20060119 on minor 0
[    0.406390] brd: module loaded
[    0.407184] loop: module loaded
[    0.407339] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.407409] r8169 0000:01:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ =
17
[    0.407490] r8169 0000:01:00.0: setting latency timer to 64
[    0.407635] eth0: RTL8168c/8111c at 0xffffc20000052000, 00:22:15:98:31:9=
a, XID 3c4000c0 IRQ 380
[    0.409617] Driver 'sd' needs updating - please use bus_type methods
[    0.409707] Driver 'sr' needs updating - please use bus_type methods
[    0.409853] ahci 0000:00:1f.2: version 3.0
[    0.409862] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.410002] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x=
3f impl SATA mode
[    0.410093] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp=
 pio slum part ems=20
[    0.410187] ahci 0000:00:1f.2: setting latency timer to 64
[    0.410381] scsi0 : ahci
[    0.410568] scsi1 : ahci
[    0.410723] scsi2 : ahci
[    0.410887] scsi3 : ahci
[    0.411053] scsi4 : ahci
[    0.411218] scsi5 : ahci
[    0.411436] ata1: SATA max UDMA/133 abar m2048@0xfe3fa800 port 0xfe3fa90=
0 irq 379
[    0.411525] ata2: SATA max UDMA/133 abar m2048@0xfe3fa800 port 0xfe3fa98=
0 irq 379
[    0.411613] ata3: SATA max UDMA/133 abar m2048@0xfe3fa800 port 0xfe3faa0=
0 irq 379
[    0.411701] ata4: SATA max UDMA/133 abar m2048@0xfe3fa800 port 0xfe3faa8=
0 irq 379
[    0.411789] ata5: SATA max UDMA/133 abar m2048@0xfe3fa800 port 0xfe3fab0=
0 irq 379
[    0.411877] ata6: SATA max UDMA/133 abar m2048@0xfe3fa800 port 0xfe3fab8=
0 irq 379
[    0.716015] ata1: SATA link down (SStatus 0 SControl 300)
[    1.032013] ata2: SATA link down (SStatus 0 SControl 300)
[    1.501015] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.514003] ata3.00: ATA-8: WDC WD3000BLFS-01YBU0, 04.04V01, max UDMA/133
[    1.514062] ata3.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.520844] ata3.00: configured for UDMA/133
[    1.836013] ata4: SATA link down (SStatus 0 SControl 300)
[    2.723013] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.724953] ata5.00: ATAPI: PIONEER DVD-RW  DVR-216D, 1.04, max UDMA/66
[    2.727214] ata5.00: configured for UDMA/66
[    3.614014] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.630592] ata6.00: ATA-8: WDC WD3000BLFS-01YBU0, 04.04V01, max UDMA/133
[    3.630651] ata6.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.636469] ata6.00: configured for UDMA/133
[    3.647092] scsi 2:0:0:0: Direct-Access     ATA      WDC WD3000BLFS-0 04=
=2E0 PQ: 0 ANSI: 5
[    3.647359] sd 2:0:0:0: [sda] 586072368 512-byte hardware sectors (30006=
9 MB)
[    3.647449] sd 2:0:0:0: [sda] Write Protect is off
[    3.647504] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.647530] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.647672] sd 2:0:0:0: [sda] 586072368 512-byte hardware sectors (30006=
9 MB)
[    3.647745] sd 2:0:0:0: [sda] Write Protect is off
[    3.647802] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.647827] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.647920]  sda: sda1 sda2 sda3 sda4
[    3.749699] sd 2:0:0:0: [sda] Attached SCSI disk
[    3.749907] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    3.756210] scsi 4:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-216D 1.=
04 PQ: 0 ANSI: 5
[    3.774413] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    3.774474] Uniform CD-ROM driver Revision: 3.20
[    3.774641] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    3.774747] sr 4:0:0:0: Attached scsi generic sg1 type 5
[    3.774914] scsi 5:0:0:0: Direct-Access     ATA      WDC WD3000BLFS-0 04=
=2E0 PQ: 0 ANSI: 5
[    3.775167] sd 5:0:0:0: [sdb] 586072368 512-byte hardware sectors (30006=
9 MB)
[    3.775240] sd 5:0:0:0: [sdb] Write Protect is off
[    3.775304] sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.775330] sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.775470] sd 5:0:0:0: [sdb] 586072368 512-byte hardware sectors (30006=
9 MB)
[    3.775544] sd 5:0:0:0: [sdb] Write Protect is off
[    3.775609] sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.775634] sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.775727]  sdb: sdb1 sdb2 sdb3 sdb4
[    3.778103] sd 5:0:0:0: [sdb] Attached SCSI disk
[    3.778259] sd 5:0:0:0: Attached scsi generic sg2 type 0
[    3.778490] firewire_ohci 0000:04:03.0: PCI INT A -> GSI 19 (level, low)=
 -> IRQ 19
[    3.835009] firewire_ohci: Added fw-ohci device 0000:04:03.0, OHCI versi=
on 1.0
[    3.835243] ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
[    3.835263] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[    3.835327] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    3.835330] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    3.835447] drivers/usb/core/inode.c: creating file 'devices'
[    3.835450] drivers/usb/core/inode.c: creating file '001'
[    3.835454] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus =
number 1
[    3.835545] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=3D1 cc=
=3D3 pcc=3D2 ordered !ppc ports=3D6
[    3.835548] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 ufram=
es 1024 64 bit addr
[    3.835563] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=3D0 ithre=
sh=3D8 period=3D1024 Reset HALT
[    3.839464] ehci_hcd 0000:00:1a.7: debug port 1
[    3.839519] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    3.839520] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    3.839528] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfe3fbc00
[    3.839584] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=3D0 ithre=
sh=3D8 period=3D1024 Reset HALT
[    3.843455] ehci_hcd 0000:00:1a.7: init command 010001 (park)=3D0 ithres=
h=3D1 period=3D1024 RUN
[    3.849011] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[    3.849115] usb usb1: default language 0x0409
[    3.849152] usb usb1: uevent
[    3.849199] usb usb1: usb_probe_device
[    3.849201] usb usb1: configuration #1 chosen from 1 choice
[    3.849260] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    3.849272] usb 1-0:1.0: uevent
[    3.849309] hub 1-0:1.0: usb_probe_interface
[    3.849311] hub 1-0:1.0: usb_probe_interface - got id
[    3.849313] hub 1-0:1.0: USB hub found
[    3.849369] hub 1-0:1.0: 6 ports detected
[    3.849430] hub 1-0:1.0: standalone hub
[    3.849431] hub 1-0:1.0: no power switching (usb 1.0)
[    3.849432] hub 1-0:1.0: individual port over-current protection
[    3.849433] hub 1-0:1.0: power on to power good time: 20ms
[    3.849435] hub 1-0:1.0: local power source is good
[    3.849437] hub 1-0:1.0: trying to enable port power on non-switchable h=
ub
[    3.950019] ehci_hcd 0000:00:1a.7: GetStatus port 5 status 001803 POWER =
sig=3Dj CSC CONNECT
[    3.950021] hub 1-0:1.0: port 5: status 0501 change 0001
[    4.051019] hub 1-0:1.0: state 7 ports 6 chg 0020 evt 0000
[    4.051125] drivers/usb/core/inode.c: creating file '001'
[    4.051140] hub 1-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
[    4.051189] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    4.051248] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    4.051334] usb usb1: Product: EHCI Host Controller
[    4.051393] usb usb1: Manufacturer: Linux 2.6.27-rc8 ehci_hcd
[    4.051453] usb usb1: SerialNumber: 0000:00:1a.7
[    4.051517] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> I=
RQ 23
[    4.051578] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.051580] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.051677] drivers/usb/core/inode.c: creating file '002'
[    4.051681] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 2
[    4.051771] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=3D1 cc=
=3D3 pcc=3D2 ordered !ppc ports=3D6
[    4.051774] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 ufram=
es 1024 64 bit addr
[    4.051787] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=3D0 ithre=
sh=3D8 period=3D1024 Reset HALT
[    4.055676] ehci_hcd 0000:00:1d.7: debug port 1
[    4.055731] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    4.055732] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    4.055739] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe3fb800
[    4.055795] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=3D0 ithre=
sh=3D8 period=3D1024 Reset HALT
[    4.059669] ehci_hcd 0000:00:1d.7: init command 010001 (park)=3D0 ithres=
h=3D1 period=3D1024 RUN
[    4.102231] ehci_hcd 0000:00:1a.7: port 5 high speed
[    4.102235] ehci_hcd 0000:00:1a.7: GetStatus port 5 status 001005 POWER =
sig=3Dse0 PE CONNECT
[    4.153012] usb 1-5: new high speed USB device using ehci_hcd and addres=
s 2
[    4.159015] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[    4.159125] usb usb2: default language 0x0409
[    4.159151] usb usb2: uevent
[    4.159198] usb usb2: usb_probe_device
[    4.159200] usb usb2: configuration #1 chosen from 1 choice
[    4.159259] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    4.159270] usb 2-0:1.0: uevent
[    4.159309] hub 2-0:1.0: usb_probe_interface
[    4.159311] hub 2-0:1.0: usb_probe_interface - got id
[    4.159312] hub 2-0:1.0: USB hub found
[    4.159368] hub 2-0:1.0: 6 ports detected
[    4.159426] hub 2-0:1.0: standalone hub
[    4.159427] hub 2-0:1.0: no power switching (usb 1.0)
[    4.159428] hub 2-0:1.0: individual port over-current protection
[    4.159429] hub 2-0:1.0: power on to power good time: 20ms
[    4.159431] hub 2-0:1.0: local power source is good
[    4.159432] hub 2-0:1.0: trying to enable port power on non-switchable h=
ub
[    4.210231] ehci_hcd 0000:00:1a.7: port 5 high speed
[    4.210233] ehci_hcd 0000:00:1a.7: GetStatus port 5 status 001005 POWER =
sig=3Dse0 PE CONNECT
[    4.260010] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001403 POWER =
sig=3Dk CSC CONNECT
[    4.260013] hub 2-0:1.0: port 1: status 0501 change 0001
[    4.260019] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001403 POWER =
sig=3Dk CSC CONNECT
[    4.260021] hub 2-0:1.0: port 2: status 0501 change 0001
[    4.335096] firewire_core: created device fw0: GUID 001e8c000173a20d, S4=
00
[    4.361077] drivers/usb/core/inode.c: creating file '001'
[    4.361151] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    4.361208] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    4.361293] usb usb2: Product: EHCI Host Controller
[    4.361346] usb usb2: Manufacturer: Linux 2.6.27-rc8 ehci_hcd
[    4.361403] usb usb2: SerialNumber: 0000:00:1d.7
[    4.361499] USB Universal Host Controller Interface driver v3.0
[    4.361575] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[    4.361639] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.361641] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.361749] drivers/usb/core/inode.c: creating file '003'
[    4.361752] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 3
[    4.361843] uhci_hcd 0000:00:1a.0: detected 2 ports
[    4.361901] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd =3D 0x00=
00
[    4.361902] uhci_hcd 0000:00:1a.0: Performing full reset
[    4.361914] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    4.361925] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000c480
[    4.362011] usb usb3: default language 0x0409
[    4.362036] usb usb3: uevent
[    4.362074] usb usb3: usb_probe_device
[    4.362075] usb usb3: configuration #1 chosen from 1 choice
[    4.362137] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    4.362149] usb 3-0:1.0: uevent
[    4.362181] hub 3-0:1.0: usb_probe_interface
[    4.362182] hub 3-0:1.0: usb_probe_interface - got id
[    4.362184] hub 3-0:1.0: USB hub found
[    4.362240] hub 3-0:1.0: 2 ports detected
[    4.362302] hub 3-0:1.0: standalone hub
[    4.362303] hub 3-0:1.0: no power switching (usb 1.0)
[    4.362304] hub 3-0:1.0: individual port over-current protection
[    4.362305] hub 3-0:1.0: power on to power good time: 2ms
[    4.362307] hub 3-0:1.0: local power source is good
[    4.362308] hub 3-0:1.0: trying to enable port power on non-switchable h=
ub
[    4.441246] usb 1-5: default language 0x0409
[    4.441657] usb 1-5: uevent
[    4.441695] usb 1-5: usb_probe_device
[    4.441698] usb 1-5: configuration #1 chosen from 1 choice
[    4.441870] usb 1-5: adding 1-5:1.0 (config #1, interface 0)
[    4.441884] usb 1-5:1.0: uevent
[    4.442058] drivers/usb/core/inode.c: creating file '002'
[    4.442116] usb 1-5: New USB device found, idVendor=3D1307, idProduct=3D=
0330
[    4.442179] usb 1-5: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[    4.442238] usb 1-5: Product: Mass Storage Device
[    4.442295] usb 1-5: Manufacturer: Generic  =20
[    4.442353] usb 1-5: SerialNumber: 00000000000006
[    4.442410] hub 2-0:1.0: state 7 ports 6 chg 0006 evt 0000
[    4.442413] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    4.442417] ehci_hcd 0000:00:1d.7: port 1 low speed --> companion
[    4.463082] drivers/usb/core/inode.c: creating file '001'
[    4.463159] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    4.463217] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    4.463304] usb usb3: Product: UHCI Host Controller
[    4.463358] usb usb3: Manufacturer: Linux 2.6.27-rc8 uhci_hcd
[    4.463422] usb usb3: SerialNumber: 0000:00:1a.0
[    4.463487] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[    4.463546] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.463548] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.463646] drivers/usb/core/inode.c: creating file '004'
[    4.463649] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus =
number 4
[    4.463739] uhci_hcd 0000:00:1a.1: detected 2 ports
[    4.463796] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd =3D 0x00=
00
[    4.463798] uhci_hcd 0000:00:1a.1: Performing full reset
[    4.463810] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    4.463819] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000c800
[    4.463899] usb usb4: default language 0x0409
[    4.463925] usb usb4: uevent
[    4.463964] usb usb4: usb_probe_device
[    4.463966] usb usb4: configuration #1 chosen from 1 choice
[    4.464031] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    4.464042] usb 4-0:1.0: uevent
[    4.464077] hub 4-0:1.0: usb_probe_interface
[    4.464078] hub 4-0:1.0: usb_probe_interface - got id
[    4.464080] hub 4-0:1.0: USB hub found
[    4.464138] hub 4-0:1.0: 2 ports detected
[    4.464197] hub 4-0:1.0: standalone hub
[    4.464198] hub 4-0:1.0: no power switching (usb 1.0)
[    4.464199] hub 4-0:1.0: individual port over-current protection
[    4.464200] hub 4-0:1.0: power on to power good time: 2ms
[    4.464202] hub 4-0:1.0: local power source is good
[    4.464203] hub 4-0:1.0: trying to enable port power on non-switchable h=
ub
[    4.493015] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 003002 POWER =
OWNER sig=3Dse0 CSC
[    4.493030] hub 2-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    4.493034] ehci_hcd 0000:00:1d.7: port 2 low speed --> companion
[    4.544010] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003002 POWER =
OWNER sig=3Dse0 CSC
[    4.544023] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0004
[    4.544027] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.565050] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.565083] drivers/usb/core/inode.c: creating file '001'
[    4.565162] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    4.565221] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    4.565308] usb usb4: Product: UHCI Host Controller
[    4.565363] usb usb4: Manufacturer: Linux 2.6.27-rc8 uhci_hcd
[    4.565427] usb usb4: SerialNumber: 0000:00:1a.1
[    4.565490] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[    4.565549] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.565551] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.565648] drivers/usb/core/inode.c: creating file '005'
[    4.565651] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus =
number 5
[    4.565742] uhci_hcd 0000:00:1a.2: detected 2 ports
[    4.565798] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd =3D 0x00=
00
[    4.565800] uhci_hcd 0000:00:1a.2: Performing full reset
[    4.565812] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    4.565816] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000c880
[    4.565895] usb usb5: default language 0x0409
[    4.565921] usb usb5: uevent
[    4.565960] usb usb5: usb_probe_device
[    4.565962] usb usb5: configuration #1 chosen from 1 choice
[    4.566028] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    4.566039] usb 5-0:1.0: uevent
[    4.566075] hub 5-0:1.0: usb_probe_interface
[    4.566076] hub 5-0:1.0: usb_probe_interface - got id
[    4.566078] hub 5-0:1.0: USB hub found
[    4.566136] hub 5-0:1.0: 2 ports detected
[    4.566195] hub 5-0:1.0: standalone hub
[    4.566195] hub 5-0:1.0: no power switching (usb 1.0)
[    4.566196] hub 5-0:1.0: individual port over-current protection
[    4.566198] hub 5-0:1.0: power on to power good time: 2ms
[    4.566200] hub 5-0:1.0: local power source is good
[    4.566201] hub 5-0:1.0: trying to enable port power on non-switchable h=
ub
[    4.667014] uhci_hcd 0000:00:1a.2: port 1 portsc 0082,00
[    4.768042] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.768076] drivers/usb/core/inode.c: creating file '001'
[    4.768149] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    4.768206] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    4.768290] usb usb5: Product: UHCI Host Controller
[    4.768342] usb usb5: Manufacturer: Linux 2.6.27-rc8 uhci_hcd
[    4.768399] usb usb5: SerialNumber: 0000:00:1a.2
[    4.768464] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> I=
RQ 23
[    4.768523] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.768525] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.768622] drivers/usb/core/inode.c: creating file '006'
[    4.768625] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 6
[    4.768715] uhci_hcd 0000:00:1d.0: detected 2 ports
[    4.768772] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd =3D 0x00=
00
[    4.768774] uhci_hcd 0000:00:1d.0: Performing full reset
[    4.768786] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    4.768789] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000c000
[    4.768868] usb usb6: default language 0x0409
[    4.768894] usb usb6: uevent
[    4.768935] usb usb6: usb_probe_device
[    4.768936] usb usb6: configuration #1 chosen from 1 choice
[    4.768995] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    4.769014] usb 6-0:1.0: uevent
[    4.769048] hub 6-0:1.0: usb_probe_interface
[    4.769049] hub 6-0:1.0: usb_probe_interface - got id
[    4.769050] hub 6-0:1.0: USB hub found
[    4.769110] hub 6-0:1.0: 2 ports detected
[    4.769172] hub 6-0:1.0: standalone hub
[    4.769172] hub 6-0:1.0: no power switching (usb 1.0)
[    4.769173] hub 6-0:1.0: individual port over-current protection
[    4.769174] hub 6-0:1.0: power on to power good time: 2ms
[    4.769177] hub 6-0:1.0: local power source is good
[    4.769178] hub 6-0:1.0: trying to enable port power on non-switchable h=
ub
[    4.870013] uhci_hcd 0000:00:1d.0: port 1 portsc 01ab,00
[    4.870015] hub 6-0:1.0: port 1: status 0301 change 0003
[    4.870024] uhci_hcd 0000:00:1d.0: port 2 portsc 01ab,00
[    4.870026] hub 6-0:1.0: port 2: status 0301 change 0003
[    4.971043] hub 6-0:1.0: state 7 ports 2 chg 0006 evt 0000
[    4.971077] drivers/usb/core/inode.c: creating file '001'
[    4.971125] hub 6-0:1.0: port 1, status 0301, change 0000, 1.5 Mb/s
[    4.971155] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    4.971214] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    4.971304] usb usb6: Product: UHCI Host Controller
[    4.971359] usb usb6: Manufacturer: Linux 2.6.27-rc8 uhci_hcd
[    4.971423] usb usb6: SerialNumber: 0000:00:1d.0
[    4.971486] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> I=
RQ 19
[    4.971545] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.971547] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.971644] drivers/usb/core/inode.c: creating file '007'
[    4.971647] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 7
[    4.971738] uhci_hcd 0000:00:1d.1: detected 2 ports
[    4.971795] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd =3D 0x00=
00
[    4.971796] uhci_hcd 0000:00:1d.1: Performing full reset
[    4.971808] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    4.971812] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000c080
[    4.971891] usb usb7: default language 0x0409
[    4.971918] usb usb7: uevent
[    4.971957] usb usb7: usb_probe_device
[    4.971959] usb usb7: configuration #1 chosen from 1 choice
[    4.972023] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    4.972034] usb 7-0:1.0: uevent
[    4.972068] hub 7-0:1.0: usb_probe_interface
[    4.972069] hub 7-0:1.0: usb_probe_interface - got id
[    4.972071] hub 7-0:1.0: USB hub found
[    4.972127] hub 7-0:1.0: 2 ports detected
[    4.972187] hub 7-0:1.0: standalone hub
[    4.972188] hub 7-0:1.0: no power switching (usb 1.0)
[    4.972189] hub 7-0:1.0: individual port over-current protection
[    4.972190] hub 7-0:1.0: power on to power good time: 2ms
[    4.972192] hub 7-0:1.0: local power source is good
[    4.972193] hub 7-0:1.0: trying to enable port power on non-switchable h=
ub
[    5.073012] usb 6-1: new low speed USB device using uhci_hcd and address=
 2
[    5.073162] drivers/usb/core/inode.c: creating file '001'
[    5.073229] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    5.073288] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.073381] usb usb7: Product: UHCI Host Controller
[    5.073433] usb usb7: Manufacturer: Linux 2.6.27-rc8 uhci_hcd
[    5.073487] usb usb7: SerialNumber: 0000:00:1d.1
[    5.073550] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[    5.073609] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.073611] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.073713] drivers/usb/core/inode.c: creating file '008'
[    5.073716] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 8
[    5.073807] uhci_hcd 0000:00:1d.2: detected 2 ports
[    5.073864] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd =3D 0x00=
00
[    5.073866] uhci_hcd 0000:00:1d.2: Performing full reset
[    5.073878] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    5.073881] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000c400
[    5.073963] usb usb8: default language 0x0409
[    5.073989] usb usb8: uevent
[    5.074034] usb usb8: usb_probe_device
[    5.074035] usb usb8: configuration #1 chosen from 1 choice
[    5.074095] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    5.074106] usb 8-0:1.0: uevent
[    5.074152] hub 8-0:1.0: usb_probe_interface
[    5.074154] hub 8-0:1.0: usb_probe_interface - got id
[    5.074155] hub 8-0:1.0: USB hub found
[    5.074211] hub 8-0:1.0: 2 ports detected
[    5.074269] hub 8-0:1.0: standalone hub
[    5.074269] hub 8-0:1.0: no power switching (usb 1.0)
[    5.074270] hub 8-0:1.0: individual port over-current protection
[    5.074272] hub 8-0:1.0: power on to power good time: 2ms
[    5.074274] hub 8-0:1.0: local power source is good
[    5.074275] hub 8-0:1.0: trying to enable port power on non-switchable h=
ub
[    5.175086] drivers/usb/core/inode.c: creating file '001'
[    5.175166] usb usb8: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    5.175225] usb usb8: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.175312] usb usb8: Product: UHCI Host Controller
[    5.175367] usb usb8: Manufacturer: Linux 2.6.27-rc8 uhci_hcd
[    5.175430] usb usb8: SerialNumber: 0000:00:1d.2
[    5.175539] libusual 1-5:1.0: usb_probe_interface
[    5.175543] libusual 1-5:1.0: usb_probe_interface - got id
[    5.214881] usb 6-1: skipped 1 descriptor after interface
[    5.219879] usb 6-1: default language 0x0409
[    5.235910] usb 6-1: uevent
[    5.235954] usb 6-1: usb_probe_device
[    5.235956] usb 6-1: configuration #1 chosen from 1 choice
[    5.238881] usb 6-1: adding 6-1:1.0 (config #1, interface 0)
[    5.238892] usb 6-1:1.0: uevent
[    5.238986] drivers/usb/core/inode.c: creating file '002'
[    5.239054] usb 6-1: New USB device found, idVendor=3D046d, idProduct=3D=
c046
[    5.239113] usb 6-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    5.239175] usb 6-1: Product: USB Optical Mouse
[    5.239230] usb 6-1: Manufacturer: Logitech
[    5.239295] hub 6-0:1.0: port 2, status 0301, change 0000, 1.5 Mb/s
[    5.341016] usb 6-2: new low speed USB device using uhci_hcd and address=
 3
[    5.573882] usb 6-2: skipped 1 descriptor after interface
[    5.573884] usb 6-2: skipped 1 descriptor after interface
[    5.587879] usb 6-2: default language 0x0409
[    5.657919] usb 6-2: uevent
[    5.657960] usb 6-2: usb_probe_device
[    5.657962] usb 6-2: configuration #1 chosen from 1 choice
[    5.669882] usb 6-2: adding 6-2:1.0 (config #1, interface 0)
[    5.669899] usb 6-2:1.0: uevent
[    5.670018] usb 6-2: adding 6-2:1.1 (config #1, interface 1)
[    5.670031] usb 6-2:1.1: uevent
[    5.670140] drivers/usb/core/inode.c: creating file '003'
[    5.670208] usb 6-2: New USB device found, idVendor=3D046d, idProduct=3D=
c30e
[    5.670275] usb 6-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    5.670332] usb 6-2: Product: HID compliant keyboard
[    5.670387] usb 6-2: Manufacturer: Logitech
[    5.670440] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.670442] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.670485] usbcore: registered new interface driver libusual
[    5.670691] PNP: No PS/2 controller found. Probing ports directly.
[    5.673527] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.673582] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.673714] mice: PS/2 mouse device common for all mice
[    5.705011] usb usb3: suspend_rh (auto-stop)
[    5.705028] usb usb4: suspend_rh (auto-stop)
[    5.724623] i2c /dev entries driver
[    5.724785] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) ->=
 IRQ 18
[    5.724875] ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with=
 ACPI region SMRG [0x400-0x40f]
[    5.724971] ACPI: Device needs an ACPI driver
[    5.735304] coretemp coretemp.0: Using relative temperature scale!
[    5.735469] coretemp coretemp.1: Using relative temperature scale!
[    5.735621] coretemp coretemp.2: Using relative temperature scale!
[    5.735784] coretemp coretemp.3: Using relative temperature scale!
[    5.735907] md: linear personality registered for level -1
[    5.735968] md: raid0 personality registered for level 0
[    5.736025] md: raid1 personality registered for level 1
[    5.736080] cpuidle: using governor ladder
[    5.736133] cpuidle: using governor menu
[    5.736258] usbcore: registered new interface driver hiddev
[    5.736325] usbhid 6-1:1.0: usb_probe_interface
[    5.736326] usbhid 6-1:1.0: usb_probe_interface - got id
[    5.750172] input: Logitech USB Optical Mouse as /devices/pci0000:00/000=
0:00:1d.0/usb6/6-1/6-1:1.0/input/input2
[    5.760360] input,hidraw0: USB HID v1.10 Mouse [Logitech USB Optical Mou=
se] on usb-0000:00:1d.0-1
[    5.760542] usbhid 6-2:1.0: usb_probe_interface
[    5.760543] usbhid 6-2:1.0: usb_probe_interface - got id
[    5.821142] input: Logitech HID compliant keyboard as /devices/pci0000:0=
0/0000:00:1d.0/usb6/6-2/6-2:1.0/input/input3
[    5.826011] uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 8, pha=
se 4, 118 us
[    5.829116] input,hidraw1: USB HID v1.10 Keyboard [Logitech HID complian=
t keyboard] on usb-0000:00:1d.0-2
[    5.829284] usbhid 6-2:1.1: usb_probe_interface
[    5.829285] usbhid 6-2:1.1: usb_probe_interface - got id
[    5.945973] input: Logitech HID compliant keyboard as /devices/pci0000:0=
0/0000:00:1d.0/usb6/6-2/6-2:1.1/input/input4
[    5.948137] uhci_hcd 0000:00:1d.0: reserve dev 3 ep82-INT, period 8, pha=
se 4, 118 us
[    5.951243] input,hidraw2: USB HID v1.10 Device [Logitech HID compliant =
keyboard] on usb-0000:00:1d.0-2
[    5.951450] usbcore: registered new interface driver usbhid
[    5.951507] usbhid: v2.6:USB HID core driver
[    5.951612] Advanced Linux Sound Architecture Driver Version 1.0.17.
[    5.952022] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> =
IRQ 22
[    5.952131] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.954014] usb usb5: suspend_rh (auto-stop)
[    5.962023] hda_codec: Unknown model for ALC883, trying auto-probe from =
BIOS...
[    6.010145] ALSA device list:
[    6.010197]   #0: HDA Intel at 0xfe3f4000 irq 22
[    6.010280] IPv4 over IPv4 tunneling driver
[    6.010465] TCP cubic registered
[    6.010517] Initializing XFRM netlink socket
[    6.010572] NET: Registered protocol family 17
[    6.011542] registered taskstats version 1
[    6.011822] md: Autodetecting RAID arrays.
[    6.011876] md: Scanned 0 and added 0 devices.
[    6.011930] md: autorun ...
[    6.011980] md: ... autorun DONE.
[    6.012059] md: Loading md1: /dev/sda1
[    6.045626] md: bind<sda1>
[    6.077147] md: bind<sdb1>
[    6.077331] raid1: raid set md1 active with 2 out of 2 mirrors
[    6.077491] md: Loading md2: /dev/sda2
[    6.083832] md: bind<sda2>
[    6.088036] md: bind<sdb2>
[    6.088171] md2: setting max_sectors to 128, segment boundary to 32767
[    6.088230] raid0: looking at sdb2
[    6.088282] raid0:   comparing sdb2(4008128) with sdb2(4008128)
[    6.088357] raid0:   END
[    6.088414] raid0:   =3D=3D> UNIQUE
[    6.088463] raid0: 1 zones
[    6.088511] raid0: looking at sda2
[    6.089073] raid0:   comparing sda2(4008128) with sdb2(4008128)
[    6.089147] raid0:   EQUAL
[    6.089195] raid0: FINAL 1 zones
[    6.089244] raid0: done.
[    6.089292] raid0 : md_size is 8016256 blocks.
[    6.089343] raid0 : conf->hash_spacing is 8016256 blocks.
[    6.089399] raid0 : nb_zone is 1.
[    6.089448] raid0 : Allocating 8 bytes for hash.
[    6.089586] md: Loading md3: /dev/sda3
[    6.097022] md: bind<sda3>
[    6.102531] md: bind<sdb3>
[    6.102656] md3: setting max_sectors to 128, segment boundary to 32767
[    6.102714] raid0: looking at sdb3
[    6.102766] raid0:   comparing sdb3(48837504) with sdb3(48837504)
[    6.102841] raid0:   END
[    6.102890] raid0:   =3D=3D> UNIQUE
[    6.102941] raid0: 1 zones
[    6.102992] raid0: looking at sda3
[    6.103043] raid0:   comparing sda3(48837504) with sdb3(48837504)
[    6.103118] raid0:   EQUAL
[    6.103172] raid0: FINAL 1 zones
[    6.103223] raid0: done.
[    6.103279] raid0 : md_size is 97675008 blocks.
[    6.103333] raid0 : conf->hash_spacing is 97675008 blocks.
[    6.103392] raid0 : nb_zone is 1.
[    6.103443] raid0 : Allocating 8 bytes for hash.
[    6.103562] md: Loading md4: /dev/sda4
[    6.115824] md: bind<sda4>
[    6.124754] md: bind<sdb4>
[    6.124879] md4: setting max_sectors to 128, segment boundary to 32767
[    6.124937] raid0: looking at sdb4
[    6.124990] raid0:   comparing sdb4(239930688) with sdb4(239930688)
[    6.125073] raid0:   END
[    6.125123] raid0:   =3D=3D> UNIQUE
[    6.125177] raid0: 1 zones
[    6.125228] raid0: looking at sda4
[    6.125283] raid0:   comparing sda4(239930688) with sdb4(239930688)
[    6.125358] raid0:   EQUAL
[    6.125412] raid0: FINAL 1 zones
[    6.125464] raid0: done.
[    6.125514] raid0 : md_size is 479861376 blocks.
[    6.125568] raid0 : conf->hash_spacing is 479861376 blocks.
[    6.125624] raid0 : nb_zone is 1.
[    6.125676] raid0 : Allocating 8 bytes for hash.
[    6.126032] ReiserFS: md3: found reiserfs format "3.6" with standard jou=
rnal
[    6.126094] ReiserFS: md3: using ordered data mode
[    6.134961] ReiserFS: md3: journal params: device md3, size 8192, journa=
l first block 18, max trans len 1024, max batch 900, max commit age 30, max=
 trans age 30
[    6.135399] ReiserFS: md3: checking transaction log (md3)
[    6.172271] ReiserFS: md3: Using r5 hash to sort names
[    6.172341] VFS: Mounted root (reiserfs filesystem) readonly.
[    6.172413] Freeing unused kernel memory: 348k freed
[    6.204020] usb usb7: suspend_rh (auto-stop)
[    6.204038] usb usb8: suspend_rh (auto-stop)
[    6.704024] hub 2-0:1.0: hub_suspend
[    6.704028] usb usb2: bus auto-suspend
[    6.704030] ehci_hcd 0000:00:1d.7: suspend root hub
[    6.704049] hub 3-0:1.0: hub_suspend
[    6.704052] usb usb3: bus auto-suspend
[    6.704053] usb usb3: suspend_rh
[    6.704066] hub 4-0:1.0: hub_suspend
[    6.704068] usb usb4: bus auto-suspend
[    6.704070] usb usb4: suspend_rh
[    6.768013] hub 5-0:1.0: hub_suspend
[    6.768017] usb usb5: bus auto-suspend
[    6.768019] usb usb5: suspend_rh
[    7.370223] usb usb3: uevent
[    7.370234] usb 3-0:1.0: uevent
[    7.370282] usb usb4: uevent
[    7.370291] usb 4-0:1.0: uevent
[    7.370327] usb usb5: uevent
[    7.370337] usb 5-0:1.0: uevent
[    7.370372] usb usb1: uevent
[    7.370380] usb 1-0:1.0: uevent
[    7.370396] usb 1-5: uevent
[    7.370405] usb 1-5:1.0: uevent
[    7.370649] usb usb6: uevent
[    7.370658] usb 6-0:1.0: uevent
[    7.370674] usb 6-1: uevent
[    7.370682] usb 6-1:1.0: uevent
[    7.370733] usb 6-2: uevent
[    7.370742] usb 6-2:1.0: uevent
[    7.370779] usb 6-2:1.1: uevent
[    7.370844] usb usb7: uevent
[    7.370852] usb 7-0:1.0: uevent
[    7.370888] usb usb8: uevent
[    7.370896] usb 8-0:1.0: uevent
[    7.370933] usb usb2: uevent
[    7.370942] usb 2-0:1.0: uevent
[    7.425042] pata_marvell 0000:02:00.0: PCI INT A -> GSI 16 (level, low) =
=2D> IRQ 16
[    7.425066] pata_marvell 0000:02:00.0: setting latency timer to 64
[    7.425135] scsi6 : pata_marvell
[    7.425522] scsi7 : pata_marvell
[    7.425550] ata7: PATA max UDMA/100 cmd 0xec00 ctl 0xe880 bmdma 0xe400 i=
rq 16
[    7.425551] ata8: DUMMY
[    7.579790] ata7.00: ATAPI: PIONEER DVD-RW  DVR-110D, 1.41, max UDMA/66
[    7.582800] ata7.00: configured for UDMA/66
[    7.588960] scsi 6:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-110D 1.=
41 PQ: 0 ANSI: 5
[    7.610336] sr1: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    7.610428] sr 6:0:0:0: Attached scsi CD-ROM sr1
[    7.610518] sr 6:0:0:0: Attached scsi generic sg3 type 5
[    7.701137] hub 7-0:1.0: hub_suspend
[    7.701143] usb usb7: bus auto-suspend
[    7.701145] usb usb7: suspend_rh
[    7.701161] hub 8-0:1.0: hub_suspend
[    7.701163] usb usb8: bus auto-suspend
[    7.701165] usb usb8: suspend_rh
[   66.841307] ReiserFS: md1: found reiserfs format "3.6" with standard jou=
rnal
[   66.841313] ReiserFS: md1: using ordered data mode
[   66.848085] ReiserFS: md1: journal params: device md1, size 8192, journa=
l first block 18, max trans len 1024, max batch 900, max commit age 30, max=
 trans age 30
[   66.848444] ReiserFS: md1: checking transaction log (md1)
[   66.869315] ReiserFS: md1: Using r5 hash to sort names
[   66.880781] ReiserFS: md4: found reiserfs format "3.6" with standard jou=
rnal
[   66.880787] ReiserFS: md4: using ordered data mode
[   66.884299] ReiserFS: md4: journal params: device md4, size 8192, journa=
l first block 18, max trans len 1024, max batch 900, max commit age 30, max=
 trans age 30
[   66.884621] ReiserFS: md4: checking transaction log (md4)
[   66.926191] ReiserFS: md4: Using r5 hash to sort names
[   83.746654] r8169: eth0: link up
[   83.746662] r8169: eth0: link up
[   93.118468] Adding 8016248k swap on /dev/md2.  Priority:-1 extents:1 acr=
oss:8016248k
[  117.435187] usb usb3: uevent
[  117.435229] usb 3-0:1.0: uevent
[  117.435348] usb usb4: uevent
[  117.435387] usb 4-0:1.0: uevent
[  117.435500] usb usb5: uevent
[  117.435538] usb 5-0:1.0: uevent
[  117.435651] usb usb1: uevent
[  117.435689] usb 1-0:1.0: uevent
[  117.435744] usb 1-5: uevent
[  117.435782] usb 1-5:1.0: uevent
[  117.436778] usb usb6: uevent
[  117.436816] usb 6-0:1.0: uevent
[  117.436869] usb 6-1: uevent
[  117.436903] usb 6-1:1.0: uevent
[  117.437112] usb 6-2: uevent
[  117.437152] usb 6-2:1.0: uevent
[  117.437294] usb 6-2:1.1: uevent
[  117.437517] usb usb7: uevent
[  117.437556] usb 7-0:1.0: uevent
[  117.437670] usb usb8: uevent
[  117.437710] usb 8-0:1.0: uevent
[  117.437828] usb usb2: uevent
[  117.437866] usb 2-0:1.0: uevent
--Boundary-01=_mJg9IkHDwO30YhV--

--nextPart2085285.TyOOzOxHvc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkj2AmgACgkQtEGUx4TfHiTV3gCfVxUJ+LKveGjjmtbB2aYnW7VX
pQoAoJpM2mPPd6EtX59EQZi4EynalBj5
=N+qC
-----END PGP SIGNATURE-----

--nextPart2085285.TyOOzOxHvc--
