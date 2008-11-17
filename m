Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbYKQEQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbYKQEQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 23:16:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbYKQEPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 23:15:54 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:29471 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbYKQEPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 23:15:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=YeSameTZ0AQ5okBMpjswqDYRLVl7u64Hq7hSK7Nbypv5qDWpdezp06A39+UgxFS52O
         60dLPH2g8A99nqjcMQk172LKNVNkaj8I0YZIM+ggpoewptA9tnJYDNkHSZelu+s6fciI
         Wvjjmec6wufTwNeoos4NhyKswjqnqWv6sHe5c=
Subject: [ INFO: possible recursive locking detected ]
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 16 Nov 2008 20:15:47 -0800
Message-Id: <1226895348.3212.3.camel@LiNuX>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoa!
should I been running only kvm-intel
without kqemu, or do both need to be loaded?
(this is from mounting my osx external drive, and then running
qemu on that drive)


[  412.848254] 
[  412.848257] =============================================
[  412.848264] [ INFO: possible recursive locking detected ]
[  412.848270] 2.6.28-rc5-00018-ged82a0e #8
[  412.848273] ---------------------------------------------
[  412.848278] qemu-img/3166 is trying to acquire lock:
[  412.848283]  (&sb->s_type->i_mutex_key#10){--..}, at: [<f848e3eb>]
hfsplus_block_allocate+0x3d/0x2f6 [hfsplus]
[  412.848308] 
[  412.848309] but task is already holding lock:
[  412.848313]  (&sb->s_type->i_mutex_key#10){--..}, at: [<c0176c3c>]
generic_file_aio_write+0x54/0xbd
[  412.848330] 
[  412.848331] other info that might help us debug this:
[  412.848337] 2 locks held by qemu-img/3166:
[  412.848340]  #0:  (&sb->s_type->i_mutex_key#10){--..}, at:
[<c0176c3c>] generic_file_aio_write+0x54/0xbd
[  412.848356]  #1:  (&HFSPLUS_I(inode).extents_lock){--..}, at:
[<f8489797>] hfsplus_file_extend+0x6e/0x1e8 [hfsplus]
[  412.848378] 
[  412.848379] stack backtrace:
[  412.848384] Pid: 3166, comm: qemu-img Not tainted
2.6.28-rc5-00018-ged82a0e #8
[  412.848389] Call Trace:
[  412.848399]  [<c03e1f3b>] ? printk+0xf/0x14
[  412.848408]  [<c015b01c>] __lock_acquire+0xbff/0x1272
[  412.848423]  [<f8489797>] ? hfsplus_file_extend+0x6e/0x1e8 [hfsplus]
[  412.848431]  [<c015b676>] ? __lock_acquire+0x1259/0x1272
[  412.848439]  [<c0118dbe>] ? dump_trace+0xb7/0xeb
[  412.848447]  [<c015792c>] ? find_usage_backwards+0x33/0xea
[  412.848454]  [<c015b6ff>] lock_acquire+0x70/0x97
[  412.848468]  [<f848e3eb>] ? hfsplus_block_allocate+0x3d/0x2f6
[hfsplus]
[  412.848476]  [<c03e3202>] mutex_lock_nested+0xd2/0x26d
[  412.848490]  [<f848e3eb>] ? hfsplus_block_allocate+0x3d/0x2f6
[hfsplus]
[  412.848504]  [<f848e3eb>] ? hfsplus_block_allocate+0x3d/0x2f6
[hfsplus]
[  412.848519]  [<f848e3eb>] hfsplus_block_allocate+0x3d/0x2f6 [hfsplus]
[  412.848526]  [<c03e3395>] ? mutex_lock_nested+0x265/0x26d
[  412.848541]  [<f84897eb>] hfsplus_file_extend+0xc2/0x1e8 [hfsplus]
[  412.848550]  [<c01b3502>] ? create_empty_buffers+0x80/0x8b
[  412.848564]  [<f848999b>] hfsplus_get_block+0x8a/0x19b [hfsplus]
[  412.848572]  [<c01b4d0c>] __block_prepare_write+0x146/0x331
[  412.848580]  [<c0159c6f>] ? trace_hardirqs_on+0xb/0xd
[  412.848589]  [<c01754a4>] ? add_to_page_cache_locked+0x92/0x9b
[  412.848597]  [<c0175552>] ? __grab_cache_page+0x4d/0x6d
[  412.848605]  [<c01b505f>] block_write_begin+0x72/0xc9
[  412.848618]  [<f8489911>] ? hfsplus_get_block+0x0/0x19b [hfsplus]
[  412.848627]  [<c01b5305>] cont_write_begin+0x24f/0x27d
[  412.848640]  [<f8489911>] ? hfsplus_get_block+0x0/0x19b [hfsplus]
[  412.848654]  [<f8487fec>] hfsplus_write_begin+0x2d/0x32 [hfsplus]
[  412.848668]  [<f8489911>] ? hfsplus_get_block+0x0/0x19b [hfsplus]
[  412.848683]  [<c0175db0>] generic_file_buffered_write+0xcf/0x218
[  412.848694]  [<c01764b3>] __generic_file_aio_write_nolock+0x3cf/0x407
[  412.848702]  [<c0159a9a>] ? mark_held_locks+0x53/0x6a
[  412.848709]  [<c0159c3c>] ? trace_hardirqs_on_caller+0xf0/0x118
[  412.848717]  [<c0176c3c>] ? generic_file_aio_write+0x54/0xbd
[  412.848726]  [<c0176c51>] generic_file_aio_write+0x69/0xbd
[  412.848735]  [<c0199a15>] do_sync_write+0xab/0xe9
[  412.848743]  [<c014cb6b>] ? autoremove_wake_function+0x0/0x33
[  412.848753]  [<c021e93c>] ? selinux_file_permission+0x102/0x108
[  412.848761]  [<c0217cd4>] ? security_file_permission+0xf/0x11
[  412.848768]  [<c019996a>] ? do_sync_write+0x0/0xe9
[  412.848774]  [<c019a1da>] vfs_write+0x8a/0x104
[  412.848781]  [<c019a2ed>] sys_write+0x3b/0x60
[  412.848789]  [<c0116e27>] sysenter_do_call+0x12/0x3f
[  412.848797]  [<c0110000>] ? x86_emulate_insn+0x15df/0x3e27
[  475.947913] QEMU Accelerator Module version 1.3.0, Copyright (c)
2005-2007 Fabrice Bellard
[  475.948081] KQEMU installed, max_locked_mem=506216kB.




-- 
Justin P. Mattock <justinmattock@gmail.com>

