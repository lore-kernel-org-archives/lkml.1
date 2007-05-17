Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbXEQMeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbXEQMeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 08:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbXEQMd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 08:33:56 -0400
Received: from dedi.luli.de ([88.198.62.74]:44814 "EHLO dedi.luli.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377AbXEQMdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 08:33:55 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 May 2007 08:33:54 EDT
Message-ID: <464C4A22.7040709@rootdir.de>
Date: Thu, 17 May 2007 14:27:14 +0200
From: Claas Langbehn <claas@rootdir.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: This kernel requires the following features not present on the CPU...
 (on a VIA C7 CPU)
Content-Type: multipart/mixed;
 boundary="------------060004010705010101030409"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060004010705010101030409
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I have got a VIA EPIA EX15000G Mini-ITX mainboard with a C7 VIA Esther 
processor (1500MHz).
There are two options in the BIOS that affect CPU feature flags:

C7 CMPXCHG8 - enable/disable (Disable to install windows NT 4.0) and
C7 No Execute (NX) - enable/disable

I enabled both and compiled a new 2.6.22-rc1-mm1 kernel. So far so good.

The problem is that the system is very unstable and crashes regularly 
(1-3 times a day).
After a crash the bios resets the two processor flags back to disabled. 
But like this
the kernel complains and does not continiue booting:

 > This kernel requires the following features not present on the CPU:
 > 0:8

Each time this happens, I have to go to the BIOS and manually enable 
these flags again.
That is pretty annoying! :(
I attached a cpuinfo.txt. When the two flags are disabled, cx8 and nx 
are not listed there.


Now my question is:

Would it be possible to override the BIOS settings of cx8 and nx and 
activate it with linux anyway?
The CPU supports it and I don't see any reason to disable it.


I already wrote several emails to VIA months ago saying that this is 
probably a bug in their BIOS, but they
are neitherreleasing a new BIOS nor reacting in any way. Their so called 
support website viaarena.com
is not helping neither. Since VIA is not helping at all, the only 
soulution I see would be to override the
BIOS'es decision.

Concerning the crashes I already changed the memory module, but with no 
success. I'm not sure
wether this is a hardware or software bug.


Many regards,
claas

--------------060004010705010101030409
Content-Type: text/plain;
 name="cpuinfo.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cpuinfo.txt"

processor	: 0
vendor_id	: CentaurHauls
cpu family	: 6
model		: 10
model name	: VIA Esther processor 1500MHz
stepping	: 9
cpu MHz		: 799.952
cache size	: 128 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge cmov pat clflush acpi mmx fxsr sse sse2 nx pni est rng rng_en ace ace_en ace2 ace2_en phe phe_en pmm pmm_en
bogomips	: 1601.30
clflush size	: 64


--------------060004010705010101030409
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

000000 (gap: 3bf00000:a4100000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 243571
Kernel command line: root=/dev/sda3 ro quiet 
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1499.916 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 969928k/981952k available (1931k kernel code, 11472k reserved, 659k data, 192k init, 64448k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc038a000 - 0xc03ba000   ( 192 kB)
      .data : 0xc02e2c3b - 0xc03879d4   ( 659 kB)
      .text : 0xc0100000 - 0xc02e2c3b   (1931 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3002.19 BogoMIPS (lpj=5001917)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 87c9bbff 00100000 00000000 00000000 00000081 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 128K (64 bytes/line)
CPU: After all inits, caps: 07c9bbff 00100000 00000000 00000000 00000081 00003fcc 00000000
Compat vDSO mapped to ffffe000.
CPU: Centaur VIA Esther processor 1500MHz stepping 09
Checking 'hlt' instruction... OK.

--------------060004010705010101030409--
