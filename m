Return-Path: <linux-kernel-owner+w=401wt.eu-S933651AbXGYQnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651AbXGYQnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbXGYQnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:43:31 -0400
Received: from zankt.net ([84.16.234.225]:50468 "EHLO mail.zankt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbXGYQna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:43:30 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jul 2007 12:43:29 EDT
Date: Wed, 25 Jul 2007 18:37:15 +0200
From: D-Tick <mlists@zankt.net>
To: linux-kernel@vger.kernel.org
Cc: nico-kernel-20070725001@schottelius.org
Subject: kernel oops with Linux 2.6.21.5 (mostly on file access)
Message-ID: <20070725163715.GA3500@voltkraft>
Mail-Followup-To: D-Tick <mlists@zankt.net>,
	linux-kernel@vger.kernel.org, nico-kernel-20070725001@schottelius.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Kernel on my homeserver oopses quite often, sometimes the box is running 3 days, sometimes 3months
Today i checked my backups for size and it oopses again... 
The first 2 times were directly after an "du -sh *" the third after listenig 20 minutes to the loacal running mpd, the 4th after starting htop then other oopses, after that i tried to reboot the box, i also attached the oops und the BUG: at drivers/pci/search.c:270 pci_get_subsys()
After that i attached some older oopses.
Maybe u know what these messages would like to tell me...

regards, D-Tick

Setup:
Data-partions: ext3 partition over an lvm2 which lies on an LUKS(cryptsetup) partition which is on top of an software raid5 (mdadm)

root partition: ext3 on an software raid5

kernel is an 2.6.21.5 (but oopses since 2.6.18) without any patches, the
config can be found at http://zankt.net/~d-tick/kernel-2.6.21.5-config
lspci, cmdline, mount at http://zankt.net/~d-tick/voltkraft-sysinfo




Oopses:

[190861.885741] BUG: unable to handle kernel paging request at virtual address 01190024
[190861.978686]  printing eip:
[190862.012138] c0176026
[190862.039274] *pde = 00000000
[190862.073778] Oops: 0000 [#1]
[190862.108250] DEBUG_PAGEALLOC
[190862.142857] Modules linked in: ntfs vfat fat isofs udf
[190862.205945] CPU:    0
[190862.205948] EIP:    0060:[<c0176026>]    Not tainted VLI
[190862.205953] EFLAGS: 00010206   (2.6.21.5_VIA_EPIA_MII_12000 #1)
[190862.370464] EIP is at __d_lookup+0x66/0xf0
[190862.420439] eax: 0000d309   ebx: 01190024   ecx: 42ff6ccb   edx: c0e5da0c
[190862.502644] esi: 01190024   edi: eb49bef4   ebp: eb49bdc4   esp: eb49bd98
[190862.584847] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[190862.655619] Process du (pid: 18106, ti=eb49a000 task=e2b33770 task.ti=eb49a000)
[190862.741975] Stack: c0e5da0c ea407c60 eb49be20 e19f9134 c0121e7b 00000019 42ff6ccb df8a9000 
[190862.843822]        df8a9019 eb49be20 eb49bef4 eb49bdec c016cb34 eb49be2c eb49be20 c1894120 
[190862.945665]        c016cddd df8a9000 df8a9019 eb49be20 eb49bef4 eb49be40 c016e62d eb49bef4 
[190863.047511] Call Trace:
[190863.079939]  [<c01055ba>] show_trace_log_lvl+0x1a/0x30
[190863.142498]  [<c0105679>] show_stack_log_lvl+0xa9/0xd0
[190863.205060]  [<c0105889>] show_registers+0x1e9/0x2f0
[190863.265545]  [<c0105aab>] die+0x11b/0x230
[190863.314596]  [<c01155e6>] do_page_fault+0x2c6/0x5d0
[190863.374040]  [<c0564994>] error_code+0x74/0x80
[190863.428289]  [<c016cb34>] do_lookup+0x24/0x170
[190863.482538]  [<c016e62d>] __link_path_walk+0x6ed/0xb90
[190863.545098]  [<c016eb14>] link_path_walk+0x44/0xc0
[190863.603505]  [<c016ed46>] do_path_lookup+0x76/0x1d0
[190863.662949]  [<c016f728>] __user_walk_fd+0x38/0x50
[190863.721354]  [<c016918e>] vfs_lstat_fd+0x1e/0x50
[190863.777681]  [<c0169201>] vfs_lstat+0x11/0x20
[190863.830889]  [<c0169224>] sys_lstat64+0x14/0x30
[190863.886177]  [<c0104030>] syscall_call+0x7/0xb
[190863.940424]  =======================
[190863.984175] Code: 87 6d c0 d3 ea 31 d0 8b 15 94 87 6d c0 21 d0 8b 15 9c 87 6d c0 8b 34 82 85 f6 75 0f eb 57 8d b4 26 00 00 00 00 85 db 89 de 74 4a <8b> 1e 0f 18 03 90 8d 56 f4 8b 4d ec 89 55 d4 3b 4a 18 75 e6 8b 
[190864.217589] EIP: [<c0176026>] __d_lookup+0x66/0xf0 SS:ESP 0068:eb49bd98
[190993.430258] BUG: unable to handle kernel paging request at virtual address 011a0024
[190993.523079]  printing eip:
[190993.556532] c0176026
[190993.583673] *pde = 00000000
[190993.618173] Oops: 0000 [#2]
[190993.652643] DEBUG_PAGEALLOC
[190993.687250] Modules linked in: ntfs vfat fat isofs udf
[190993.750340] CPU:    0
[190993.750343] EIP:    0060:[<c0176026>]    Not tainted VLI
[190993.750348] EFLAGS: 00010206   (2.6.21.5_VIA_EPIA_MII_12000 #1)
[190993.914860] EIP is at __d_lookup+0x66/0xf0
[190993.964835] eax: 00019758   ebx: 011a0024   ecx: 8a0a7369   edx: c0e5d0d8
[190994.047038] esi: 011a0024   edi: da74fef4   ebp: da74fdc4   esp: da74fd98
[190994.129240] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[190994.200013] Process du (pid: 18156, ti=da74e000 task=e2b32750 task.ti=da74e000)
[190994.286370] Stack: c0e5d0d8 ea407c60 da74fe20 e9a3eb04 c0121e7b 0000001f 8a0a7369 d9215000 
[190994.388216]        d921501f da74fe20 da74fef4 da74fdec c016cb34 da74fe2c da74fe20 c1894120 
[190994.490061]        c016cddd d9215000 d921501f da74fe20 da74fef4 da74fe40 c016e62d da74fef4 
[190994.591906] Call Trace:
[190994.624333]  [<c01055ba>] show_trace_log_lvl+0x1a/0x30
[190994.686892]  [<c0105679>] show_stack_log_lvl+0xa9/0xd0
[190994.749454]  [<c0105889>] show_registers+0x1e9/0x2f0
[190994.809939]  [<c0105aab>] die+0x11b/0x230
[190994.858990]  [<c01155e6>] do_page_fault+0x2c6/0x5d0
[190994.918435]  [<c0564994>] error_code+0x74/0x80
[190994.972682]  [<c016cb34>] do_lookup+0x24/0x170
[190995.026931]  [<c016e62d>] __link_path_walk+0x6ed/0xb90
[190995.089492]  [<c016eb14>] link_path_walk+0x44/0xc0
[190995.147899]  [<c016ed46>] do_path_lookup+0x76/0x1d0
[190995.207343]  [<c016f728>] __user_walk_fd+0x38/0x50
[190995.265747]  [<c016918e>] vfs_lstat_fd+0x1e/0x50
[190995.322074]  [<c0169201>] vfs_lstat+0x11/0x20
[190995.375283]  [<c0169224>] sys_lstat64+0x14/0x30
[190995.430571]  [<c0104030>] syscall_call+0x7/0xb
[190995.484818]  =======================
[190995.528569] Code: 87 6d c0 d3 ea 31 d0 8b 15 94 87 6d c0 21 d0 8b 15 9c 87 6d c0 8b 34 82 85 f6 75 0f eb 57 8d b4 26 00 00 00 00 85 db 89 de 74 4a <8b> 1e 0f 18 03 90 8d 56 f4 8b 4d ec 89 55 d4 3b 4a 18 75 e6 8b 
[190995.761982] EIP: [<c0176026>] __d_lookup+0x66/0xf0 SS:ESP 0068:da74fd98


later on:

[192244.956031] BUG: unable to handle kernel paging request at virtual address 00c5ab01
[192245.048875]  printing eip:
[192245.082327] c0176026
[192245.109459] *pde = 00000000
[192245.143966] Oops: 0000 [#3]
[192245.178437] DEBUG_PAGEALLOC
[192245.213043] Modules linked in: ntfs vfat fat isofs udf
[192245.276131] CPU:    0
[192245.276135] EIP:    0060:[<c0176026>]    Not tainted VLI
[192245.276139] EFLAGS: 00210202   (2.6.21.5_VIA_EPIA_MII_12000 #1)
[192245.440650] EIP is at __d_lookup+0x66/0xf0
[192245.490626] eax: 00006ca2   ebx: 00c5ab01   ecx: 5a659370   edx: c0e5d62c
[192245.572830] esi: 00c5ab01   edi: cd1f1ef4   ebp: cd1f1dc4   esp: cd1f1d98
[192245.655034] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[192245.725806] Process spamassassin (pid: 18253, ti=cd1f0000 task=e522f1f0 task.ti=cd1f0000)
[192245.822556] Stack: c0e5d62c ea407760 cd1f1e20 f30a54b8 e7005990 00000007 5a659370 ef160023 
[192245.924400]        ef16002b cd1f1e20 cd1f1ef4 cd1f1dec c016cb34 cd1f1e2c cd1f1e20 c1894e20 
[192246.026245]        c016cddd ef160023 ef16002b cd1f1e20 e7005990 cd1f1e40 c016e066 cd1f1ef4 
[192246.128091] Call Trace:
[192246.160517]  [<c01055ba>] show_trace_log_lvl+0x1a/0x30
[192246.223077]  [<c0105679>] show_stack_log_lvl+0xa9/0xd0
[192246.285640]  [<c0105889>] show_registers+0x1e9/0x2f0
[192246.346122]  [<c0105aab>] die+0x11b/0x230
[192246.395175]  [<c01155e6>] do_page_fault+0x2c6/0x5d0
[192246.454619]  [<c0564994>] error_code+0x74/0x80
[192246.508869]  [<c016cb34>] do_lookup+0x24/0x170
[192246.563116]  [<c016e066>] __link_path_walk+0x126/0xb90
[192246.625678]  [<c016eb14>] link_path_walk+0x44/0xc0
[192246.684083]  [<c016ed46>] do_path_lookup+0x76/0x1d0
[192246.743526]  [<c016f728>] __user_walk_fd+0x38/0x50
[192246.801933]  [<c0169261>] vfs_stat_fd+0x21/0x50
[192246.857221]  [<c0169331>] vfs_stat+0x11/0x20
[192246.909389]  [<c0169354>] sys_stat64+0x14/0x30
[192246.963638]  [<c0104030>] syscall_call+0x7/0xb
[192247.017885]  =======================
[192247.061636] Code: 87 6d c0 d3 ea 31 d0 8b 15 94 87 6d c0 21 d0 8b 15 9c 87 6d c0 8b 34 82 85 f6 75 0f eb 57 8d b4 26 00 00 00 00 85 db 89 de 74 4a <8b> 1e 0f 18 03 90 8d 56 f4 8b 4d ec 89 55 d4 3b 4a 18 75 e6 8b 
[192247.295051] EIP: [<c0176026>] __d_lookup+0x66/0xf0 SS:ESP 0068:cd1f1d98




[193149.042826] BUG: unable to handle kernel paging request at virtual address 34353131
[193149.135712]  printing eip:
[193149.169176] c0176026
[193149.196396] *pde = 00000000
[193149.230807] Oops: 0000 [#4]
[193149.265278] DEBUG_PAGEALLOC
[193149.299885] Modules linked in: ntfs vfat fat isofs udf
[193149.362973] CPU:    0
[193149.362976] EIP:    0060:[<c0176026>]    Not tainted VLI
[193149.362981] EFLAGS: 00010202   (2.6.21.5_VIA_EPIA_MII_12000 #1)
[193149.527493] EIP is at __d_lookup+0x66/0xf0
[193149.577468] eax: 00017658   ebx: 34353131   ecx: 00d87b08   edx: c0e5db80
[193149.659672] esi: 34353131   edi: e7684f60   ebp: ce471ebc   esp: ce471e90
[193149.741876] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[193149.812648] Process htop (pid: 18327, ti=ce470000 task=e4432770 task.ti=ce470000)
[193149.901084] Stack: c0e5db80 c01673e2 ce471efc e7684f60 ce471f28 00000004 00d87b08 ce471f4f 
[193150.002929]        0000268c ce471efc e7684f60 ce471ed0 c01760cf 00d87b08 e4c98270 c82008c0 
[193150.104774]        ce471f14 c019335e 0000000a 00000000 00000002 ffffffff ffffffff c0170ed0 
[193150.206620] Call Trace:
[193150.239045]  [<c01055ba>] show_trace_log_lvl+0x1a/0x30
[193150.301605]  [<c0105679>] show_stack_log_lvl+0xa9/0xd0
[193150.364167]  [<c0105889>] show_registers+0x1e9/0x2f0
[193150.424652]  [<c0105aab>] die+0x11b/0x230
[193150.473705]  [<c01155e6>] do_page_fault+0x2c6/0x5d0
[193150.533148]  [<c0564994>] error_code+0x74/0x80
[193150.587395]  [<c01760cf>] d_lookup+0x1f/0x40
[193150.639565]  [<c019335e>] proc_fill_cache+0x5e/0x120
[193150.700049]  [<c0195b8f>] proc_task_readdir+0x25f/0x2d0
[193150.763651]  [<c01710f0>] vfs_readdir+0x70/0x90
[193150.818937]  [<c017117d>] sys_getdents64+0x6d/0xd0
[193150.877344]  [<c0104030>] syscall_call+0x7/0xb
[193150.931590]  =======================
[193150.975342] Code: 87 6d c0 d3 ea 31 d0 8b 15 94 87 6d c0 21 d0 8b 15 9c 87 6d c0 8b 34 82 85 f6 75 0f eb 57 8d b4 26 00 00 00 00 85 db 89 de 74 4a <8b> 1e 0f 18 03 90 8d 56 f4 8b 4d ec 89 55 d4 3b 4a 18 75 e6 8b 
[193151.208755] EIP: [<c0176026>] __d_lookup+0x66/0xf0 SS:ESP 0068:ce471e90


Trying to reboot the box...


Will now unmount local filesystems:umount2: Device or resource busy
[194009.778750] BUG: unable to handle kernel paging request at virtual address 323a786f
[194009.871607]  printing eip:
[194009.904968] c01767cd
[194009.932092] *pde = 00000000
[194009.966494] Oops: 0000 [#8]
[194010.000870] DEBUG_PAGEALLOC
[194010.035477] Modules linked in: ntfs vfat fat isofs udf
[194010.098566] CPU:    0
[194010.098570] EIP:    0060:[<c01767cd>]    Not tainted VLI
[194010.098574] EFLAGS: 00010207   (2.6.21.5_VIA_EPIA_MII_12000 #1)
[194010.263088] EIP is at shrink_dcache_sb+0x2d/0xb0
[194010.319296] eax: 323a786f   ebx: 323a786f   ecx: c0e5d0fc   edx: c06998e4
[194010.401500] esi: f122e200   edi: f122e200   ebp: ec34bdfc   esp: ec34bdf0
[194010.483703] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[194010.554475] Process umount (pid: 19063, ti=ec34a000 task=ebd8e470 task.ti=ec34a000)
[194010.644989] Stack: 00000001 f122e200 00000000 ec34be14 c0167aa8 00000001 00000001 f122e200 
[194010.746833]        f122e23c ec34bf8c c017abc5 00000000 e48b8000 00000000 00000000 00000001 
[194010.848679]        00000003 00000021 00000000 00000092 c06a5470 ec34be60 c1491700 c1491700 
[194010.950524] Call Trace:
[194010.982950]  [<c01055ba>] show_trace_log_lvl+0x1a/0x30
[194011.045511]  [<c0105679>] show_stack_log_lvl+0xa9/0xd0
[194011.108073]  [<c0105889>] show_registers+0x1e9/0x2f0
[194011.168558]  [<c0105aab>] die+0x11b/0x230
[194011.217610]  [<c01155e6>] do_page_fault+0x2c6/0x5d0
[194011.277053]  [<c0564994>] error_code+0x74/0x80
[194011.331301]  [<c0167aa8>] do_remount_sb+0x28/0x120
[194011.389707]  [<c017abc5>] do_mount+0x1c5/0x600
[194011.443956]  [<c017b066>] sys_mount+0x66/0xa0
[194011.497165]  [<c0104030>] syscall_call+0x7/0xb
[194011.551411]  =======================
[194011.595164] Code: e5 57 89 c7 a1 e4 98 69 c0 56 53 3d e4 98 69 c0 89 c1 8b 18 75 0a eb 1e 8d b6 00 00 00 00 89 c3 3b 79 28 74 6d
 81 fb e4 98 69 c0 <8b> 03 89 d9 75 ed a1 e4 98 69 c0 3d e4 98 69 c0 89 c1 8b 18 75 
[194011.828576] EIP: [<c01767cd>] shrink_dcache_sb+0x2d/0xb0 SS:ESP 0068:ec34bdf0
/etc/rc6.d/S40umountfs: line 61: 19063 Segmentation fault      umount -f -v -r -d $REG_MTPTS
 failed!
Stopping MD arrays...done (disabled in /etc/default/mdadm).
Mounting root filesystem read-only...[194012.351856] BUG: unable to handle kernel paging request at virtual address 323a786f
[194012.444652]  printing eip:
[194012.478014] c01767cd
[194012.505137] *pde = 00000000
[194012.539539] Oops: 0000 [#9]
[194012.573916] DEBUG_PAGEALLOC
[194012.608523] Modules linked in: ntfs vfat fat isofs udf
[194012.671612] CPU:    0
[194012.671615] EIP:    0060:[<c01767cd>]    Not tainted VLI
[194012.671620] EFLAGS: 00010207   (2.6.21.5_VIA_EPIA_MII_12000 #1)
[194012.836132] EIP is at shrink_dcache_sb+0x2d/0xb0
[194012.892343] eax: 323a786f   ebx: 323a786f   ecx: c0e5d0fc   edx: c06998e4
[194012.974547] esi: f7ee8a00   edi: f7ee8a00   ebp: d81e3dfc   esp: d81e3df0
[194013.056747] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[194013.127522] Process mount (pid: 19082, ti=d81e2000 task=d81df950 task.ti=d81e2000)
[194013.216996] Stack: 00000001 f7ee8a00 e6ad0000 d81e3e14 c0167aa8 00000001 00000001 f7ee8a00 
[194013.318842]        f7ee8a3c d81e3f8c c017abc5 00000000 e4ac3000 ebd7b000 00000000 c1894e20 
[194013.420687]        d81e3e40 00000021 fffffffe c1894e20 d81e3eac c016eb34 c14d5a00 c14d5a00 
[194013.522532] Call Trace:
[194013.554957]  [<c01055ba>] show_trace_log_lvl+0x1a/0x30
[194013.617519]  [<c0105679>] show_stack_log_lvl+0xa9/0xd0
[194013.680080]  [<c0105889>] show_registers+0x1e9/0x2f0
[194013.740564]  [<c0105aab>] die+0x11b/0x230
[194013.789616]  [<c01155e6>] do_page_fault+0x2c6/0x5d0
[194013.849061]  [<c0564994>] error_code+0x74/0x80
[194013.903309]  [<c0167aa8>] do_remount_sb+0x28/0x120
[194013.961713]  [<c017abc5>] do_mount+0x1c5/0x600
[194014.015961]  [<c017b066>] sys_mount+0x66/0xa0
[194014.069170]  [<c0104030>] syscall_call+0x7/0xb
[194014.123418]  =======================
[194014.167169] Code: e5 57 89 c7 a1 e4 98 69 c0 56 53 3d e4 98 69 c0 89 c1 8b 18 75 0a eb 1e 8d b6 00 00 00 00 89 c3 3b 79 28 74 6d
 81 fb e4 98 69 c0 <8b> 03 89 d9 75 ed a1 e4 98 69 c0 3d e4 98 69 c0 89 c1 8b 18 75 
[194014.400584] EIP: [<c01767cd>] shrink_dcache_sb+0x2d/0xb0 SS:ESP 0068:d81e3df0
/etc/rc6.d/S60umountroot: line 17: 19082 Segmentation fault      mount $MOUNT_FORCE_OPT -n -o remount,ro -t dummytype dummydev / 2>/
dev/null

*wait* doing nothing, so magic syskeys...

[194113.212308] SysRq : Resetting
[194113.248945] BUG: at drivers/pci/search.c:270 pci_get_subsys()
[194113.318676]  [<c01055ba>] show_trace_log_lvl+0x1a/0x30
[194113.381236]  [<c0105cc2>] show_trace+0x12/0x20
[194113.435484]  [<c0105d76>] dump_stack+0x16/0x20
[194113.489732]  [<c02bb5c7>] pci_get_subsys+0xf7/0x100
[194113.549177]  [<c02bb5eb>] pci_get_device+0x1b/0x20
[194113.607580]  [<c0111b45>] mach_reboot_fixups+0x15/0x30
[194113.670143]  [<c010dbd5>] machine_emergency_restart+0x25/0x110
[194113.741018]  [<c0127a88>] emergency_restart+0x8/0x10
[194113.801502]  [<c02eb242>] sysrq_handle_reboot+0x12/0x20
[194113.865104]  [<c02eaf96>] __handle_sysrq+0x86/0x140
[194113.924548]  [<c02eb078>] handle_sysrq+0x28/0x40
[194113.980876]  [<c02f2b4b>] receive_chars+0x21b/0x290
[194114.040320]  [<c02f41b2>] serial8250_interrupt+0xd2/0xf0
[194114.104960]  [<c0144305>] handle_IRQ_event+0x35/0x70
[194114.165444]  [<c01459f3>] handle_level_irq+0x53/0xc0
[194114.225928]  [<c0106d78>] do_IRQ+0x48/0xa0
[194114.276019]  [<c0104fe3>] common_interrupt+0x23/0x30
[194114.336503]  [<c0102cc3>] default_idle+0x43/0x60
[194114.392828]  [<c010eec5>] apm_cpu_idle+0x1e5/0x270
[194114.451245]  [<c01023be>] cpu_idle+0x3e/0x60
[194114.503403]  [<c010116e>] rest_init+0x1e/0x30
[194114.556613]  [<c06e0c2c>] start_kernel+0x2ac/0x400
[194114.615120]  [<00000000>] run_init_process+0x3fefefc0/0x20
[194114.681839]  =======================




older oopses:


[2055678.634084] BUG: unable to handle kernel NULL pointer dereference at virtual address 0000008c
[2055678.738361]  printing eip:
[2055678.772771] c01cd356
[2055678.801037] *pde = 00000000
[2055678.836707] Oops: 0000 [#1]
[2055678.872196] DEBUG_PAGEALLOC
[2055678.907844] Modules linked in: jfs xfs reiserfs ntfs vfat fat isofs udf
[2055678.989950] CPU:    0
[2055678.989954] EIP:    0060:[<c01cd356>]    Not tainted VLI
[2055678.989959] EFLAGS: 00210286   (2.6.21.5_VIA_EPIA_MII_12000 #1)
[2055679.157595] EIP is at journal_blocks_per_page+0x6/0x20
[2055679.221174] eax: 00000000   ebx: 00000000   ecx: 0000000c   edx: c101cba0
[2055679.304418] esi: 00000000   edi: c101cba0   ebp: d971fd0c   esp: d971fd00
[2055679.387661] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[2055679.459474] Process newsbeuter (pid: 13443, ti=d971e000 task=cfc64870 task.ti=d971e000)
[2055679.555183] Stack: d971fd0c c01a243b c01a4810 d971fd40 c01a482a d971fd40 c06990a8 00000000 
[2055679.658067]        00000400 e9f5fbe8 d971fd40 c0148cd7 e9f5fbec c01a4810 0000035e c056f420 
[2055679.760952]        d971fdf0 c014a240 00000800 00000000 c101cba0 00000001 d971fedc 00000001
[2055679.863835] Call Trace:
[2055679.897301]  [<c01055ba>] show_trace_log_lvl+0x1a/0x30
[2055679.960901]  [<c0105679>] show_stack_log_lvl+0xa9/0xd0
[2055680.024502]  [<c0105889>] show_registers+0x1e9/0x2f0
[2055680.086025]  [<c0105aab>] die+0x11b/0x230
[2055680.136117]  [<c01155e6>] do_page_fault+0x2c6/0x5d0
[2055680.196600]  [<c0564994>] error_code+0x74/0x80
[2055680.251888]  [<c01a482a>] ext3_prepare_write+0x1a/0x180
[2055680.316528]  [<c014a240>] generic_file_buffered_write+0x2b0/0x690
[2055680.391561]  [<c014a8aa>] __generic_file_aio_write_nolock+0x28a/0x570
[2055680.470751]  [<c014abe4>] generic_file_aio_write+0x54/0xc0
[2055680.538510]  [<c01a07dd>] ext3_file_write+0x2d/0xc0
[2055680.598992]  [<c01660fd>] do_sync_write+0xcd/0x110
[2055680.658436]  [<c0166905>] vfs_write+0x95/0x110
[2055680.713725]  [<c0166e8d>] sys_write+0x3d/0x70
[2055680.767974]  [<c0104030>] syscall_call+0x7/0xb
[2055680.823260]  =======================
[2055680.868050] Code: 75 09 c7 40 04 00 00 00 00 31 d2 5d 89 d0 c3 8d b6 00 00 00 00 8b 50 04 55 89 e5 85 d2 74 03 83 08 04 5d c3  
[2055681.102502] EIP: [<c01cd356>] journal_blocks_per_page+0x6/0x20 SS:ESP 0068:d971fd00
[2055713.475707] BUG: unable to handle kernel paging request at virtual address 81800000
[2055713.569636]  printing eip:
[2055713.604140] 81800000
[2055713.632422] *pde = 00000000
[2055713.667941] Oops: 0000 [#2]
[2055713.703356] DEBUG_PAGEALLOC
[2055713.739003] Modules linked in: jfs xfs reiserfs ntfs vfat fat isofs udf
[2055713.821110] CPU:    0
[2055713.821113] EIP:    0060:[<81800000>]    Not tainted VLI
[2055713.821118] EFLAGS: 00010286   (2.6.21.5_VIA_EPIA_MII_12000 #1)
[2055713.988737] EIP is at 0x81800000
[2055714.029369] eax: d07cdd50   ebx: e9f5fba8   ecx: 00000001   edx: d07cddd4
[2055714.112611] esi: d07cdd50   edi: d07cddd4   ebp: d07cdde8   esp: d07cdd40
[2055714.195853] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[2055714.267666] Process pdflush (pid: 8391, ti=d07cc000 task=c196e710 task.ti=d07cc000)
[2055714.359218] Stack: c016620d d07cde38 c0148c29 c101cba0 0000001d 0000001d 00000000 00000001 
[2055714.462103]        ffffffff c101cba0 00000000 00000000 00000000 00000000 c196e710 00000000 
[2055714.564987]        00000000 f6682990 c196e710 c012d250 d07cdd90 d07cdd90 d07cde38 c0148c29 
[2055714.667872] Call Trace:
[2055714.701337]  [<c01055ba>] show_trace_log_lvl+0x1a/0x30
[2055714.764937]  [<c0105679>] show_stack_log_lvl+0xa9/0xd0
[2055714.828539]  [<c0105889>] show_registers+0x1e9/0x2f0
[2055714.890062]  [<c0105aab>] die+0x11b/0x230
[2055714.940154]  [<c01155e6>] do_page_fault+0x2c6/0x5d0
[2055715.000637]  [<c0564994>] error_code+0x74/0x80
[2055715.055925]  [<c0148c6f>] sync_page+0x2f/0x40
[2055715.110171]  [<c0563abf>] __wait_on_bit_lock+0x3f/0x70
[2055715.173773]  [<c0148c29>] __lock_page+0x69/0x70
[2055715.230100]  [<c014e255>] generic_writepages+0x105/0x310
[2055715.295779]  [<c014e4a9>] do_writepages+0x49/0x50
[2055715.354185]  [<c017f7ca>] __writeback_single_inode+0x8a/0x320
[2055715.425061]  [<c017fdb3>] sync_sb_inodes+0x183/0x220
[2055715.486585]  [<c0180177>] writeback_inodes+0x67/0x80
[2055715.548106]  [<c014e962>] wb_kupdate+0x82/0xf0
[2055715.603394]  [<c014edfb>] pdflush+0xdb/0x1b0
[2055715.656603]  [<c012d063>] kthread+0xa3/0xd0
[2055715.708772]  [<c01051c7>] kernel_thread_helper+0x7/0x10
[2055715.773413]  =======================
[2055715.818203] Code:  Bad EIP value.
[2055715.860086] EIP: [<81800000>] 0x81800000 SS:ESP 0068:d07cdd40
[2056079.756023] BUG: unable to handle kernel paging request at virtual address 8c7cfe2d
[2056079.849813]  printing eip:
[2056079.884214] e52ebaca
[2056079.912376] *pde = 00000000
[2056079.947817] Oops: 0002 [#3]
[2056079.983253] DEBUG_PAGEALLOC
[2056080.018898] Modules linked in: jfs xfs reiserfs ntfs vfat fat isofs udf
[2056080.101006] CPU:    0
[2056080.101009] EIP:    0060:[<e52ebaca>]    Not tainted VLI
[2056080.101014] EFLAGS: 00010006   (2.6.21.5_VIA_EPIA_MII_12000 #1)
[2056080.268632] EIP is at 0xe52ebaca
[2056080.309263] eax: d67cfe27   ebx: d07cde20   ecx: 00000000   edx: 0000de03
[2056080.392507] esi: e1424fda   edi: 97f99e93   ebp: f7c3beb4   esp: f7c3be94
[2056080.475749] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[2056080.547562] Process kjournald (pid: 947, ti=f7c3a000 task=f7ce13f0 task.ti=f7c3a000)
[2056080.640153] Stack: c0117499 f7c3bedc 00000001 00000003 c17c0020 f7c3bedc 00000292 c17c0020 
[2056080.743037]        f7c3bed0 c01187fa 00000000 f7c3bedc c17c0020 c0cf92e8 e81d5274 f7c3bee8 
[2056080.845923]        c012d21a f7c3bedc c0cf92e8 00000017 00000017 f7c3bef8 c012d23f e3f3e760
[2056080.948807] Call Trace:
[2056080.982273]  [<c01055ba>] show_trace_log_lvl+0x1a/0x30
[2056081.045872]  [<c0105679>] show_stack_log_lvl+0xa9/0xd0
[2056081.109474]  [<c0105889>] show_registers+0x1e9/0x2f0
[2056081.170997]  [<c0105aab>] die+0x11b/0x230
[2056081.221089]  [<c01155e6>] do_page_fault+0x2c6/0x5d0
[2056081.281572]  [<c0564994>] error_code+0x74/0x80
[2056081.336858]  [<c01187fa>] __wake_up+0x3a/0x60
[2056081.391107]  [<c012d21a>] __wake_up_bit+0x2a/0x30
[2056081.449512]  [<c012d23f>] wake_up_bit+0x1f/0x30
[2056081.505839]  [<c01ca5fd>] journal_commit_transaction+0x6fd/0x1220
[2056081.580872]  [<c01cee8c>] kjournald+0x12c/0x340
[2056081.637199]  [<c012d063>] kthread+0xa3/0xd0
[2056081.689368]  [<c01051c7>] kernel_thread_helper+0x7/0x10
[2056081.754008]  =======================
[2056081.798800] Code: 00 c4 4e 52 22 24 04 00 00 8e 25 55 22 f4 0c 00 00 3c ee aa 23 40 0e 00 00 f6 9f 18 25 0c 03 00 00 e6 0d 27  
[2056082.033251] EIP: [<e52ebaca>] 0xe52ebaca SS:ESP 0068:f7c3be94
[2061498.042476] BUG: unable to handle kernel paging request at virtual address 8c7cfe2d
[2061498.136276]  printing eip:
[2061498.170676] e52ebaca
[2061498.198841] *pde = 00000000
[2061498.234281] Oops: 0002 [#4]
[2061498.269715] DEBUG_PAGEALLOC
[2061498.305362] Modules linked in: jfs xfs reiserfs ntfs vfat fat isofs udf
[2061498.387468] CPU:    0
[2061498.387471] EIP:    0060:[<e52ebaca>]    Not tainted VLI
[2061498.387476] EFLAGS: 00010006   (2.6.21.5_VIA_EPIA_MII_12000 #1)
[2061498.555095] EIP is at 0xe52ebaca
[2061498.595727] eax: d67cfe27   ebx: d07cde20   ecx: 00000000   edx: 0000de03
[2061498.678971] esi: e1424fda   edi: 97f99e93   ebp: c18e3dbc   esp: c18e3d9c
[2061498.762211] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[2061498.834025] Process kswapd0 (pid: 138, ti=c18e2000 task=c194a150 task.ti=c18e2000)
[2061498.924538] Stack: c0117499 c18e3de4 00000001 00000003 c17c0020 c18e3de4 00000282 c17c0020 
[2061499.027422]        c18e3dd8 c01187fa 00000000 c18e3de4 c17c0020 c0698e20 00000001 c18e3df0 
[2061499.130306]        c012d21a c18e3de4 c101b920 00000000 c101b920 c18e3dfc c0148ca4 c101b920 
[2061499.233191] Call Trace:
[2061499.266658]  [<c01055ba>] show_trace_log_lvl+0x1a/0x30
[2061499.330256]  [<c0105679>] show_stack_log_lvl+0xa9/0xd0
[2061499.393859]  [<c0105889>] show_registers+0x1e9/0x2f0
[2061499.455380]  [<c0105aab>] die+0x11b/0x230
[2061499.505472]  [<c01155e6>] do_page_fault+0x2c6/0x5d0
[2061499.565957]  [<c0564994>] error_code+0x74/0x80
[2061499.621243]  [<c01187fa>] __wake_up+0x3a/0x60
[2061499.675492]  [<c012d21a>] __wake_up_bit+0x2a/0x30
[2061499.733897]  [<c0148ca4>] unlock_page+0x24/0x30
[2061499.790224]  [<c015121b>] shrink_inactive_list+0x5db/0x7d0
[2061499.857980]  [<c01514b4>] shrink_zone+0xa4/0x100
[2061499.915346]  [<c0151a02>] kswapd+0x2f2/0x3f0
[2061499.968557]  [<c012d063>] kthread+0xa3/0xd0
[2061500.020726]  [<c01051c7>] kernel_thread_helper+0x7/0x10
[2061500.085366]  =======================
[2061500.130156] Code: 00 c4 4e 52 22 24 04 00 00 8e 25 55 22 f4 0c 00 00 3c ee aa 23 40 0e 00 00 f6 9f 18 25 0c 03 00 00 e6 0d 27  
[2061500.364610] EIP: [<e52ebaca>] 0xe52ebaca SS:ESP 0068:c18e3d9c
[2061869.491632] BUG: unable to handle kernel paging request at virtual address 8c7cfe2d
[2061869.585439]  printing eip:
[2061869.619840] e52ebaca
[2061869.648002] *pde = 00000000
[2061869.683446] Oops: 0002 [#5]
[2061869.718879] DEBUG_PAGEALLOC
[2061869.754525] Modules linked in: jfs xfs reiserfs ntfs vfat fat isofs udf
[2061869.836630] CPU:    0
[2061869.836634] EIP:    0060:[<e52ebaca>]    Not tainted VLI
[2061869.836639] EFLAGS: 00010012   (2.6.21.5_VIA_EPIA_MII_12000 #1)
[2061870.004258] EIP is at 0xe52ebaca
[2061870.044889] eax: d67cfe27   ebx: d07cde20   ecx: 00000000   edx: 0000de03
[2061870.128133] esi: e1424fda   edi: 97f99e93   ebp: c1999af4   esp: c1999ad4
[2061870.211375] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[2061870.283188] Process mpd (pid: 2910, ti=c1998000 task=c194ac10 task.ti=c1998000)
[2061870.370583] Stack: c0117499 c1999b1c 00000001 00000003 c17c0020 c1999b1c 00000296 c17c0020 
[2061870.473468]        c1999b10 c01187fa 00000000 c1999b1c c17c0020 c0698e20 00000001 c1999b28 
[2061870.576353]        c012d21a c1999b1c c101e9e0 00000000 c101e9e0 c1999b34 c0148ca4 c101e9e0 
[2061870.679238] Call Trace:
[2061870.712703]  [<c01055ba>] show_trace_log_lvl+0x1a/0x30
[2061870.776302]  [<c0105679>] show_stack_log_lvl+0xa9/0xd0
[2061870.839904]  [<c0105889>] show_registers+0x1e9/0x2f0
[2061870.901427]  [<c0105aab>] die+0x11b/0x230
[2061870.951517]  [<c01155e6>] do_page_fault+0x2c6/0x5d0
[2061871.012001]  [<c0564994>] error_code+0x74/0x80
[2061871.067290]  [<c01187fa>] __wake_up+0x3a/0x60
[2061871.121536]  [<c012d21a>] __wake_up_bit+0x2a/0x30
[2061871.179942]  [<c0148ca4>] unlock_page+0x24/0x30
[2061871.236269]  [<c015121b>] shrink_inactive_list+0x5db/0x7d0
[2061871.304026]  [<c01514b4>] shrink_zone+0xa4/0x100
[2061871.361394]  [<c0151e9d>] try_to_free_pages+0x11d/0x210
[2061871.426034]  [<c014d645>] __alloc_pages+0x165/0x350
[2061871.486516]  [<c014f09a>] __do_page_cache_readahead+0xda/0x210
[2061871.558432]  [<c014f232>] blockable_page_cache_readahead+0x62/0xc0
[2061871.634504]  [<c014f304>] make_ahead_window+0x74/0xc0
[2061871.697066]  [<c014f3da>] page_cache_readahead+0x8a/0x1c0
[2061871.763784]  [<c01496a1>] do_generic_mapping_read+0x3f1/0x430
[2061871.834662]  [<c014b51e>] generic_file_aio_read+0xee/0x1f0
[2061871.902418]  [<c016620d>] do_sync_read+0xcd/0x110
[2061871.960825]  [<c0166a10>] vfs_read+0x90/0x100
[2061872.015072]  [<c0166e1d>] sys_read+0x3d/0x70
[2061872.068280]  [<c0104030>] syscall_call+0x7/0xb
[2061872.123568]  =======================
[2061872.168358] Code: 00 c4 4e 52 22 24 04 00 00 8e 25 55 22 f4 0c 00 00 3c ee aa 23 40 0e 00 00 f6 9f 18 25 0c 03 00 00 e6 0d 27  
[2061872.402812] EIP: [<e52ebaca>] 0xe52ebaca SS:ESP 0068:c1999ad4
[2062116.091128] BUG: unable to handle kernel paging request at virtual address 8c7cfe2d
[2062116.184868]  printing eip:
[2062116.219267] e52ebaca
[2062116.247431] *pde = 00000000
[2062116.282873] Oops: 0002 [#6]
[2062116.318305] DEBUG_PAGEALLOC
[2062116.353952] Modules linked in: jfs xfs reiserfs ntfs vfat fat isofs udf
[2062116.436059] CPU:    0
[2062116.436062] EIP:    0060:[<e52ebaca>]    Not tainted VLI
[2062116.436067] EFLAGS: 00010886   (2.6.21.5_VIA_EPIA_MII_12000 #1)
[2062116.603685] EIP is at 0xe52ebaca
[2062116.644318] eax: d67cfe27   ebx: d07cde20   ecx: 00000000   edx: 0000de03
[2062116.727561] esi: e1424fda   edi: 97f99e93   ebp: c1999bac   esp: c1999b8c
[2062116.810803] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[2062116.882617] Process mpd (pid: 13605, ti=c1998000 task=c194ac10 task.ti=c1998000)
[2062116.971050] Stack: c0117499 c1999bd4 00000001 00000003 c17c0020 c1999bd4 00000286 c17c0020 
[2062117.073935]        c1999bc8 c01187fa 00000000 c1999bd4 c17c0020 c0c068ec c1999c20 c1999be0 
[2062117.176819]        c012d21a c1999bd4 c0c068ec 00000003 00000003 c1999bf0 c012d23f c0c067f0 
[2062117.279705] Call Trace:
[2062117.313169]  [<c01055ba>] show_trace_log_lvl+0x1a/0x30
[2062117.376770]  [<c0105679>] show_stack_log_lvl+0xa9/0xd0
[2062117.440371]  [<c0105889>] show_registers+0x1e9/0x2f0
[2062117.501893]  [<c0105aab>] die+0x11b/0x230
[2062117.551984]  [<c01155e6>] do_page_fault+0x2c6/0x5d0
[2062117.612469]  [<c0564994>] error_code+0x74/0x80
[2062117.667755]  [<c01187fa>] __wake_up+0x3a/0x60
[2062117.722004]  [<c012d21a>] __wake_up_bit+0x2a/0x30
[2062117.780409]  [<c012d23f>] wake_up_bit+0x1f/0x30
[2062117.836736]  [<c0177552>] wake_up_inode+0x12/0x20
[2062117.895141]  [<c0178073>] dispose_list+0x63/0xb0
[2062117.952506]  [<c0178266>] shrink_icache_memory+0x1a6/0x1f0
[2062118.020265]  [<c0151618>] shrink_slab+0x108/0x160
[2062118.078670]  [<c0151ec1>] try_to_free_pages+0x141/0x210
[2062118.143310]  [<c014d645>] __alloc_pages+0x165/0x350
[2062118.203795]  [<c014f09a>] __do_page_cache_readahead+0xda/0x210
[2062118.275709]  [<c014f232>] blockable_page_cache_readahead+0x62/0xc0
[2062118.351781]  [<c014f304>] make_ahead_window+0x74/0xc0
[2062118.414343]  [<c014f3da>] page_cache_readahead+0x8a/0x1c0
[2062118.481063]  [<c01496a1>] do_generic_mapping_read+0x3f1/0x430
[2062118.551938]  [<c014b51e>] generic_file_aio_read+0xee/0x1f0
[2062118.619697]  [<c016620d>] do_sync_read+0xcd/0x110
[2062118.678102]  [<c0166a10>] vfs_read+0x90/0x100
[2062118.732349]  [<c0166e1d>] sys_read+0x3d/0x70
[2062118.785559]  [<c0104030>] syscall_call+0x7/0xb
[2062118.840845]  =======================
[2062118.885635] Code: 00 c4 4e 52 22 24 04 00 00 8e 25 55 22 f4 0c 00 00 3c ee aa 23 40 0e 00 00 f6 9f 18 25 0c 03 00 00 e6 0d 27  
[2062119.120088] EIP: [<e52ebaca>] 0xe52ebaca SS:ESP 0068:c1999b8c


