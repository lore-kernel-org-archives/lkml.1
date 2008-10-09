Return-Path: <linux-kernel-owner+w=401wt.eu-S1758969AbYJIQVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969AbYJIQVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 12:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbYJIQVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 12:21:19 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3098 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbYJIQVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:21:19 -0400
Date: Thu, 9 Oct 2008 18:21:17 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.25 Power5 64bit] Unable to handle kernel paging request for
	data: something to do with /sys
Message-ID: <20081009162116.GF28224@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Fri Oct 10 14:44:58 CEST 2008
X-Message-Flag: PGP key-id: 0x1f28d8ae - consider encrypting your e-mail to
	me with PGP!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While running my rmmod/modprobe script (an improved one that forks
itself a couple of times) I did twice the following:
	find /sys/ -type f | xargs cat > /dev/null
The second time it hang and I got an oops:
[ 5838.193438] Unable to handle kernel paging request for data at address 0xd00000000002b498
[ 5838.193456] Faulting instruction address: 0xc000000000033360
[ 5838.193468] Oops: Kernel access of bad area, sig: 11 [#2]
[ 5838.193477] SMP NR_CPUS=32 NUMA pSeries
[ 5838.193487] Modules linked in: ibmveth windfarm_cpufreq_clamp(+) ipv6 ext3 jbd mbcache sd_mod ibmvscsic scsi_transport_srp scsi_tgt scsi_mod windfarm_smu_sat windfarm_core [last unloaded: windfarm_pid]
[ 5838.193538] NIP: c000000000033360 LR: c000000000172678 CTR: c00000000011e32c
[ 5838.193552] REGS: c000000044ca79a0 TRAP: 0300   Tainted: G      D    (2.6.27-rc6-powerpc64)
[ 5838.193563] MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 28004488  XER: 20000012
[ 5838.193588] DAR: d00000000002b498, DSISR: 0000000040000000
[ 5838.193598] TASK = c000000046335380[4877] 'find' THREAD: c000000044ca4000 CPU: 3
[ 5838.193610] GPR00: c0000000001726c0 c000000044ca7c20 c000000000638f50 d00000000002b498 
[ 5838.193630] GPR04: d00000000002b497 0000000000000005 0000000000000005 00000000000008be 
[ 5838.193650] GPR08: 0000000000000004 000000001003ba78 0000000000000000 0000000000000000 
[ 5838.193669] GPR12: 000000000000f032 c000000000663a00 0000000000000001 0000000000000003 
[ 5838.193689] GPR16: 000000000000000b 0000000000000000 0000000000000000 0000000000000004 
[ 5838.193708] GPR20: 000000001003d5a0 0000000000000000 0000000000000000 000000001003b998 
[ 5838.193728] GPR24: 0000000000000016 c000000044ca7de0 c000000044ca7de0 c0000000005fc780 
[ 5838.193747] GPR28: c00000004322d180 d00000000002b498 c0000000005d3bb0 c000000044ff2dc0 
[ 5838.193776] NIP [c000000000033360] .strlen+0x4/0x18
[ 5838.193789] LR [c000000000172678] .sysfs_readdir+0x150/0x200
[ 5838.193798] Call Trace:
[ 5838.193808] [c000000044ca7c20] [c0000000001726c0] .sysfs_readdir+0x198/0x200 (unreliable)
[ 5838.193826] [c000000044ca7cc0] [c00000000011e63c] .vfs_readdir+0xbc/0x118
[ 5838.193840] [c000000044ca7d70] [c00000000011e9b8] .sys_getdents64+0x84/0x104
[ 5838.193855] [c000000044ca7e30] [c0000000000086b4] syscall_exit+0x0/0x40
[ 5838.193867] Instruction dump:
[ 5838.193874] 4d820020 7ca903a6 38a3ffff 3884ffff 8c650001 2c830000 8c040001 7c601851 
[ 5838.193898] 4d860020 4102ffec 4e800020 3883ffff <8c040001> 2c000000 4082fff8 7c632050 
[ 5838.223292] ---[ end trace ac51cd380c187147 ]---


Folkert van Heusden

-- 
MultiTail is a versatile tool for watching logfiles and output of
commands. Filtering, coloring, merging, diff-view, etc.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
