Return-Path: <linux-kernel-owner+w=401wt.eu-S1760735AbYD3BZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735AbYD3BZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 21:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbYD3BZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 21:25:42 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:50104 "EHLO
	kirsi2.rokki.sonera.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756851AbYD3BZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 21:25:41 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2008 21:25:40 EDT
Date: Wed, 30 Apr 2008 04:19:54 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.24.4+mmap with overcommit >= 1
Message-ID: <20080430011953.c5ftilonkabvwmkp@m.safari.iki.fi>
Mail-Followup-To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mamsifdlputobfy4"
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2008-03-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mamsifdlputobfy4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I have arch x86_64, glibc-2.7.90-7 from Fedora.
When I have vm.overcommit_memory == 1 or 2,
mmap succeeds for really huge values.
These ranges succeed (approximate):
 8793870000000 - 17500387000000
26390387000000 - 35180387000000

with overcommit_memory=0 it behaves predictably.

03:49:57.378780 write(2, "trying 27386666640000 bytes...", 30trying 27386666640000 bytes...) = 30 <0.000014>
03:49:57.378914 mmap(NULL, 27386666643456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2ada07c88000 <0.000013>
03:49:57.378976 write(2, " got 0x2ada07c88010\n", 20 got 0x2ada07c88010
) = 20 <0.000014>
03:49:57.804125 --- SIGINT (Interrupt) @ 0 (0) ---

but with ten times smaller value:
03:49:40.051589 write(2, "trying 2738666664000 bytes...", 29trying 2738666664000 bytes...) = 29 <0.000014>
03:49:40.051722 mmap(NULL, 2738666668032, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = -1 ENOMEM (Cannot allocate memory) <0.000012>
03:49:40.051783 brk(0)                  = 0x1362000 <0.000011>
03:49:40.051830 brk(0x27da6792000)      = 0x1362000 <0.000012>
03:49:40.051881 mmap(NULL, 2738666799104, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = -1 ENOMEM (Cannot allocate memory) <0.000013>
03:49:40.051942 mmap(NULL, 134217728, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0) = 0x3053f4e47000 <0.000013>
03:49:40.051993 munmap(0x3053f4e47000, 52137984) = 0 <0.000016>
03:49:40.052045 munmap(0x3053fc000000, 14970880) = 0 <0.000015>
03:49:40.052095 mprotect(0x3053f8000000, 135168, PROT_READ|PROT_WRITE) = 0 <0.000014>
03:49:40.052161 mmap(NULL, 2738666668032, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = -1 ENOMEM (Cannot allocate memory) <0.000013>
03:49:40.052220 write(2, " got (nil)\n", 11 got (nil)

MemTotal:      3062112 kB
MemFree:         93900 kB
Buffers:             0 kB
Cached:         104652 kB
SwapCached:     176576 kB
Active:        1504444 kB
Inactive:       434308 kB
SwapTotal:     3911784 kB
SwapFree:      2947756 kB
Dirty:             288 kB
Writeback:           0 kB
AnonPages:     1815468 kB
Mapped:          92448 kB
Slab:           836956 kB
SReclaimable:   647004 kB
SUnreclaim:     189952 kB
PageTables:      24096 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   5442840 kB
Committed_AS: 18446744066096782940 kB
VmallocTotal: 34359738367 kB
VmallocUsed:     11940 kB
VmallocChunk: 34359725791 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:     2048 kB

[2622805.705953] wmweather+[6197]: segfault at 28 rip 555555565713 rsp 7fff2ba47e10 error 4
[2622883.492774] SysRq : Show Memory
[2622883.492784] Mem-info:
[2622883.492786] DMA per-cpu:
[2622883.492790] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[2622883.492793] CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[2622883.492795] DMA32 per-cpu:
[2622883.492797] CPU    0: Hot: hi:  186, btch:  31 usd:  84   Cold: hi:   62, btch:  15 usd:  55
[2622883.492800] CPU    1: Hot: hi:  186, btch:  31 usd: 147   Cold: hi:   62, btch:  15 usd:  56
[2622883.492804] Active:373468 inactive:144663 dirty:0 writeback:28854 unstable:0
[2622883.492806]  free:4600 slab:194244 mapped:12220 pagetables:6339 bounce:0
[2622883.492809] DMA free:8804kB min:16kB low:20kB high:24kB active:0kB inactive:0kB present:8308kB pages_scanned:0 all_unreclaimable? yes
[2622883.492812] lowmem_reserve[]: 0 2988 2988 2988
[2622883.492818] DMA32 free:9596kB min:6984kB low:8728kB high:10476kB active:1493872kB inactive:578652kB present:3060476kB pages_scanned:548 all_unreclaimable? no
[2622883.492821] lowmem_reserve[]: 0 0 0 0
[2622883.492825] DMA: 5*4kB 4*8kB 3*16kB 2*32kB 3*64kB 2*128kB 2*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 8804kB
[2622883.492835] DMA32: 868*4kB 37*8kB 6*16kB 10*32kB 5*64kB 2*128kB 1*256kB 1*512kB 2*1024kB 1*2048kB 0*4096kB = 9624kB
[2622883.492846] Swap cache: add 1758503, delete 1699227, find 18628028/18793383, race 0+120
[2622883.492848] Free swap  = 2530928kB
[2622883.492850] Total swap = 3911784kB
[2622883.492851] Free swap:       2530928kB
[2622883.504163] 780032 pages of RAM
[2622883.504165] 14505 reserved pages
[2622883.504167] 92561 pages shared
[2622883.504168] 59411 pages swap cached

-- 
Do what you love because life is too short for anything else.


--mamsifdlputobfy4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bigmalloc.c"

#include <stdlib.h>
#include <errno.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
	unsigned long sz;
	void *ptr;
	char *endptr;

	if (argc != 2) {
		fprintf(stderr, "usage: %s bytes\n", argv[0]);
		return 1;
	}
	errno = 0;
	sz = strtoul(argv[1], &endptr, 10);
	if (errno || (argv[1] == endptr)) {
		fprintf(stderr, "invalid value\n");
		return 1;
	}
	fprintf(stderr, "trying %lu bytes... ", sz);
	ptr = malloc(sz);
	fprintf(stderr, "got %p\n", ptr);
	return 0;
}


--mamsifdlputobfy4--
