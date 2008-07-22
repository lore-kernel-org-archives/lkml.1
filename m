Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbYGVNHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbYGVNHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbYGVNHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:07:11 -0400
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1890 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbYGVNHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:07:09 -0400
Message-ID: <4885DB79.2090202@xs4all.nl>
Date: Tue, 22 Jul 2008 15:07:05 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Known issue? hda: ide_cd_check_ireason: wrong transfer direction!
X-Enigmail-Version: 0.95.2
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Is teh log below of a known issue?
It's from 2.6.26 on a VIA EN12000.

Kind regards,
Udo

Jul 22 06:40:46 recorder kernel: hda: ide_cd_check_ireason: wrong
transfer direction!
Jul 22 06:47:02 recorder kernel: INFO: task hald-addon-stor:1522 blocked
for more than 120 seconds.
Jul 22 06:47:02 recorder kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 22 06:47:02 recorder kernel: hald-addon-st D c04581d8     0  1522   1475
Jul 22 06:47:02 recorder kernel:        f4e7dc28 00000086 0000000c
c04581d8 00000246 f4f2b890 f4f2b9f8 f4f2b9f8
Jul 22 06:47:02 recorder kernel:        00000000 c025c709 f4e7dca0
7fffffff f4e7dc88 f4e7dc94 c0306dd6 f4e7dd14
Jul 22 06:47:02 recorder kernel:        c0253f15 ffffffff f7b5bb40
c04581d8 00000000 00000092 ffffffff f7b5bb40
Jul 22 06:47:02 recorder kernel: Call Trace:
Jul 22 06:47:02 recorder kernel:  [<c025c709>]
cdrom_start_packet_command+0xb6/0xbd
Jul 22 06:47:02 recorder kernel:  [<c0306dd6>] schedule_timeout+0x14/0xaf
Jul 22 06:47:02 recorder kernel:  [<c0253f15>] ide_do_request+0x605/0x813
Jul 22 06:47:02 recorder kernel:  [<c0306cdb>] wait_for_common+0xb6/0x11d
Jul 22 06:47:02 recorder kernel:  [<c011444b>] default_wake_function+0x0/0xc
Jul 22 06:47:02 recorder kernel:  [<c02541ec>] ide_do_drive_cmd+0xc9/0xe5
Jul 22 06:47:02 recorder kernel:  [<c025cd1c>] ide_cd_queue_pc+0x35/0xa1
Jul 22 06:47:02 recorder kernel:  [<c02a3ef4>] cpuidle_idle_call+0x0/0x7c
Jul 22 06:47:02 recorder kernel:  [<c03069e9>] schedule+0x2bc/0x2ef
Jul 22 06:47:02 recorder kernel:  [<c025db6f>] cdrom_check_status+0x66/0x71
Jul 22 06:47:02 recorder kernel:  [<c01dddd1>] blk_end_sync_rq+0x0/0x23
Jul 22 06:47:02 recorder kernel:  [<c025ebd7>]
ide_cdrom_check_media_change_real+0x1b/0x36
Jul 22 06:47:02 recorder kernel:  [<c027c612>] media_changed+0x40/0x6e
Jul 22 06:47:02 recorder kernel:  [<c01754cb>] check_disk_change+0x13/0x5c
Jul 22 06:47:02 recorder kernel:  [<c0280718>] cdrom_open+0x879/0x8c9
Jul 22 06:47:02 recorder kernel:  [<c015adeb>] do_lookup+0x53/0x145
Jul 22 06:47:02 recorder kernel:  [<c01e353f>] kobject_get+0xf/0x13
Jul 22 06:47:02 recorder kernel:  [<c01df7be>] get_disk+0x53/0x6a
Jul 22 06:47:02 recorder kernel:  [<c01df7dc>] exact_lock+0x7/0xd
Jul 22 06:47:02 recorder kernel:  [<c023cfac>] kobj_lookup+0x108/0x134
Jul 22 06:47:02 recorder kernel:  [<c025c63f>] idecd_open+0x4f/0x63
Jul 22 06:47:02 recorder kernel:  [<c0175c20>] do_open+0x84/0x23c
Jul 22 06:47:02 recorder kernel:  [<c0175dd8>] blkdev_open+0x0/0x4d
Jul 22 06:47:02 recorder kernel:  [<c0175dfd>] blkdev_open+0x25/0x4d
Jul 22 06:47:02 recorder kernel:  [<c01533c6>] __dentry_open+0x129/0x211
Jul 22 06:47:02 recorder kernel:  [<c015352b>] nameidata_to_filp+0x1c/0x2c
Jul 22 06:47:02 recorder kernel:  [<c015dee4>] do_filp_open+0x319/0x6d6
Jul 22 06:47:02 recorder kernel:  [<c027d682>] cdrom_release+0x179/0x1ae
Jul 22 06:47:02 recorder kernel:  [<c0113356>] hrtick_start_fair+0xd0/0x11a
Jul 22 06:47:02 recorder kernel:  [<c0153116>] get_unused_fd_flags+0x5e/0xc9
Jul 22 06:47:02 recorder kernel:  [<c01531be>] do_sys_open+0x3d/0xb6
Jul 22 06:47:02 recorder kernel:  [<c015327b>] sys_open+0x1e/0x23
Jul 22 06:47:02 recorder kernel:  [<c0102ad1>] sysenter_past_esp+0x6a/0x99
Jul 22 06:47:02 recorder kernel:  =======================
