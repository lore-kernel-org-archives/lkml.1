Return-Path: <linux-kernel-owner+w=401wt.eu-S933883AbXGKTku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbXGKTku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762044AbXGKTki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:40:38 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:35806 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756262AbXGKTkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:40:37 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jul 2007 15:40:36 EDT
Message-ID: <469523FA.7010308@namesys.com>
Date: Wed, 11 Jul 2007 22:39:54 +0400
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Zan Lynx <zlynx@acm.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       "Vladimir V. Saveliev" <vs@namesys.com>
Subject: Re: 2.6.22-rc6-mm1 reiser4_tree_by_page NULL pointer
References: <1184090582.6933.20.camel@localhost>
In-Reply-To: <1184090582.6933.20.camel@localhost>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: multipart/mixed;
 boundary="------------070703040802070406010104"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070703040802070406010104
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


I have found the bug, which kills data
when booting after crash, power loss, etc.
The patch is attached.
Please, ping me, if it doesn't help..

Thanks,
Edward.

Zan Lynx wrote:

>This bug is annoying enough that I mostly stopped using rc6-mm1, which
>is why it took this long to make a report.  Previous crashes were
>tainted.
>
>I recall seeing something about page table problems with this rc6-mm1
>but I don't know if that's what happened to me.
>
>System highlights are: x86_64, SLUB, Reiser4, ZONE_MOVABLE
>(kernelcore=384M), PATA with libata.
>
>So here it is:
>netconsole: network logging started
>eth0: no IPv6 routers present
>Hangcheck: hangcheck value past margin!
>ISO 9660 Extensions: Microsoft Joliet Level 3
>ISO 9660 Extensions: RRIP_1991A
>Hangcheck: hangcheck value past margin!
>Hangcheck: hangcheck value past margin!
>Hangcheck: hangcheck value past margin!
>Hangcheck: hangcheck value past margin!
>Hangcheck: hangcheck value past margin!
>Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
> [<ffffffff8033d324>] reiser4_tree_by_page+0x4/0x20
>PGD 9a69067 PUD 9a57067 PMD 0 
>Oops: 0000 [1] PREEMPT SMP 
>CPU 0 
>Modules linked in: nls_iso8859_1 isofs nls_base netconsole usbhid hid snd_pcm_oss snd_mixer_oss ipv6 snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd snd_page_alloc ehci_hcd ohci_hcd usbcore evdev psmouse serio_raw sg
>Pid: 10479, comm: rhythmbox Not tainted 2.6.22-rc6-mm1 #3
>RIP: 0010:[<ffffffff8033d324>]  [<ffffffff8033d324>] reiser4_tree_by_page+0x4/0x20
>RSP: 0018:ffff810011c21940  EFLAGS: 00010296
>RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000000c
>RDX: 00000000000000f0 RSI: 0000000000000000 RDI: ffff810002135d80
>RBP: ffff810002135d80 R08: 0000000000000000 R09: 0000000000000001
>R10: 00000000000002b2 R11: ffffffff8035a350 R12: ffff810002135d80
>R13: ffff810011c21a90 R14: ffff81000e5fcdbc R15: ffff81000e5fcdbc
>FS:  0000000042003940(0063) GS:ffffffff8075b000(0000) knlGS:00000000f7ddf6b0
>CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>CR2: 0000000000000000 CR3: 0000000004368000 CR4: 00000000000006e0
>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>Process rhythmbox (pid: 10479, threadinfo ffff810011c20000, task ffff8100007b2f10)
>Stack:  ffffffff8032649a ffff810011c21a90 0000000000000000 ffff810002135d80
> ffff810011c21a58 ffff810011c21a90 ffff81000e5fcdbc ffff81000e5fcdbc
> ffff810000000002 [<ffffffff8034dc96>] readpages_unix_file+0x56/0xc0
> [<ffffffff80282d05>] do_generic_mapping_read+0x2f5/0x4b0
> [<ffffffff80254580>] autoremove_wake_function+0x0/0x30
> [<ffffffff8034cf9f>] read_unix_file+0x49f/0x4c0
> [<ffffffff802ad995>] vfs_read+0xc5/0x180
>Code: 80 00 04 
> RSP <ffff810011c21940>
>Bad page state in process 'gdb'
>page:ffff810002135d80 flags:0xc000000000000001 mapping:0000000000000000 mapcount:0 count:0
>Trying to fix it up, but a reboot is needed
>Backtrace:
>
>Call Trace:
> [<ffffffff80286c0b>] bad_page+0x6b/0x120
> [<ffffffff80287f65>] get_page_from_freelist+0x435/0x520
> [<ffffffff8028812e>] __alloc_pages+0x9e/0x3c0
> [<ffffffff80292e6b>] __handle_mm_fault+0x4eb/0x930
> [<ffffffff80530d1e>] do_page_fault+0x14e/0x8c0
> [<ffffffff80530d9b>] do_page_fault+0x1cb/0x8c0
> [<ffffffff80234a0f>] dequeue_entity+0xaf/0xf0
> [<ffffffff8052e7df>] _spin_unlock_irq+0x2f/0x50
> [<ffffffff8052ee0d>] error_exit+0x0/0x96
> [<ffffffff802820bd>] file_read_actor+0x10d/0x1b0
> [<ffffffff80282c41>] do_generic_mapping_read+0x231/0x4b0
> [<ffffffff80281fb0>] file_read_actor+0x0/0x1b0
> [<ffffffff80284f46>] generic_file_aio_read+0x106/0x1c0
> [<ffffffff802ad019>] do_sync_read+0xd9/0x120
> [<ffffffff802a723b>] check_bytes_and_report+0x4b/0x100
> [<ffffffff802a7704>] check_object+0x224/0x260
> [<ffffffff80254580>] autoremove_wake_function+0x0/0x30
> [<ffffffff8052e669>] _spin_unlock+0x29/0x50
> [<ffffffff80330e2c>] reiser4_grab+0x8c/0xd0
> [<ffffffff8034cf9f>] read_unix_file+0x49f/0x4c0
> [<ffffffff802b0da5>] cp_new_stat+0xe5/0x100
> [<ffffffff802ad995>] vfs_read+0xc5/0x180
> [<ffffffff802ade93>] sys_read+0x53/0x90
> [<ffffffff8020c1de>] system_call+0x7e/0x83
>
>INFO: lockdep is turned off.
>Hexdump:
>000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>010: 00 00 00 00 00 00 00 00SysRq : Emergency Sync
>Emergency Sync complete
>SysRq : Emergency Sync
>Emergency Sync complete
>Hangcheck: hangcheck value past margin!
>SysRq : Emergency Sync
>Emergency Sync complete
>SysRq : Resetting
>  
>

