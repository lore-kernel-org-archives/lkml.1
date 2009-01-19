Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbZASOFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbZASOFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbZASOEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:04:54 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:44124 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZASOEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:04:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cQ1K28IhLYJtyAzNnpwPK+vLQobywMlbpD0QvIK6L2hEy+kfMeecg8zict6DpwRaH1
         73MZUdgCC7Ja1SQ/NsQ1v/Ce6HjXdAQKfiR5/eUd89yRHiqXjLOdva9OIEZpTUK6mGUX
         sVtx30bPS5I3T4R+qEiOVcGKwEYSiQ6zHiSik=
MIME-Version: 1.0
Date: Mon, 19 Jan 2009 06:04:48 -0800
Message-ID: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com>
Subject: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due to 
	dc1e35c
From: Avuton Olrich <avuton@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

My computer fails to make it past 'Unpacking kernel' with anything
later than dc1e35, to at least v2.6.29-rc2 due to dc1e35c, at least so
git bisect told me. While writing this bug I discovered I was using
gcc-4.1.1 when I thought I was using gcc-4.3.2; I upgraded, recompiled
2.6.28.1 and same results so I assume the same results would come from
me doing the 4 hour bisect again.

ver_linux:
Linux rocket 2.6.27.12 #2 SMP PREEMPT Mon Jan 19 05:41:54 PST 2009
x86_64 Intel(R) Core(TM)2 Duo CPU E8600 @ 3.33GHz GenuineIntel
GNU/Linux

Gnu C                  4.3.2
Gnu make               3.81
binutils               2.19
util-linux             ./ver_linux: line 23: fdformat: command not found
mount                  support
module-init-tools      found
xfsprogs               2.10.2
Linux C Library        2.9
Dynamic linker (ldd)   2.9
Procps                 3.2.7
Kbd                    1.15
Sh-utils               6.12
Modules Loaded         snd_pcm_oss snd_mixer_oss snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device rtc_cmos nvidia
intel_agp

(util-linux version is 2.14.1)

/proc/version:
Linux version 2.6.27.12 (avuton@rocket) (gcc version 4.3.2 (Gentoo
4.3.2-r2 p1.5, pie-10.1.5) ) #2 SMP PREEMPT Mon Jan 19 05:41:54 PST
2009

/proc/iomem:
00000000-0000ffff : reserved
00010000-0009ebff : System RAM
0009ec00-0009ffff : reserved
000c0000-000cffff : pnp 00:0c
000e4000-000fffff : reserved
00100000-7ff8ffff : System RAM
  00200000-0064d311 : Kernel code
  0064d312-00813c57 : Kernel data
  00878000-009c39cf : Kernel bss
7ff90000-7ff9dfff : ACPI Tables
7ff9e000-7ffdffff : ACPI Non-volatile Storage
7ffe0000-7fffffff : reserved
88000000-880000ff : 0000:00:1f.3
bfe00000-dfdfffff : PCI Bus 0000:01
  c0000000-cfffffff : 0000:01:00.0
dfe00000-dfefffff : PCI Bus 0000:04
e0000000-efffffff : PCI MMCONFIG 0
  e0000000-efffffff : pnp 00:0b
f8800000-fe8fffff : PCI Bus 0000:01
  fa000000-fbffffff : 0000:01:00.0
  fd000000-fdffffff : 0000:01:00.0
    fd000000-fdffffff : nvidia
  fe8e0000-fe8fffff : 0000:01:00.0
fe900000-fe9fffff : PCI Bus 0000:02
  fe9e0000-fe9effff : 0000:02:00.0
  fe9fe000-fe9fffff : 0000:02:00.0
    fe9fe000-fe9fffff : ahci
fea00000-feafffff : PCI Bus 0000:03
  feaa0000-feabffff : 0000:03:00.0
  feac0000-feafffff : 0000:03:00.0
    feac0000-feafffff : atl1
febf8000-febfbfff : 0000:00:1b.0
  febf8000-febfbfff : ICH HD audio
febfe000-febfec00 : pnp 00:07
febff000-febff3ff : 0000:00:1d.7
  febff000-febff3ff : ehci_hcd
