Return-Path: <linux-kernel-owner+w=401wt.eu-S1759527AbYJIOJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbYJIOJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 10:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbYJIOJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 10:09:37 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3632 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905AbYJIOJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 10:09:36 -0400
Date: Thu, 9 Oct 2008 16:09:34 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.25 on Power5 64bit] badness in fs/sysfs/dir.c:424
Message-ID: <20081009140933.GC28224@vanheusden.com>
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

While running my modprobe-killerscript I got the following in dmesg:

[1472698.427389] sysfs: duplicate filename 'cpufreq-clamp' can not be created
[1472698.427422] ------------[ cut here ]------------
[1472698.427434] Badness at fs/sysfs/dir.c:424
[1472698.427446] NIP: c00000000014ce60 LR: c00000000014ce5c CTR: 80000000001c5840
[1472698.427463] REGS: c0000000fccaf6f0 TRAP: 0700   Not tainted  (2.6.25-2-powerpc64)
[1472698.427474] MSR: 8000000000029032 <EE,ME,IR,DR>  CR: 22022424  XER: 00000001
[1472698.427518] TASK = c0000000fcf4ccd0[8434] 'modprobe' THREAD: c0000000fccac000 CPU: 3
[1472698.427531] GPR00: c00000000014ce5c c0000000fccaf970 c000000000549a30 0000000000000051 
[1472698.427551] GPR04: 0000000000000000 0000000000000000 0000000000000000 c0000000fbc52c50 
[1472698.427569] GPR08: 0000000000000002 c0000000004b0190 c0000000fcafbb58 c0000000004b0180 
[1472698.427588] GPR12: 0000000000004000 c0000000004a2a80 d00000000003e340 0000000000000000 
[1472698.427609] GPR16: d00000000003e300 0000000000000009 000000000000003a d00000000002c728 
[1472698.427629] GPR20: d00000000003db04 000000000000003a 0000000000000000 d00000000003c000 
[1472698.427650] GPR24: 000000000000001e d00000000003dc00 000000000000001f c0000000fccafa70 
[1472698.427670] GPR28: fffffffffffffff4 c0000000fccafa70 c0000000004ee510 c0000000fc6c4410 
[1472698.427711] NIP [c00000000014ce60] .sysfs_add_one+0x4c/0xe0
[1472698.427731] LR [c00000000014ce5c] .sysfs_add_one+0x48/0xe0
[1472698.427747] Call Trace:
[1472698.427792] [c0000000fccaf970] [c00000000014ce5c] .sysfs_add_one+0x48/0xe0 (unreliable)
[1472698.427821] [c0000000fccafa00] [c00000000014c67c] .sysfs_add_file+0x6c/0xd8
[1472698.427850] [c0000000fccafac0] [c000000000271f88] .device_create_file+0x20/0x3c
[1472698.427877] [c0000000fccafb40] [d000000000035b00] .wf_register_control+0xe8/0x148 [windfarm_core]
[1472698.427911] [c0000000fccafbd0] [d00000000002c1e4] .wf_cpufreq_clamp_init+0x9c/0x298 [windfarm_cpufreq_clamp]
[1472698.427943] [c0000000fccafc50] [c0000000000899ec] .sys_init_module+0x1960/0x1b38
[1472698.427974] [c0000000fccafe30] [c00000000000872c] syscall_exit+0x0/0x40
[1472698.427996] Instruction dump:
[1472698.428009] f821ff71 7c9f2378 60000000 e8630000 e8840018 4bffff6d 2fa30000 419e0020 
[1472698.428035] e87e8018 e89f0018 4bf0e479 60000000 <0fe00000> 3860ffef 48000070 e97d0000 
[1472698.428063] windfarm: device_create_file failed for cpufreq-clamp

This is in an LPAR on an IBM Power5, 8 virtual processors (4 physical - don't ask :-]),
4GB of RAM, everything virtual (e.g. disks, network).


Folkert van Heusden

-- 
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