--------------070703040802070406010104
Content-Type: text/x-patch;
 name="reiser4-fix-extent2tail.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reiser4-fix-extent2tail.patch"

Fixed bug in extent2tail conversion.

Bug description:
when converting partially converted file
(with flag REISER4_PART_MIXED installed)
reiser4_cut_tree() starts to cut old metatada
from wrong offset. Result is data corruption.

Signed-off-by: Edward Shishkin <edward@namesys.com>
---
 linux-2.6.22-rc6-mm1/fs/reiser4/plugin/file/file.c            |    7 -------
 linux-2.6.22-rc6-mm1/fs/reiser4/plugin/file/tail_conversion.c |    2 +-
 2 files changed, 1 insertion(+), 8 deletions(-)

--- linux-2.6.22-rc6-mm1/fs/reiser4/plugin/file/tail_conversion.c.orig
+++ linux-2.6.22-rc6-mm1/fs/reiser4/plugin/file/tail_conversion.c
@@ -620,7 +620,7 @@
 		}
 
 		/* cut part of file we have read */
-		start_byte = (__u64) (i << PAGE_CACHE_SHIFT);
+		start_byte = (__u64) ((i + start_page) << PAGE_CACHE_SHIFT);
 		set_key_offset(&from, start_byte);
 		set_key_offset(&to, start_byte + PAGE_CACHE_SIZE - 1);
 		/*
--- linux-2.6.22-rc6-mm1/fs/reiser4/plugin/file/file.c.orig
+++ linux-2.6.22-rc6-mm1/fs/reiser4/plugin/file/file.c
@@ -195,13 +195,6 @@
 	assert("vs-1164", level == LEAF_LEVEL || level == TWIG_LEVEL);
 
 	if (uf_info->container == UF_CONTAINER_UNKNOWN) {
-		/*
-		 * container is unknown, therefore conversion can not be in
-		 * progress
-		 */
-		assert("",
-		       !reiser4_inode_get_flag(unix_file_info_to_inode(uf_info),
-					       REISER4_PART_IN_CONV));
 		if (cbk_result == CBK_COORD_NOTFOUND)
 			uf_info->container = UF_CONTAINER_EMPTY;
 		else if (level == LEAF_LEVEL)

--------------070703040802070406010104--
