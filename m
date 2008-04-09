Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbYDIHyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbYDIHyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 03:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYDIHyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 03:54:05 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:23725 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbYDIHyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 03:54:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Boqd0Tuqd5HvAAgJrsipug4/UKEPvbCNjDrzx2suxR45o6gA4E5B634EKrRSRQnOEwswIhcWLnKFe6q8z8feFDj02NE+N1fs4C3QYUAps9Ehb2Aup9z6HsxxQZ9cUq4yYj/0fwCM8Dm4tDBNPPLT8a4yDQbI+xDeh0qorPStU74=
Message-ID: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com>
Date: Wed, 9 Apr 2008 15:54:01 +0800
From: "Zhao Forrest" <forrest.zhao@gmail.com>
To: discuss@x86-64.org, linux-kernel@vger.kernel.org
Subject: Does Linux have plan to support memory hole remapping?
Cc: yhlu.kernel@gmail.com, mingo@elte.hu, ak@suse.de
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi experts,

I ask this because I run kernel 2.6.25-rc8 on a x64 system with 32GB
physical memory, and kernel only use (32GB-512MB) physical memory. See
below related information:
E820 table:
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 0000000000098c00 (usable)
 BIOS-e820: 0000000000098c00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dffa0000 (usable)
 BIOS-e820: 00000000dffae000 - 00000000dffb0000 type 9
 BIOS-e820: 00000000dffb0000 - 00000000dffbe000 (ACPI data)
 BIOS-e820: 00000000dffbe000 - 00000000dfff0000 (ACPI NVS)
 BIOS-e820: 00000000dfff0000 - 00000000dfffe000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000820000000 (usable)

/proc/mtrr:
reg00: base=0x00000000 (   0MB), size=32768MB: write-back, count=1
reg01: base=0x800000000 (32768MB), size= 512MB: write-back, count=1
reg02: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1

/proc/meminfo:
MemTotal:     33010240 kB
MemFree:      32715924 kB
Buffers:          1624 kB
Cached:          31412 kB
SwapCached:          0 kB
Active:          22348 kB
Inactive:        19728 kB
SwapTotal:           0 kB
SwapFree:            0 kB
Dirty:               0 kB
Writeback:           0 kB
AnonPages:        9120 kB
Mapped:           6408 kB
Slab:            24828 kB
SReclaimable:     8004 kB
SUnreclaim:      16824 kB
PageTables:       1296 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:  16505120 kB
Committed_AS:    16556 kB
VmallocTotal: 34359738367 kB
VmallocUsed:     73524 kB
VmallocChunk: 34359664507 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:     2048 kB

As we can see from above information that the physical memory in system
is 32768MB(32GB). However OS is only using about
(32768-512)MB(MemTotal:     33010240 kB). Does this mean that this
linux kernel can't use the physical memory remapped
from (4G-512M, 4G) to (32G, 32G+512M)?

Thanks,
Forrest
