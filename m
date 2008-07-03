Return-Path: <linux-kernel-owner+w=401wt.eu-S936681AbYGCHOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936681AbYGCHOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbYGCG6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51164 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755381AbYGCGn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 02:43:26 -0400
Message-ID: <486C74B1.3000007@cn.fujitsu.com>
Date: Thu, 03 Jul 2008 14:41:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, npiggin@suse.de,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik Van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [-mm] BUG: sleeping function called from invalid context at include/linux/pagemap.h:290
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Seems the problematic patch is :
mmap-handle-mlocked-pages-during-map-remap-unmap.patch

I'm using mmotm uploaded yesterday by Andrew, so I guess this bug
has not been fixed ?

BUG: sleeping function called from invalid context at include/linux/pagemap.h:290
in_atomic():1, irqs_disabled():0
no locks held by gpg-agent/2134.
Pid: 2134, comm: gpg-agent Not tainted 2.6.26-rc8-mm1 #11
 [<c0421d38>] __might_sleep+0xbe/0xc5
 [<c04770a2>] __munlock_pte_handler+0x3c/0x9e
 [<c047c11f>] walk_page_range+0x15b/0x1b4
 [<c0477048>] __munlock_vma_pages_range+0x4e/0x5b
 [<c0476f0c>] ? __munlock_pmd_handler+0x0/0x10
 [<c0477066>] ? __munlock_pte_handler+0x0/0x9e
 [<c0477064>] munlock_vma_pages_range+0xf/0x11
 [<c0477dcb>] exit_mmap+0x32/0xf2
 [<c042ac12>] ? exit_mm+0xc7/0xda
 [<c042732a>] mmput+0x3a/0x8b
 [<c042ac20>] exit_mm+0xd5/0xda
 [<c042bf6a>] do_exit+0x1fb/0x5d5
 [<c045c4df>] ? audit_syscall_exit+0x2aa/0x2c5
 [<c042c3a3>] do_group_exit+0x5f/0x88
 [<c042c3db>] sys_exit_group+0xf/0x11
 [<c0403956>] syscall_call+0x7/0xb
 =======================
BUG: scheduling while atomic: gpg-agent/2134/0x10000001
no locks held by gpg-agent/2134.
Modules linked in: bridge llc dm_mod sg r8169 sata_sis pata_sis ata_generic libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Pid: 2134, comm: gpg-agent Not tainted 2.6.26-rc8-mm1 #11
 [<c0424d16>] __schedule_bug+0x5e/0x65
 [<c05fb1d6>] schedule+0x85/0x7f2
 [<c0404955>] ? show_trace_log_lvl+0x20/0x28
 [<c0404ff8>] ? show_trace+0x10/0x14
 [<c040591c>] ? dump_stack+0x5b/0x65
 [<c0424f26>] __cond_resched+0x25/0x3b
 [<c05fb9a6>] _cond_resched+0x24/0x2f
 [<c04770a7>] __munlock_pte_handler+0x41/0x9e
 [<c047c11f>] walk_page_range+0x15b/0x1b4
 [<c0477048>] __munlock_vma_pages_range+0x4e/0x5b
 [<c0476f0c>] ? __munlock_pmd_handler+0x0/0x10
 [<c0477066>] ? __munlock_pte_handler+0x0/0x9e
 [<c0477064>] munlock_vma_pages_range+0xf/0x11
 [<c0477dcb>] exit_mmap+0x32/0xf2
 [<c042ac12>] ? exit_mm+0xc7/0xda
 [<c042732a>] mmput+0x3a/0x8b
 [<c042ac20>] exit_mm+0xd5/0xda
 [<c042bf6a>] do_exit+0x1fb/0x5d5
 [<c045c4df>] ? audit_syscall_exit+0x2aa/0x2c5
 [<c042c3a3>] do_group_exit+0x5f/0x88
 [<c042c3db>] sys_exit_group+0xf/0x11
 [<c0403956>] syscall_call+0x7/0xb
 =======================