febff400-febff7ff : 0000:00:1a.7
  febff400-febff7ff : ehci_hcd
febff800-febfffff : 0000:00:1f.2
  febff800-febfffff : ahci
fec00000-fec00fff : IOAPIC 0
  fec00000-fec00fff : pnp 00:09
fed00000-fed003ff : HPET 0
fed14000-fed19fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:07
fed20000-fed3ffff : pnp 00:07
fed45000-fed89fff : pnp 00:07
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ffb00000-ffffffff : reserved
100000000-17fffffff : System RAM

/proc/ioports:
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0290-0297 : pnp 00:06
03c0-03df : vga+
0400-041f : 0000:00:1f.3
  0400-041f : i801_smbus
0480-04bf : 0000:00:1f.0
  0480-04bf : pnp 00:07
04d0-04d1 : pnp 00:07
0800-087f : 0000:00:1f.0
  0800-087f : pnp 00:07
    0800-0803 : ACPI PM1a_EVT_BLK
    0804-0805 : ACPI PM1a_CNT_BLK
    0808-080b : ACPI PM_TMR
    0810-0815 : ACPI CPU throttle
    0828-082f : ACPI GPE0_BLK
    0860-087f : iTCO_wdt
0cf8-0cff : PCI conf1
a000-afff : PCI Bus 0000:01
  ac00-ac7f : 0000:01:00.0
b000-bfff : PCI Bus 0000:02
  b400-b40f : 0000:02:00.1
    b400-b40f : pata_jmicron
  b480-b483 : 0000:02:00.1
    b480-b483 : pata_jmicron
  b800-b807 : 0000:02:00.1
    b800-b807 : pata_jmicron
  b880-b883 : 0000:02:00.1
    b880-b883 : pata_jmicron
  bc00-bc07 : 0000:02:00.1
    bc00-bc07 : pata_jmicron
c000-cfff : PCI Bus 0000:05
  c880-c89f : 0000:05:02.0
    c880-c89f : EMU10K1
  cc00-cc07 : 0000:05:02.1
d800-d81f : 0000:00:1d.0
  d800-d81f : uhci_hcd
d880-d89f : 0000:00:1d.1
  d880-d89f : uhci_hcd
dc00-dc1f : 0000:00:1d.2
  dc00-dc1f : uhci_hcd
e000-e01f : 0000:00:1a.0
  e000-e01f : uhci_hcd
e080-e09f : 0000:00:1a.1
  e080-e09f : uhci_hcd
e400-e41f : 0000:00:1f.2
  e400-e41f : ahci
e480-e483 : 0000:00:1f.2
  e480-e483 : ahci
e800-e807 : 0000:00:1f.2
  e800-e807 : ahci
e880-e883 : 0000:00:1f.2
  e880-e883 : ahci
ec00-ec07 : 0000:00:1f.2
  ec00-ec07 : ahci

/proc/cpuinfo:
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Duo CPU     E8600  @ 3.33GHz
stepping	: 10
cpu MHz		: 1998.000
cache size	: 6144 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
lm constant_tsc pebs bts rep_good nopl pni monitor ds_cpl vmx smx est
tm2 ssse3 cx16 xtpr sse4_1 lahf_lm
bogomips	: 6655.98
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Duo CPU     E8600  @ 3.33GHz
stepping	: 10
cpu MHz		: 1998.000
cache size	: 6144 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
lm constant_tsc pebs bts rep_good nopl pni monitor ds_cpl vmx smx est
tm2 ssse3 cx16 xtpr sse4_1 lahf_lm
bogomips	: 6655.71
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

bisected to:
commit dc1e35c6e95e8923cf1d3510438b63c600fee1e2
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Tue Jul 29 10:29:19 2008 -0700

    x86, xsave: enable xsave/xrstor on cpus with xsave support

    Enables xsave/xrstor by turning on cr4.osxsave on cpu's which have
    the xsave support. For now, features that OS supports/enabled are
    FP and SSE.

    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

http://avuton.googlepages.com/lspci-vvv
http://avuton.googlepages.com/config-2.6.28
-- 
avuton
--
|  (\_/)  This is Bunny. Copy and paste Bunny
| (='.'=) into your signature to help him gain
| (")_(") world domination.
