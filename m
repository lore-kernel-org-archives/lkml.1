Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbYJUKWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbYJUKWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 06:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYJUKWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 06:22:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45091 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbYJUKWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 06:22:12 -0400
Date: Tue, 21 Oct 2008 19:21:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Rik van Riel <riel@redhat.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, lee.schermerhorn@hp.com,
       lizf@cn.fujitsu.com
Subject: Re: [crash, -git] NULL pointer dereference, IP: [<c0190884>]
 page_cgroup_zoneinfo+0xf/0x1b
Message-Id: <20081021192143.67361afc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081021100935.GA7100@elte.hu>
References: <20081021100935.GA7100@elte.hu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 12:09:35 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> Andrew,
> 
> today's -git started crashing in the VM, during bootup in rc.sysinit in 
> our tests:
> 



> -------------------->
> 
> EXT3-fs: recovery complete.
> EXT3-fs: mounted filesystem with ordered data mode.
> VFS: Mounted root (ext3 filesystem) readonly.
> debug: unmapping init memory c11c9000..c1398000
> gzip used greatest stack depth: 5916 bytes left
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<c018faa4>] page_cgroup_zoneinfo+0xf/0x1b
> *pde = 00000000 
> Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> last sysfs file: 
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> 
> Pid: 3595, comm: rc.sysinit Not tainted (2.6.27 #44341) System Product Name
> EIP: 0060:[<c018faa4>] EFLAGS: 00010246 CPU: 1
> EIP is at page_cgroup_zoneinfo+0xf/0x1b
> EAX: 00000000 EBX: 00000003 ECX: 00000002 EDX: c199ae00
> ESI: c2c7d898 EDI: c199ae0c EBP: f5e2dcf8 ESP: f5e2dcd4
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process rc.sysinit (pid: 3595, ti=f5e2c000 task=f5ddd240 task.ti=f5e2c000)
> Stack:
>  c019027a 00000010 00120050 c199ae0c 00000005 f5e2dd34 c1babb90 f5dd0240
>  c1babb90 f5e2dd18 c0190993 00000000 00000000 00120050 c1babb90 f5ce4800
>  f6c24868 f5e2dd34 c0170cbd 000f0019 00120050 c1babb90 f5ce4800 00000000
> Call Trace:
>  [<c019027a>] ? mem_cgroup_charge_common+0x149/0x1c4
>  [<c0190993>] ? mem_cgroup_cache_charge+0x81/0x8f
>  [<c0170cbd>] ? add_to_page_cache_locked+0x34/0xc9
>  [<c0170d7a>] ? add_to_page_cache_lru+0x28/0x63
>  [<c01713e3>] ? find_or_create_page+0x44/0x67
>  [<c01abd12>] ? __getblk+0xff/0x1d1
>  [<c01f88ca>] ? sb_getblk+0x16/0x18
>  [<c01f89bc>] ? __ext3_get_inode_loc+0xc5/0x27c
>  [<c03a10b9>] ? _raw_spin_unlock+0x74/0x78
>  [<c01a1317>] ? iget_locked+0xb1/0xdb
>  [<c01fb305>] ? ext3_iget+0x5b/0x310
>  [<c0b7361e>] ? _spin_unlock+0x22/0x25
>  [<c01fe5a7>] ? ext3_lookup+0x73/0x93
>  [<c0198f63>] ? do_lookup+0xbb/0x129
>  [<c019a5fd>] ? __link_path_walk+0x47c/0x5a9
>  [<c019a768>] ? path_walk+0x3e/0x77
>  [<c019a8f0>] ? do_path_lookup+0xec/0x125
>  [<c0199e44>] ? getname+0x8f/0xab
>  [<c019b0ff>] ? user_path_at+0x35/0x5b
>  [<c0108d17>] ? native_sched_clock+0x97/0xb5
>  [<c014bb8c>] ? trace_hardirqs_off+0xb/0xd
>  [<c016ee0b>] ? time_hardirqs_off+0x1b/0x1f
>  [<c014bb1b>] ? trace_hardirqs_off_caller+0x15/0x7b
>  [<c0195747>] ? vfs_stat_fd+0x1e/0x45
>  [<c0195831>] ? vfs_stat+0x16/0x18
>  [<c019584c>] ? sys_stat64+0x19/0x2d
>  [<c0395059>] ? __movsl_is_ok+0x9/0x25
>  [<c039502c>] ? trace_hardirqs_off_thunk+0xc/0x10
>  [<c0103a47>] ? sysenter_exit+0xf/0x1a
>  [<c039501c>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c039501c>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c014d198>] ? trace_hardirqs_on_caller+0x9c/0xce
>  [<c039501c>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c0103a0b>] ? sysenter_do_call+0x12/0x3f
> Code: 00 eb 13 c1 e3 07 83 84 1e 98 00 00 00 01 83 94 1e 9c 00 00 00 00 58 5b 5e 5f 5d c3 55 89 e5 e8 53 4e f7 ff 8b 50 04 8b 40 08 5d <8b> 00 c1 e8 1e 6b c0 50 03 42 4c c3 55 89 e5 57 56 53 e8 35 4e 
> EIP: [<c018faa4>] page_cgroup_zoneinfo+0xf/0x1b SS:ESP 0068:f5e2dcd4
> ---[ end trace 525093d040e4a2a1 ]---
> rc.sysinit used greatest stack depth: 5840 bytes left
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<c018faa4>] page_cgroup_zoneinfo+0xf/0x1b
> *pde = 00000000 
> Oops: 0000 [#2] SMP DEBUG_PAGEALLOC
> last sysfs file: 
> 
> Pid: 1, comm: init Tainted: G      D    (2.6.27 #44341) System Product Name
> EIP: 0060:[<c018faa4>] EFLAGS: 00010246 CPU: 1
> EIP is at page_cgroup_zoneinfo+0xf/0x1b
> EAX: 00000000 EBX: 00000003 ECX: 00000002 EDX: c199ae00
> ESI: c2c7d8ac EDI: c199ae0c EBP: f704dbb0 ESP: f704db8c
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process init (pid: 1, ti=f704c000 task=f7050000 task.ti=f704c000)
> Stack:
>  c019027a 00000010 00120050 c199ae0c 00000005 f704dbec c1babbc8 f5d50000
>  c1babbc8 f704dbd0 c0190993 00000000 00000000 00120050 c1babbc8 f704dd68
>  f6c24868 f704dbec c0170cbd 0041a803 00120050 c1babbc8 f704dd68 00000000
> Call Trace:
>  [<c019027a>] ? mem_cgroup_charge_common+0x149/0x1c4
>  [<c0190993>] ? mem_cgroup_cache_charge+0x81/0x8f
>  [<c0170cbd>] ? add_to_page_cache_locked+0x34/0xc9
>  [<c0170d7a>] ? add_to_page_cache_lru+0x28/0x63
>  [<c01713e3>] ? find_or_create_page+0x44/0x67
>  [<c01abd12>] ? __getblk+0xff/0x1d1
>  [<c01f88ca>] ? sb_getblk+0x16/0x18
>  [<c01f992c>] ? ext3_getblk+0x65/0x111
>  [<c01f7fc5>] ? constant_test_bit+0x9/0x20
>  [<c01fbc5a>] ? dx_root_limit+0x8/0x1b
>  [<c01f99f1>] ? ext3_bread+0x19/0x69
>  [<c01fc765>] ? ext3_find_entry+0x121/0x52a
>  [<c018d3c3>] ? kmem_cache_alloc+0x95/0xd4
>  [<c018d3c3>] ? kmem_cache_alloc+0x95/0xd4
>  [<c014d1d5>] ? trace_hardirqs_on+0xb/0xd
>  [<c01fe55e>] ? ext3_lookup+0x2a/0x93
>  [<c0198f63>] ? do_lookup+0xbb/0x129
>  [<c019a5fd>] ? __link_path_walk+0x47c/0x5a9
>  [<c019a768>] ? path_walk+0x3e/0x77
>  [<c019a8f0>] ? do_path_lookup+0xec/0x125
>  [<c019b2c2>] ? path_lookup+0x17/0x19
>  [<c0a89684>] ? unix_find_other+0x30/0x15d
>  [<c018d3c3>] ? kmem_cache_alloc+0x95/0xd4
>  [<c016f00c>] ? time_hardirqs_on+0x1b/0x1f
>  [<c0394f6a>] ? strlen+0x9/0x1a
>  [<c0a8a989>] ? unix_dgram_connect+0x85/0x150
>  [<c0a14354>] ? sys_connect+0x65/0x7f
>  [<c0395059>] ? __movsl_is_ok+0x9/0x25
>  [<c03951a4>] ? __copy_from_user_ll+0x16/0xd4
>  [<c0a149c8>] ? sys_socketcall+0x91/0x196
>  [<c0103a0b>] ? sysenter_do_call+0x12/0x3f
> Code: 00 eb 13 c1 e3 07 83 84 1e 98 00 00 00 01 83 94 1e 9c 00 00 00 00 58 5b 5e 5f 5d c3 55 89 e5 e8 53 4e f7 ff 8b 50 04 8b 40 08 5d <8b> 00 c1 e8 1e 6b c0 50 03 42 4c c3 55 89 e5 57 56 53 e8 35 4e 
> EIP: [<c018faa4>] page_cgroup_zoneinfo+0xf/0x1b SS:ESP 0068:f704db8c
> ---[ end trace 525093d040e4a2a1 ]---
> init used greatest stack depth: 5036 bytes left
> Kernel panic - not syncing: Attempted to kill init!
> <--------------------
> 
> potential candidates would be:
> 
>  52d4b9a: memcg: allocate all page_cgroup at boot
>  c05555b: memcg: atomic ops for page_cgroup->flags
>  addb9ef: memcg: optimize per-cpu statistics
>  b7abea9: memcg: make page->mapping NULL before uncharge
>  7b85412: Unevictable LRU Page Statistics
>  894bc31: Unevictable LRU Infrastructure
>  4f98a2f: vmscan: split LRU lists into anon & file sets
>  b69408e: vmscan: Use an indexed array for LRU variables
> 
> is this known, or should i try to bisect? It's reproducible.
> Config attached.
> 
> bad:   a9b6148: USB: Fix unused label warnings in drivers/usb/host/ehci-hcd.c
> good:  c813b4e: Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/
>
yes,now chasing. and have found

 page_cgroup->page is NULL because of unknown reason.

 page_cgroup is allocated at boot as an array and page_cgroup->page is
 initialized once as
 page_cgroup->page = pfn_to_page(page);

 But page_cgroup->page is NULL...at failure..

please try cgroup_disable=memory boot option as a trial.

Thanks,
-Kame

