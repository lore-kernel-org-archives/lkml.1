Return-Path: <linux-kernel-owner+w=401wt.eu-S933329AbZHVT3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329AbZHVT3H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 15:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbZHVT3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 15:29:06 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:52836 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbZHVT3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 15:29:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=osOvO4nvqkkg5xet+4uWy+Elpv0p1boDSwbzwoOogJE9nXTK9hLmx9ScWasidQa6PJ
         CZu3uy3CEM151dsg1PbHQuauQW0qyqWGzsl9Ava/LiR0lnk9bMq0ZRPSq1kYMt+TRC4h
         4qPp1doBa0Msa9LG7uYlXhRowQypMcqXBIz+U=
To: linux-kernel@vger.kernel.org
Subject: Re: amd64 + mtrr: only 3.1gb of 8gb are covered, kernel 2.6.30 and earlier.
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
Date: Sat, 22 Aug 2009 21:29:02 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908222129.02984.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 22 August 2009, you wrote:
> On Sat, Aug 22, 2009 at 11:54 AM, Volker Armin
>
> Hemmann<volkerarmin@googlemail.com> wrote:
> > On Samstag 22 August 2009, Yinghai Lu wrote:
> >> On Fri, Aug 21, 2009 at 9:14 AM, Volker Armin
> >>
> >> Hemmann<volkerarmin@googlemail.com> wrote:
> >> > Hi,
> >> >
> >> > I have an amd64 system with 8GB ram. Of these only 3.1GB are currently
> >> > covered with mtrr:
> >> > cat /proc/mtrr
> >> > reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> >> > reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
> >> > reg02: base=0x0c0000000 ( 3072MB), size=  128MB, count=1: write-back
> >> >
> >> > This is with a Phenom II X4. Mobo is an Asrock A770Crossfire with AMD
> >> > 770 chipset. Ram is 1066 ddr2 running at 800.
> >> >
> >> > Before that I had a X2 6000 where I had one more mtrr, covering
> >> > additional 256mb with 6gb ram total.
> >> >
> >> > When I use the opensource driver, I get a 'mtrr disabled' message when
> >> > X starts, nothing like that with fglrx. The results are the same.
> >> >
> >> > Is there anything that I can do about it? I already played with mtrr
> >> > cleanup options - without any results.
> >> >
> >> > Except for reiser4 the kernel is 'vanilla', config is attached, dmesg
> >> > and lspci are folloiwing:
> >> >
> >> > dmesg:
> >> > [    0.000000] Linux version 2.6.30.5r4 (root@energy) (gcc version
> >> > 4.4.1 (Gentoo 4.4.1 p1.0) ) #1 SMP Tue Aug 18 06:28:18 CEST 2009
> >> > [    0.000000] Command line: root=/dev/md1
> >> > md=3,/dev/sda3,/dev/sdb3,/dev/sdc3 nmi_watchdog=0 mtrr_spare_reg_nr=1
> >> > [    0.000000] KERNEL supported cpus:
> >> > [    0.000000]   Intel GenuineIntel
> >> > [    0.000000]   AMD AuthenticAMD
> >> > [    0.000000] BIOS-provided physical RAM map:
> >> > [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00
> >> > (usable) [    0.000000]  BIOS-e820: 000000000009fc00 -
> >> > 00000000000a0000 (reserved) [    0.000000]  BIOS-e820:
> >> > 00000000000e6000 - 0000000000100000 (reserved) [    0.000000]
> >> >  BIOS-e820: 0000000000100000 - 00000000c7eb0000 (usable) [  
> >> >  0.000000]  BIOS-e820: 00000000c7eb0000 - 00000000c7ec0000 (ACPI data)
> >> > [    0.000000]  BIOS-e820: 00000000c7ec0000 - 00000000c7ef0000 (ACPI
> >> > NVS) [    0.000000]  BIOS-e820: 00000000c7ef0000 - 00000000c7f00000
> >> > (reserved) [    0.000000]  BIOS-e820: 00000000fff00000 -
> >> > 0000000100000000 (reserved) [    0.000000]  BIOS-e820:
> >> > 0000000100000000 - 0000000238000000 (usable) [    0.000000] DMI
> >> > present.
> >> > [    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working
> >> > around it. [    0.000000] e820 update range: 0000000000000000 -
> >> > 0000000000010000 (usable) ==> (reserved)
> >> > [    0.000000] last_pfn = 0x238000 max_arch_pfn = 0x100000000
> >> > [    0.000000] MTRR default type: uncachable
> >> > [    0.000000] MTRR fixed ranges enabled:
> >> > [    0.000000]   00000-9FFFF write-back
> >> > [    0.000000]   A0000-EFFFF uncachable
> >> > [    0.000000]   F0000-FFFFF write-protect
> >> > [    0.000000] MTRR variable ranges enabled:
> >> > [    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
> >> > [    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
> >> > [    0.000000]   2 base 0000C0000000 mask FFFFF8000000 write-back
> >> > [    0.000000]   3 disabled
> >> > [    0.000000]   4 disabled
> >> > [    0.000000]   5 disabled
> >> > [    0.000000]   6 disabled
> >> > [    0.000000]   7 disabled
> >> > [    0.000000] TOM2: 0000000238000000 aka 9088M
> >> > [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
> >> > 0x7010600070106
> >> > [    0.000000] e820 update range: 00000000c8000000 - 0000000100000000
> >> > (usable) ==> (reserved)
> >>
> >> ...
> >>
> >> > 02:00.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3870
> >> > (prog- if 00 [VGA controller])
> >> >        Subsystem: Info-Tek Corp. Device 4070
> >> >        Flags: bus master, fast devsel, latency 0, IRQ 30
> >> >        Memory at d0000000 (64-bit, prefetchable) [size=256M]
> >> >        Memory at fdff0000 (64-bit, non-prefetchable) [size=64K]
> >> >        I/O ports at b000 [size=256]
> >> >        Expansion ROM at fdfc0000 [disabled] [size=128K]
> >> >        Capabilities: [50] Power Management version 3
> >> >        Capabilities: [58] Express Legacy Endpoint, MSI 00
> >> >        Capabilities: [a0] MSI: Mask- 64bit+ Count=1/1 Enable+
> >> >        Capabilities: [100] Vendor Specific Information <?>
> >> >        Kernel driver in use: fglrx_pci
> >> >        Kernel modules: fglrx
> >>
> >> after your start X server, how about cat /proc/mtrr?
> >>
> >> thought there should be one WC entry about 256M... for graphics card.
> >>
> >> YH
> >
> > running X:
> >
> > cat /proc/mtrr
> > reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> > reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
> > reg02: base=0x0c0000000 ( 3072MB), size=  128MB, count=1: write-back
> >
> > back with my X2 6000 and 4 and 6gb ram, I indeed got another mtrr with
> > 256mb. But with the phenom and 8gb I don't get it. Neither with fglrx nor
> > with xorg's radeon driver. Radeon posts a message to dmesg about disabled
> > mtrr.
>
> you should have
> reg03: base=0x0d0000000 ( 3200MB), size=  256MB, count=1: write-combining

back with my X2 6000 I had that.

>
> do you notice any performance degrade without that entry?
>
> YH

when I went from 4gb to 6gb I had a performance degradation. Since the 8gb are 
faster and the new cpu is faster, I don't see degradation. But I wonder how 
much better performance could be with 'correct' mtrr.

Glück Auf
Volker
