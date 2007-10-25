Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbXJYVqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbXJYVqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbXJYVqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:46:01 -0400
Received: from ortiz.unizar.es ([155.210.1.50]:49133 "EHLO ortiz.unizar.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbXJYVqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:46:00 -0400
X-Greylist: delayed 2212 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2007 17:46:00 EDT
Date: Thu, 25 Oct 2007 23:09:04 +0200
From: "J.A. Magallon" <magallon@unizar.es>
To: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Opteron box and 4Gb memory
Message-ID: <20071025230904.03d5f46a@werewolf>
Organization: GIGA
X-Mailer: Claws Mail 3.0.2cvs98 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Mail-Scanned: Criba 2.0 + Clamd & Bogofilter
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

I have some Quad-Opteron boxes with 4Gb memory and two of them are
running two different Linux distros.

Box one sees 4Gb of memory, but box two just sees 3.
Their mtrr setups are different:

one:
[    0.000000] Linux version 2.6.20...
...
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000b7fd0000 (usable)
[    0.000000]  BIOS-e820: 00000000b7fd0000 - 00000000b7fde000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000b7fde000 - 00000000b8000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000145000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 753616) 1 entries of 3200 used
[    0.000000] Entering add_active_range(0, 1048576, 1331200) 2 entries of 3200 
used
[    0.000000] end_pfn_map = 1331200

cat /proc/mtrr:
reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
reg01: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
reg02: base=0x140000000 (5120MB), size=  64MB: write-back, count=1
reg03: base=0x144000000 (5184MB), size=  16MB: write-back, count=1
reg04: base=0xb8000000 (2944MB), size= 128MB: uncachable, count=1
reg05: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1

two:
Linux version 2.6.22.9...
...
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000b8fd0000 (usable)
 BIOS-e820: 00000000b8fd0000 - 00000000b8fde000 (ACPI data)
 BIOS-e820: 00000000b8fde000 - 00000000b9000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 757712) 1 entries of 3200 used
end_pfn_map = 1048576

cicely:~# cat /proc/mtrr
reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size= 512MB: write-back, count=1
reg02: base=0xa0000000 (2560MB), size= 256MB: write-back, count=1
reg03: base=0xb0000000 (2816MB), size= 128MB: write-back, count=1
reg04: base=0xb8000000 (2944MB), size=  16MB: write-back, count=1


Why ? Is it a bios setup problem ? A kernel problem ?
grep HIGHMEN in configs for both kernels does not give anything, so
I still understand less this thing...

-- 
J.A. Magallon <magallon()unizar!es>     \               Software is like sex:
                                         \         It's better when it's free
MacOS X 10.4.8 Tiger - Darwin Kernel Version 8.8.0 PPC

