Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbXJ2NO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbXJ2NO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbXJ2NOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:14:21 -0400
Received: from mail-relay-02.mailcluster.net ([77.221.130.214]:39126 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752502AbXJ2NOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:14:20 -0400
Message-ID: <4725D5C6.3000408@vlnb.net>
Date: Mon, 29 Oct 2007 15:44:54 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc5
X-Accept-Language: en-us, ru, en
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: lockdep: possible circular locking dependency detected on umount
 ext3 mount point
Content-Type: multipart/mixed;
 boundary="------------030101080202070901050504"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030101080202070901050504
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I apologize if it's already reported, but quick search in LKML archive 
didn't find anything like that.

After some dbench runs on ext3 partition, mounted on /mnt, then quickly 
umount /mnt, lockdep reported possible circular locking dependency 
detected. See attach for the complete message. Kernel is 2.6.23. I can 
provide more info, if needed.

Regards,
Vlad


--------------030101080202070901050504
Content-Type: text/plain;
 name="kernel"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel"

Oct 29 15:32:30 tgt kernel: [ 2757.342000] =======================================================
Oct 29 15:32:30 tgt kernel: [ 2757.342008] [ INFO: possible circular locking dependency detected ]
Oct 29 15:32:30 tgt kernel: [ 2757.342016] 2.6.23-scst-dbg #17
Oct 29 15:32:30 tgt kernel: [ 2757.342022] -------------------------------------------------------
Oct 29 15:32:30 tgt kernel: [ 2757.342028] umount/4185 is trying to acquire lock:
Oct 29 15:32:30 tgt kernel: [ 2757.342034]  (iprune_mutex){--..}, at: [<783626a6>] mutex_lock+0x1c/0x1f
Oct 29 15:32:30 tgt kernel: [ 2757.342060] 
Oct 29 15:32:30 tgt kernel: [ 2757.342062] but task is already holding lock:
Oct 29 15:32:30 tgt kernel: [ 2757.342067]  (&type->s_lock_key#7){--..}, at: [<783626a6>] mutex_lock+0x1c/0x1f
Oct 29 15:32:30 tgt kernel: [ 2757.342087] 
Oct 29 15:32:30 tgt kernel: [ 2757.342088] which lock already depends on the new lock.
Oct 29 15:32:30 tgt kernel: [ 2757.342091] 
Oct 29 15:32:30 tgt kernel: [ 2757.342095] 
Oct 29 15:32:30 tgt kernel: [ 2757.342096] the existing dependency chain (in reverse order) is:
Oct 29 15:32:30 tgt kernel: [ 2757.342101] 
Oct 29 15:32:30 tgt kernel: [ 2757.342103] -> #1 (&type->s_lock_key#7){--..}:
Oct 29 15:32:30 tgt kernel: [ 2757.342119]        [<7813fa23>] __lock_acquire+0xf71/0x106e
Oct 29 15:32:30 tgt kernel: [ 2757.342151]        [<7813fb89>] lock_acquire+0x69/0x82
Oct 29 15:32:30 tgt kernel: [ 2757.342179]        [<7836240d>] __mutex_lock_slowpath+0x79/0x2f6
Oct 29 15:32:30 tgt kernel: [ 2757.342207]        [<783626a6>] mutex_lock+0x1c/0x1f
Oct 29 15:32:30 tgt kernel: [ 2757.342233]        [<781773be>] lock_super+0x19/0x1b
Oct 29 15:32:30 tgt kernel: [ 2757.342263]        [<781bf799>] ext3_orphan_add+0x1b/0x163
Oct 29 15:32:30 tgt kernel: [ 2757.342309]        [<781bb9e5>] ext3_truncate+0x391/0x935
Oct 29 15:32:30 tgt kernel: [ 2757.342335]        [<781bc63b>] ext3_delete_inode+0xbf/0xc6
Oct 29 15:32:30 tgt kernel: [ 2757.342363]        [<78188b7d>] generic_delete_inode+0x6a/0x105
Oct 29 15:32:30 tgt kernel: [ 2757.342392]        [<78188d27>] generic_drop_inode+0x10f/0x141
Oct 29 15:32:30 tgt kernel: [ 2757.342420]        [<78188226>] iput+0x5f/0x66
Oct 29 15:32:30 tgt kernel: [ 2757.342447]        [<78188f63>] shrink_icache_memory+0x138/0x20d
Oct 29 15:32:30 tgt kernel: [ 2757.342473]        [<7815fd53>] shrink_slab+0x130/0x198
Oct 29 15:32:30 tgt kernel: [ 2757.342500]        [<78160698>] try_to_free_pages+0x1bd/0x2b5
Oct 29 15:32:30 tgt kernel: [ 2757.342528]        [<7815b9de>] __alloc_pages+0x14c/0x364
Oct 29 15:32:30 tgt kernel: [ 2757.342557]        [<78157f5b>] generic_file_buffered_write+0x159/0x69c
Oct 29 15:32:30 tgt kernel: [ 2757.342584]        [<78158719>] __generic_file_aio_write_nolock+0x27b/0x536
Oct 29 15:32:30 tgt kernel: [ 2757.342612]        [<78158a2a>] generic_file_aio_write+0x56/0xc2
Oct 29 15:32:30 tgt kernel: [ 2757.342640]        [<781b8667>] ext3_file_write+0x27/0xa8
Oct 29 15:32:30 tgt kernel: [ 2757.342665]        [<78175d65>] do_sync_write+0xd0/0x106
Oct 29 15:32:30 tgt kernel: [ 2757.342693]        [<78176552>] vfs_write+0x8b/0x149
Oct 29 15:32:30 tgt kernel: [ 2757.342721]        [<78176bc4>] sys_write+0x3d/0x64
Oct 29 15:32:30 tgt kernel: [ 2757.342746]        [<78102ca2>] sysenter_past_esp+0x5f/0x99
Oct 29 15:32:30 tgt kernel: [ 2757.342775]        [<ffffffff>] 0xffffffff
Oct 29 15:32:30 tgt kernel: [ 2757.342814] 
Oct 29 15:32:30 tgt kernel: [ 2757.342815] -> #0 (iprune_mutex){--..}:
Oct 29 15:32:30 tgt kernel: [ 2757.342827]        [<7813f50f>] __lock_acquire+0xa5d/0x106e
Oct 29 15:32:30 tgt kernel: [ 2757.342855]        [<7813fb89>] lock_acquire+0x69/0x82
Oct 29 15:32:30 tgt kernel: [ 2757.342884]        [<7836240d>] __mutex_lock_slowpath+0x79/0x2f6
Oct 29 15:32:30 tgt kernel: [ 2757.342913]        [<783626a6>] mutex_lock+0x1c/0x1f
Oct 29 15:32:30 tgt kernel: [ 2757.342941]        [<78189056>] invalidate_inodes+0x1e/0xcc
Oct 29 15:32:30 tgt kernel: [ 2757.342969]        [<78177b3e>] generic_shutdown_super+0x37/0xcb
Oct 29 15:32:30 tgt kernel: [ 2757.342999]        [<78177be1>] kill_block_super+0xf/0x20
Oct 29 15:32:30 tgt kernel: [ 2757.343027]        [<78177ca6>] deactivate_super+0x63/0x75
Oct 29 15:32:30 tgt kernel: [ 2757.343054]        [<7818accc>] mntput_no_expire+0x44/0x62
Oct 29 15:32:30 tgt kernel: [ 2757.343084]        [<7817ca9e>] path_release_on_umount+0x15/0x18
Oct 29 15:32:30 tgt kernel: [ 2757.343113]        [<7818b21d>] sys_umount+0x3b/0x223
Oct 29 15:32:30 tgt kernel: [ 2757.343140]        [<7818b41e>] sys_oldumount+0x19/0x1b
Oct 29 15:32:30 tgt kernel: [ 2757.343168]        [<78102ca2>] sysenter_past_esp+0x5f/0x99
Oct 29 15:32:30 tgt kernel: [ 2757.343195]        [<ffffffff>] 0xffffffff
Oct 29 15:32:30 tgt kernel: [ 2757.343222] 
Oct 29 15:32:30 tgt kernel: [ 2757.343224] other info that might help us debug this:
Oct 29 15:32:30 tgt kernel: [ 2757.343226] 
Oct 29 15:32:30 tgt kernel: [ 2757.343231] 2 locks held by umount/4185:
Oct 29 15:32:30 tgt kernel: [ 2757.343237]  #0:  (&type->s_umount_key#15){----}, at: [<78177ca1>] deactivate_super+0x5e/0x75
Oct 29 15:32:30 tgt kernel: [ 2757.343263]  #1:  (&type->s_lock_key#7){--..}, at: [<783626a6>] mutex_lock+0x1c/0x1f
Oct 29 15:32:30 tgt kernel: [ 2757.343290] 
Oct 29 15:32:30 tgt kernel: [ 2757.343292] stack backtrace:
Oct 29 15:32:30 tgt kernel: [ 2757.343297]  [<78103d59>] show_trace_log_lvl+0x1a/0x30
Oct 29 15:32:30 tgt kernel: [ 2757.343308]  [<7810488d>] show_trace+0x12/0x14
Oct 29 15:32:30 tgt kernel: [ 2757.343320]  [<781048a5>] dump_stack+0x16/0x18
Oct 29 15:32:30 tgt kernel: [ 2757.343329]  [<7813d426>] print_circular_bug_tail+0x68/0x71
Oct 29 15:32:30 tgt kernel: [ 2757.343339]  [<7813f50f>] __lock_acquire+0xa5d/0x106e
Oct 29 15:32:30 tgt kernel: [ 2757.343349]  [<7813fb89>] lock_acquire+0x69/0x82
Oct 29 15:32:30 tgt kernel: [ 2757.343357]  [<7836240d>] __mutex_lock_slowpath+0x79/0x2f6
Oct 29 15:32:30 tgt kernel: [ 2757.343368]  [<783626a6>] mutex_lock+0x1c/0x1f
Oct 29 15:32:30 tgt kernel: [ 2757.343377]  [<78189056>] invalidate_inodes+0x1e/0xcc
Oct 29 15:32:30 tgt kernel: [ 2757.343388]  [<78177b3e>] generic_shutdown_super+0x37/0xcb
Oct 29 15:32:30 tgt kernel: [ 2757.343399]  [<78177be1>] kill_block_super+0xf/0x20
Oct 29 15:32:30 tgt kernel: [ 2757.343409]  [<78177ca6>] deactivate_super+0x63/0x75
Oct 29 15:32:30 tgt kernel: [ 2757.343419]  [<7818accc>] mntput_no_expire+0x44/0x62
Oct 29 15:32:30 tgt kernel: [ 2757.343429]  [<7817ca9e>] path_release_on_umount+0x15/0x18
Oct 29 15:32:30 tgt kernel: [ 2757.343440]  [<7818b21d>] sys_umount+0x3b/0x223
Oct 29 15:32:30 tgt kernel: [ 2757.343449]  [<7818b41e>] sys_oldumount+0x19/0x1b
Oct 29 15:32:30 tgt kernel: [ 2757.343458]  [<78102ca2>] sysenter_past_esp+0x5f/0x99
Oct 29 15:32:30 tgt kernel: [ 2757.343467]  =======================

--------------030101080202070901050504--
