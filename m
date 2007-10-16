Return-Path: <linux-kernel-owner+w=401wt.eu-S934649AbXJPR3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934649AbXJPR3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933422AbXJPR2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:28:52 -0400
Received: from Toushirou.duckcorp.org ([193.200.42.177]:43615 "EHLO
	mx1.duckcorp.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765699AbXJPR2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:28:51 -0400
X-Greylist: delayed 675 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2007 13:28:50 EDT
From: Arnaud Fontaine <arnaud@andesi.org>
To: linux-kernel@vger.kernel.org
Subject: error: Eeek! page_mapcount(page) went negative! (-1) with different process and kernels
Organization: Andesi
X-URL: http://www.andesi.org
X-Operating-System: Debian GNU/Linux
X-GnuPG-KeyID: 5E3619D3
X-PGP-Fingerprint: D792 B8A5 A567 B001 C342  2613 BDF2 A220 5E36 19D3
Date: Tue, 16 Oct 2007 19:17:32 +0200
Message-ID: <sa564176ksz.fsf@Toushirou.duckcorp.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Hello,

We have often the following error from the kernel:


--=-=-=
Content-Disposition: inline; filename=kern.log

 sshd[1551] trap invalid opcode rip:2aeacc0677a0 rsp:7fffe0c7e688 error:0
 Eeek! page_mapcount(page) went negative! (-1)
   page pfn = 7f7a8
   page->flags = 400000000001002c
   page->count = 1
   page->mapping = ffff810056170550
   vma->vm_ops = 0xffffffff80667ba0
   vma->vm_ops->nopage = _stext+0x7fdf7000/0x20
   vma->vm_ops->fault = filemap_fault+0x0/0x450
   vma->vm_file->f_op->mmap = generic_file_mmap+0x0/0x50
 ------------[ cut here ]------------
 kernel BUG at mm/rmap.c:630!
 invalid opcode: 0000 [1] SMP 
 CPU 0 
 Pid: 2554, comm: atop Not tainted 2.6.23.1-ipot #1
 RIP: 0010:[<ffffffff8027550b>]  [<ffffffff8027550b>] page_remove_rmap+0x12b/0x140
 RSP: 0018:ffff810075183d98  EFLAGS: 00010296
 RAX: 000000000000003b RBX: ffff810002be2cc0 RCX: 0000000000000001
 RDX: ffffffff80663968 RSI: 0000000000000086 RDI: ffffffff80663960
 RBP: ffff81007dccf5d0 R08: 0000000000000000 R09: 0000000000000001
 R10: 0000000000000000 R11: 0000000000000000 R12: 00002ac92645c000
 R13: ffff810002be2cc0 R14: 00002ac926462000 R15: 0000000000026000
 FS:  0000000000000000(0000) GS:ffffffff806b4000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 00002ac92705a020 CR3: 0000000000201000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process atop (pid: 2554, threadinfo ffff810075182000, task ffff81007fe6f7d0)
 Stack:  ffff8100013656f8 00002ac926462000 ffff8100751782e0 ffffffff8026cef3
  0000000000000000 ffffffff807235e0 ffff810002c0e5f8 00002ac926461fff
  0000000000000000 ffff810075183eb8 ffffffffffffffff 0000000000000000
 Call Trace:
  [<ffffffff8026cef3>] unmap_vmas+0x4f3/0x7e0
  [<ffffffff80271518>] exit_mmap+0x78/0x100
  [<ffffffff80230966>] mmput+0x26/0xb0
  [<ffffffff80236458>] do_exit+0x198/0x900
  [<ffffffff80236bec>] do_group_exit+0x2c/0x80
  [<ffffffff8020bbde>] system_call+0x7e/0x83
 
 
 Code: 0f 0b eb fe 48 8b 53 10 e9 65 ff ff ff 0f 1f 84 00 00 00 00 
 RIP  [<ffffffff8027550b>] page_remove_rmap+0x12b/0x140
  RSP <ffff810075183d98>
 Fixing recursive fault but reboot is needed!
 Bad page state in process 'kswapd0'
 page:ffff810002be2cc0 flags:0x4000000000010008 mapping:0000000000000000 mapcount:-1 count:0
 Trying to fix it up, but a reboot is needed
 Backtrace:
 
 Call Trace:
  [<ffffffff80263650>] bad_page+0x60/0xa0
  [<ffffffff80263f65>] free_hot_cold_page+0x345/0x350
  [<ffffffff80263f94>] __pagevec_free+0x24/0x30
  [<ffffffff80267210>] __pagevec_release_nonlru+0x60/0x70
  [<ffffffff8026885a>] shrink_page_list+0x26a/0x640
  [<ffffffff80267cfb>] isolate_lru_pages+0x8b/0x240
  [<ffffffff80268d79>] shrink_inactive_list+0x149/0x3f0
  [<ffffffff802690f0>] shrink_zone+0xd0/0x140
  [<ffffffff8026975d>] kswapd+0x3dd/0x520
  [<ffffffff80247560>] autoremove_wake_function+0x0/0x30
  [<ffffffff80269380>] kswapd+0x0/0x520
  [<ffffffff8024719b>] kthread+0x4b/0x80
  [<ffffffff8020c9f8>] child_rip+0xa/0x12
  [<ffffffff80247150>] kthread+0x0/0x80
  [<ffffffff8020c9ee>] child_rip+0x0/0x12
 
 list_lists[27598]: segfault at 0000000000000038 rip 000000000043b95a rsp 00007fff368010d0 error 4

--=-=-=


We have tested with different  kernel (2.6.23.1 and 2.6.22) and the same
error happens  with different process.  Any idea for knowing  what could
cause this error?

Please Cc me as I'm not subscribed to the list.

Regards,
Arnaud Fontaine

--=-=-=--
