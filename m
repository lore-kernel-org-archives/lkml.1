Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbYFEPC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbYFEPC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYFEPCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:02:20 -0400
Received: from sycorax.lbl.gov ([128.3.11.121]:47862 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbYFEPCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:02:19 -0400
X-Greylist: delayed 890 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2008 11:02:19 EDT
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc5
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org>
Date: Thu, 05 Jun 2008 07:47:28 -0700
In-Reply-To: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org>
	(message from Linus Torvalds on Wed, 4 Jun 2008 20:36:24 -0700 (PDT))
Message-ID: <87bq2gvszj.fsf@sycorax.lbl.gov>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Another week, another batch of mostly pretty small fixes. Hopefully
> the regression list is shrinking, and we've fixed at least a couple
> of the oopses on Arjan's list.

i get the following oops trying to mount an ntfs partition on thinkpad
t61 running a 64-bit kernel:

 BUG: unable to handle kernel paging request at ffffc20005bb0000
 IP: [<ffffffffa004fd83>] :ntfs:load_system_files+0x6ce/0x1892
 PGD 13bc0b067 PUD 13bc0c067 PMD 139491067 PTE 0
 Oops: 0000 [1] PREEMPT SMP 
 CPU 1 
 Modules linked in: nls_utf8 ntfs loop i2c_i801 i2c_core ehci_hcd uhci_hcd video output joydev evdev
 Pid: 1884, comm: mount Not tainted 2.6.26-rc5 #10
 RIP: 0010:[<ffffffffa004fd83>]  [<ffffffffa004fd83>] :ntfs:load_system_files+0x6ce/0x1892
 RSP: 0018:ffff810138c41bf8  EFLAGS: 00010287
 RAX: ffffc20005bb1000 RBX: 000000000000ffff RCX: 000000000001fffe
 RDX: 000000000000ffff RSI: 0000000000010000 RDI: ffffc20005b90000
 RBP: ffff810138d84c00 R08: 0000000000000062 R09: 8000000000000000
 R10: 000000620447de10 R11: ffffffffa0044978 R12: 0000000000000020
 R13: ffff810137c50778 R14: ffff810138d43800 R15: 0000000000000000
 FS:  00007f18f447d7e0(0000) GS:ffff81013ba1b580(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: ffffc20005bb0000 CR3: 00000001383de000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process mount (pid: 1884, threadinfo ffff810138c40000, task ffff81013958e8a0)
 Stack:  0000001000020052 ffff81013958e8a0 ffffc20005baffff ffff810138c41c88
  0000000000000163 ffffffff80201c20 0000000405bb0000 0000000000000001
  ffffe200044825d0 ffff810138d43800 0000000000000020 ffff810138d43800
 Call Trace:
  [<ffffffffa00521ff>] ? :ntfs:generate_default_upcase+0x47/0xdc
  [<ffffffffa00517fb>] ? :ntfs:ntfs_fill_super+0x8b4/0xd03
  [<ffffffff80518b04>] ? _spin_lock_irqsave+0x18/0x34
  [<ffffffffa0050f47>] ? :ntfs:ntfs_fill_super+0x0/0xd03
  [<ffffffff8028b9e0>] ? get_sb_bdev+0xfa/0x146
  [<ffffffff8028a925>] ? vfs_kern_mount+0x4f/0x95
  [<ffffffff8028a9be>] ? do_kern_mount+0x43/0xdc
  [<ffffffff8029fb10>] ? do_new_mount+0x5b/0x95
  [<ffffffff802a09ad>] ? do_mount+0x189/0x1b6
  [<ffffffff80264ec7>] ? __get_free_pages+0xe/0x4d
  [<ffffffff802a0a64>] ? sys_mount+0x8a/0xda
  [<ffffffff8020b24b>] ? system_call_after_swapgs+0x7b/0x80
 
 
 Code: 3d eb 58 01 00 48 85 ff 74 7f 8b 45 78 be 00 00 01 00 3d 00 00 01 00 0f 42 f0 31 db 31 c9 eb 19 48 8b 85 80 00 00 00 66 8b 14 08 <8b> 04 0f 48 83 c1 02 66 39 c2 75 06 ff c3 39 f3 7c e3 39 f3 75 
 RIP  [<ffffffffa004fd83>] :ntfs:load_system_files+0x6ce/0x1892
  RSP <ffff810138c41bf8>
 CR2: ffffc20005bb0000
 ---[ end trace a0fcaff9347f589b ]---

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
