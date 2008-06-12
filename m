Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYFLPOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYFLPOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 11:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYFLPOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 11:14:10 -0400
Received: from samson.dc.ltu.se ([130.240.112.30]:48543 "EHLO
	samson.dc.luth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbYFLPOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 11:14:09 -0400
X-Greylist: delayed 1365 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jun 2008 11:14:08 EDT
Message-ID: <485137E8.4020606@ltu.se>
Date: Thu, 12 Jun 2008 16:51:20 +0200
From: =?ISO-8859-1?Q?Staffan_H=E4m=E4l=E4?= <sh@ltu.se>
User-Agent: Thunderbird 1.5.0.12 (X11/20070718)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Problems with the oom-killer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have had a lot of problems with the oom-killer during times of lots of disk
activity. We have two identical machines running TSM (tivoli storage manager),
running on Redhat Enterprise 4. The kernel is 2.6.9 (2.6.9-42.0.10.ELsmp).

The machines both have a lot of disk connected through HBA interfaces. Maybe
the disk buffers grow out of proportion. The file systems are formatted with ext3.

It always seems to happen when there is a lot of disk activity. Either during
automatic maintenance tasks, or when I have manually started jobs that access
the disk a lot (e.g. formatting disk files for TSM).

When this happens, there always seems to be lots of free memory, and the swap
is unused.

I have tried logging the memory usage, but can see no significant change during
the times when the oom-killer has surfaced. It happens very irregularly.

A few weeks ago, however, it happened several times the same day, at a time when
we had some disk problems.

I have read all I can about this problem, and have tried setting the vm.overcommit_memory
setting to 2, but it doesn't seem to have helped.

The settings right now:
vm.overcommit_ratio = 50
vm.overcommit_memory = 2

free usually reports figures like this:

# free -m
              total       used       free     shared    buffers     cached
Mem:          4050       4009         40          0        220       3008
-/+ buffers/cache:        780       3269
Swap:        10236         11      10225


The lines from /var/log/messages:
(very similar each time this happens. dsmserv gets killed each time).

Jun 12 07:07:10 papyrus kernel: oom-killer: gfp_mask=0xd0
Jun 12 07:07:10 papyrus kernel: Mem-info:
Jun 12 07:07:10 papyrus kernel: DMA per-cpu:
Jun 12 07:07:10 papyrus kernel: cpu 0 hot: low 2, high 6, batch 1
Jun 12 07:07:10 papyrus kernel: cpu 0 cold: low 0, high 2, batch 1
Jun 12 07:07:10 papyrus kernel: cpu 1 hot: low 2, high 6, batch 1
Jun 12 07:07:10 papyrus kernel: cpu 1 cold: low 0, high 2, batch 1
Jun 12 07:07:10 papyrus kernel: cpu 2 hot: low 2, high 6, batch 1
Jun 12 07:07:10 papyrus kernel: cpu 2 cold: low 0, high 2, batch 1
Jun 12 07:07:10 papyrus kernel: cpu 3 hot: low 2, high 6, batch 1
Jun 12 07:07:10 papyrus kernel: cpu 3 cold: low 0, high 2, batch 1
Jun 12 07:07:10 papyrus kernel: Normal per-cpu:
Jun 12 07:07:10 papyrus kernel: cpu 0 hot: low 32, high 96, batch 16
Jun 12 07:07:12 papyrus kernel: cpu 0 cold: low 0, high 32, batch 16
Jun 12 07:07:12 papyrus kernel: cpu 1 hot: low 32, high 96, batch 16
Jun 12 07:07:12 papyrus kernel: cpu 1 cold: low 0, high 32, batch 16
Jun 12 07:07:12 papyrus kernel: cpu 2 hot: low 32, high 96, batch 16
Jun 12 07:07:12 papyrus kernel: cpu 2 cold: low 0, high 32, batch 16
Jun 12 07:07:12 papyrus kernel: cpu 3 hot: low 32, high 96, batch 16
Jun 12 07:07:12 papyrus kernel: cpu 3 cold: low 0, high 32, batch 16
Jun 12 07:07:12 papyrus kernel: HighMem per-cpu:
Jun 12 07:07:12 papyrus kernel: cpu 0 hot: low 32, high 96, batch 16
Jun 12 07:07:12 papyrus kernel: cpu 0 cold: low 0, high 32, batch 16
Jun 12 07:07:12 papyrus kernel: cpu 1 hot: low 32, high 96, batch 16
Jun 12 07:07:12 papyrus kernel: cpu 1 cold: low 0, high 32, batch 16
Jun 12 07:07:12 papyrus kernel: cpu 2 hot: low 32, high 96, batch 16
Jun 12 07:07:12 papyrus kernel: cpu 2 cold: low 0, high 32, batch 16
Jun 12 07:07:12 papyrus kernel: cpu 3 hot: low 32, high 96, batch 16
Jun 12 07:07:12 papyrus kernel: cpu 3 cold: low 0, high 32, batch 16
Jun 12 07:07:12 papyrus kernel:
Jun 12 07:07:12 papyrus kernel: Free pages:       15104kB (1664kB HighMem)
Jun 12 07:07:12 papyrus kernel: Active:195212 inactive:800523 dirty:291150 writeback:43473 unstable:0 free:3776 slab:30090 mapped:189285 pagetables:888
Jun 12 07:07:12 papyrus kernel: DMA free:12520kB min:16kB low:32kB high:48kB active:0kB inactive:0kB present:16384kB pages_scanned:401 all_unreclaimable? yes
Jun 12 07:07:12 papyrus kernel: protections[]: 0 0 0
Jun 12 07:07:12 papyrus kernel: Normal free:920kB min:928kB low:1856kB high:2784kB active:9812kB inactive:713164kB present:901120kB pages_scanned:816915 all_unreclaimable? yes
Jun 12 07:07:13 papyrus kernel: protections[]: 0 0 0
Jun 12 07:07:13 papyrus kernel: HighMem free:1664kB min:512kB low:1024kB high:1536kB active:771036kB inactive:2488928kB present:4325376kB pages_scanned:0 all_unreclaimable? no
Jun 12 07:07:13 papyrus kernel: protections[]: 0 0 0
Jun 12 07:07:13 papyrus kernel: DMA: 2*4kB 2*8kB 1*16kB 2*32kB 2*64kB 2*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 2*4096kB = 12520kB
Jun 12 07:07:13 papyrus kernel: Normal: 62*4kB 26*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 920kB
Jun 12 07:07:13 papyrus kernel: HighMem: 2*4kB 1*8kB 1*16kB 1*32kB 5*64kB 6*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1664kB
Jun 12 07:07:13 papyrus kernel: Swap cache: add 13134, delete 11406, find 19575/20970, race 0+0
Jun 12 07:07:13 papyrus kernel: 0 bounce buffer pages
Jun 12 07:07:13 papyrus kernel: Free swap:       10467444kB
Jun 12 07:07:13 papyrus kernel: 1310720 pages of RAM
Jun 12 07:07:13 papyrus kernel: 819147 pages of HIGHMEM
Jun 12 07:07:13 papyrus kernel: 273918 reserved pages
Jun 12 07:07:13 papyrus kernel: 821382 pages shared
Jun 12 07:07:13 papyrus kernel: 1728 pages swap cached
Jun 12 07:07:13 papyrus kernel: Out of Memory: Killed process 20524 (dsmserv).

I hope anyone has a clue about this.

Thanks
Staffan Hamala

