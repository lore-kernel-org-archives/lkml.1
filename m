Return-Path: <linux-kernel-owner+w=401wt.eu-S1751188AbXAaADS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188AbXAaADS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 19:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbXAaADS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 19:03:18 -0500
Received: from tirith.ics.muni.cz ([147.251.4.36]:58007 "EHLO
	tirith.ics.muni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbXAaADR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 19:03:17 -0500
X-Greylist: delayed 2817 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jan 2007 19:03:17 EST
Date: Wed, 31 Jan 2007 00:16:17 +0100
From: Jan Kasprzak <kas@fi.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: No mptable found (Tyan h1000E)
Message-ID: <20070130231617.GP29697@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-Muni-Spam-TestIP: 147.251.48.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello,

	I have a Tyan h1000E (S3970) dual-socket board, with two
dual-core AMD Athlon 2210 CPUs (4 cores total). The problem is
that the kernel apparently cannot detect the SMP configuration
(after boot, /proc/cpuinfo lists only one processor).
The full dmesg output is available at

http://www.fi.muni.cz/~kas/tmp/dmesg-h1000E.txt

The most interesting parts of it are probably these (with my comments
inline marked by "---"):

[...]
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
--- So the kernel can see all four APICs.
[...]
Bootmem setup node 0 0000000000000000-00000000bfff0000
No mptable found.
--- the above does not depend on MPS 1.1 or 1.4 settings in the BIOS
[...]
Kernel command line: ro root=/dev/md0 console=ttyS0,38400n8
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
CPU 0: aperture @ e8000000 size 128 MB
CPU 1: aperture @ e8000000 size 128 MB
--- the kernel knows something about CPU1 (presumably the second core of CPU0).
[...]
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
Freeing SMP alternatives: 32k freed
ACPI: Core revision 20060707
ACPI: setting ELCR to 0200 (from 0e20)
weird, boot CPU (#0) not listed by the BIOS.
SMP motherboard not detected.
Using local APIC timer interrupts.
result 12469270
Detected 12.469 MHz APIC timer.
testing NMI watchdog ... OK.
SMP disabled
--- hmm, no SMP configuration detected after all.
Brought up 1 CPUs
testing NMI watchdog ... OK.
                      ^^^ here it waits for few seconds before printing "OK."

	I have tested it with vanilla 2.6.19.2, 2.6.20-rc6, and
the latest Fedora kernel (2.6.19-1.2895.fc6). I have the latest BIOS
available for this board, and the BIOS can see all four cores.

	How can I make all four cores visible by the Linux kernel?
Thanks,

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
> I will never go to meetings again because I think  face to face meetings <
> are the biggest waste of time you can ever have.        --Linus Torvalds <
