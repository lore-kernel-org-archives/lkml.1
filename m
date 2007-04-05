Return-Path: <linux-kernel-owner+w=401wt.eu-S1751608AbXDEA4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbXDEA4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbXDEA4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:56:04 -0400
Received: from web32511.mail.mud.yahoo.com ([68.142.207.221]:31347 "HELO
	web32511.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751608AbXDEA4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:56:00 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Apr 2007 20:56:00 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=zMdMzji0LgpET7QrLuHj7UTytVxY/W+DEig75DyrHBO5MUqFP7OnAUicip6KIHIUzZ8TQmrXF1vCC7SN43n53g0NiiKloR5MX0hE1XIYDEJNvqQMs5M9FbgbyVjk/Mid2iCD4kG0mvGTYTH5aiREUkCJWSaldZ1mtA6X2gy1FDw=;
X-YMail-OSG: cJJGUs4VM1kaNCOAwQnMappBMzhsHQnFoNF3qvCxSMQnbRH6GfqnjYX56tyKsqEbiCDCS.5PS8yV5RtG6EfkW.IqtBRVVPRlmW8wcIqzL45C6uWiQxYdI7j4TsO196b9VwuhM8eXexW3TC30JnVFcXWUJg--
Date: Wed, 4 Apr 2007 17:49:19 -0700 (PDT)
From: Pat <patchu1@yahoo.com>
Subject: Invalid operand: kernel BUG at mm/rmap.c:434! and arch/i386/mm/highmem.c:42!)
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <214905.55943.qm@web32511.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running kernel 2.6.9-22.ELsmp on dual Xeon
servers. I've received kernel panics occasionally in
the past, but they are more frequent now as the load
on the system has increased. Below is a capture of the
kernel panic. 

If anything below screams it's coming from a certain
source (defective RAM? Bad application or device
driver?), please let me know as I'm pulling what
little hair I have left out on this one. Suggestions
on what to try would be greatly appreciated. Thanks! 


------------[ cut here ]------------
kernel BUG at mm/rmap.c:434!
invalid operand: 0000 [#1]
SMP 
Modules linked in: fusedriver(U) md5 ipv6 parport_pc
lp parport autofs4 i2c_dev i2c_core sunrpc
dm_multipath button battery ac uhci_hcd ehci_hcd e1000
floppy dm_snapshot dm_zero dm_mirror ext3 jbd dm_mod
3w_9xxx(U) sd_mod scsi_mod
CPU:    5
EIP:    0060:[<c01518c6>]    Not tainted VLI
EFLAGS: 00010202   (2.6.9-22.ELsmp) 
EIP is at page_add_anon_rmap+0xe/0x66
eax: 40000964   ebx: c1800040   ecx: 090a100c   edx:
e5b5a544
esi: d1837e8c   edi: fff25508   ebp: c1800040   esp:
cf12ae40
ds: 007b   es: 007b   ss: 0068
Process check-enqueued- (pid: 17602,
threadinfo=cf12a000 task=f57577b0)
Stack: 40002067 80000000 c014d034 fff29000 40002025
80000000 00000163 e5b5a544 
       f35b9080 00000000 fff25508 fff25508 090a100c
c014d0e2 cc5a2240 00000001 
       090a100c ffffffff ffffffff 00000000 00000000
80000000 00000000 00000000 
Call Trace:
 [<c014d034>] do_anonymous_page+0x19c/0x1db
 [<c014d0e2>] do_no_page+0x6f/0x2f9
 [<c014d503>] handle_mm_fault+0xbd/0x175
 [<c011addb>] do_page_fault+0x1ae/0x5c6
 [<c014e58e>] vma_adjust+0x286/0x2d6
 [<c014e762>] vma_merge+0xe1/0x165
 [<c011d3d5>] finish_task_switch+0x30/0x66
 [<c02cf368>] schedule+0x844/0x87a
 [<c011ac2d>] do_page_fault+0x0/0x5c6
 [<c02d1bab>] error_code+0x2f/0x38
Code: 83 7b 10 00 74 0b 89 ca 89 d8 e8 fb fe ff ff 01
c6 89 d8 e8 ac df fe ff 5b 89 f0 5e c3 56 53 89 c3 8b
00 8b 72 44 f6 c4 08 74 08 <0f> 0b b2 01 ce 52 2e c0
85 f6 75 08 0f 0b b3 01 ce 52 2e c0 8b 
 <0>Fatal exception: panic in 5 seconds
bad: scheduling while atomic!
 [<c02ceb51>] schedule+0x2d/0x87a
 [<c020a293>] poke_blanked_console+0x3d/0x9a
 [<c02096a5>] vt_console_print+0x294/0x2a5
 [<c0129715>] __mod_timer+0x101/0x10b
 [<c02cf8a0>] schedule_timeout+0xd3/0xee
 [<c0129fba>] process_timeout+0x0/0x5
 [<c0122320>] printk+0xe/0x11
 [<c0106092>] die+0x15a/0x16b
 [<c01063f5>] do_invalid_op+0xcf/0xf2
 [<f88aa3d6>] ext3_get_inode_loc+0x4f/0x226 [ext3]
 [<c01518c6>] page_add_anon_rmap+0xe/0x66
 [<c011e5b5>] __wake_up+0x29/0x3c
 [<c0142c1b>] __rmqueue+0xc1/0x10c
 [<c0142cc1>] rmqueue_bulk+0x5b/0x65
 [<c0106326>] do_invalid_op+0x0/0xf2
 [<c02d1bab>] error_code+0x2f/0x38
 [<c01518c6>] page_add_anon_rmap+0xe/0x66
 [<c014d034>] do_anonymous_page+0x19c/0x1db
 [<c014d0e2>] do_no_page+0x6f/0x2f9
 [<c014d503>] handle_mm_fault+0xbd/0x175
 [<c011addb>] do_page_fault+0x1ae/0x5c6
 [<c014e58e>] vma_adjust+0x286/0x2d6
 [<c014e762>] vma_merge+0xe1/0x165
 [<c011d3d5>] finish_task_switch+0x30/0x66
 [<c02cf368>] schedule+0x844/0x87a
 [<c011ac2d>] do_page_fault+0x0/0x5c6
 [<c02d1bab>] error_code+0x2f/0x38
------------[ cut here ]------------
kernel BUG at arch/i386/mm/highmem.c:42!
invalid operand: 0000 [#2]
SMP 
Modules linked in: fusedriver(U) md5 ipv6 parport_pc
lp parport autofs4 i2c_dev i2c_core sunrpc
dm_multipath button battery ac uhci_hcd ehci_hcd e1000
floppy dm_snapshot dm_zero dm_mirror ext3 jbd dm_mod
3w_9xxx(U) sd_mod scsi_mod
CPU:    5
EIP:    0060:[<c011c6e6>]    Not tainted VLI
EFLAGS: 00010286   (2.6.9-22.ELsmp) 
EIP is at kmap_atomic+0x73/0x178
eax: c000a928   ebx: 80000000   ecx: 90b52163   edx:
000000c4
esi: f467a380   edi: d898bbe8   ebp: c000af48   esp:
eee66e7c
ds: 007b   es: 007b   ss: 0068
Process search_pe (pid: 17511, threadinfo=eee66000
task=f511e030)
Stack: 00000001 00000000 f5646900 00000001 00000000
00000000 00000000 00000000 
       00000000 fff25000 c182d280 e19cb630 f467a380
d898bbe8 00000c00 c014b006 
       e19cb630 e19cb630 e19cb630 f467a3b0 d898bbe8
afb80004 c014d4d1 f3aae22c 
Call Trace:
 [<c014b006>] pte_alloc_map+0xd9/0xe2
 [<c014d4d1>] handle_mm_fault+0x8b/0x175
 [<c011addb>] do_page_fault+0x1ae/0x5c6
 [<c014e7d7>] vma_merge+0x156/0x165
 [<c014ec91>] do_mmap_pgoff+0x3cd/0x666
 [<c014ee2c>] do_mmap_pgoff+0x568/0x666
 [<c010b67f>] sys_mmap2+0x7e/0xaf
 [<c011ac2d>] do_page_fault+0x0/0x5c6
 [<c02d1bab>] error_code+0x2f/0x38
 [<c02d007b>] __lock_text_end+0x11a/0x100f
Code: c8 40 c0 01 c2 8d 42 16 c1 e0 0c 29 c1 89 4c 24
24 8d 04 d5 00 00 00 00 89 e9 29 c1 89 c8 8b 09 8b 58
04 85 c9 75 04 85 db 74 08 <0f> 0b 2a 00 04 27 2e c0
8b 5c 24 28 8b 0d 78 29 32 c0 8b 03 89 
 <0>Fatal exception: panic in 5 seconds
bad: scheduling while atomic!
 [<c02ceb51>] schedule+0x2d/0x87a
 [<c020a293>] poke_blanked_console+0x3d/0x9a
 [<c02096a5>] vt_console_print+0x294/0x2a5
 [<c0129715>] __mod_timer+0x101/0x10b
 [<c02cf8a0>] schedule_timeout+0xd3/0xee
 [<c0129fba>] process_timeout+0x0/0x5
 [<c0122320>] printk+0xe/0x11
 [<c0106092>] die+0x15a/0x16b
 [<c01063f5>] do_invalid_op+0xcf/0xf2
 [<c011ffbe>] autoremove_wake_function+0xd/0x2d
 [<c011c6e6>] kmap_atomic+0x73/0x178
 [<c011e5b5>] __wake_up+0x29/0x3c
 [<c0278dc3>] __kfree_skb+0xf4/0xf7
 [<c02cbcad>] unix_stream_recvmsg+0x2cc/0x39d
 [<c0106326>] do_invalid_op+0x0/0xf2
 [<c02d1bab>] error_code+0x2f/0x38
 [<c011c6e6>] kmap_atomic+0x73/0x178
 [<c014b006>] pte_alloc_map+0xd9/0xe2
 [<c014d4d1>] handle_mm_fault+0x8b/0x175
 [<c011addb>] do_page_fault+0x1ae/0x5c6
 [<c014e7d7>] vma_merge+0x156/0x165
 [<c014ec91>] do_mmap_pgoff+0x3cd/0x666
 [<c014ee2c>] do_mmap_pgoff+0x568/0x666
 [<c010b67f>] sys_mmap2+0x7e/0xaf
 [<c011ac2d>] do_page_fault+0x0/0x5c6
 [<c02d1bab>] error_code+0x2f/0x38
 [<c02d007b>] __lock_text_end+0x11a/0x100f
------------[ cut here ]------------
kernel BUG at arch/i386/mm/highmem.c:42!
invalid operand: 0000 [#3]
SMP 
Modules linked in: fusedriver(U) md5 ipv6 parport_pc
lp parport autofs4 i2c_dev i2c_core sunrpc
dm_multipath button battery ac uhci_hcd ehci_hcd e1000
floppy dm_snapshot dm_zero dm_mirror ext3 jbd dm_mod
3w_9xxx(U) sd_mod scsi_mod
CPU:    5
EIP:    0060:[<c011c6e6>]    Not tainted VLI
EFLAGS: 00010286   (2.6.9-22.ELsmp) 
EIP is at kmap_atomic+0x73/0x178
eax: c000a928   ebx: 80000000   ecx: 90b52163   edx:
000000c4
esi: f5634080   edi: f4c3ddf8   ebp: c000af48   esp:
f560edd0
ds: 007b   es: 007b   ss: 0068
Process irqbalance (pid: 2543, threadinfo=f560e000
task=f4ec8330)
Stack: f7ee1e00 c3802ab8 00000000 e0f6a4b4 f778f478
e0f6a474 e0f6a474 00000000 
       00000000 fff25000 c35d96c0 f7f10ef0 f5634080
f4c3ddf8 00000ff8 c014b006 
       f7f10ef0 f7f10ef0 f7f10ef0 f56340b0 f4c3ddf8
b7fff000 c014d4d1 f54de90c 
Call Trace:
 [<c014b006>] pte_alloc_map+0xd9/0xe2
 [<c014d4d1>] handle_mm_fault+0x8b/0x175
 [<c011addb>] do_page_fault+0x1ae/0x5c6
 [<c016dbc8>] dput+0x34/0x1a7
 [<c0166050>] link_path_walk+0x94/0xbe
 [<c02cf8a7>] schedule_timeout+0xda/0xee
 [<c01c0f8d>] vsnprintf+0x448/0x488
 [<c011ac2d>] do_page_fault+0x0/0x5c6
 [<c02d1bab>] error_code+0x2f/0x38
 [<c01c1c8a>] __copy_to_user_ll+0x30/0x46
 [<c0173e13>] seq_read+0x24a/0x2c2
 [<c0159c61>] vfs_read+0xb6/0xe2
 [<c0159e74>] sys_read+0x3c/0x62
 [<c02d10cf>] syscall_call+0x7/0xb
Code: c8 40 c0 01 c2 8d 42 16 c1 e0 0c 29 c1 89 4c 24
24 8d 04 d5 00 00 00 00 89 e9 29 c1 89 c8 8b 09 8b 58
04 85 c9 75 04 85 db 74 08 <0f> 0b 2a 00 04 27 2e c0
8b 5c 24 28 8b 0d 78 29 32 c0 8b 03 89 
 <0>Fatal exception: panic in 5 seconds
bad: scheduling while atomic!
 [<c02ceb51>] schedule+0x2d/0x87a
 [<c020a293>] poke_blanked_console+0x3d/0x9a
 [<c02096a5>] vt_console_print+0x294/0x2a5
 [<c0129715>] __mod_timer+0x101/0x10b
 [<c02cf8a0>] schedule_timeout+0xd3/0xee
 [<c0129fba>] process_timeout+0x0/0x5
 [<c0122320>] printk+0xe/0x11
 [<c0106092>] die+0x15a/0x16b
 [<c01063f5>] do_invalid_op+0xcf/0xf2
 [<c0142c1b>] __rmqueue+0xc1/0x10c
 [<c011c6e6>] kmap_atomic+0x73/0x178
 [<c0142cc1>] rmqueue_bulk+0x5b/0x65
 [<c0143050>] buffered_rmqueue+0x17d/0x1a5
 [<c0106326>] do_invalid_op+0x0/0xf2
 [<c02d1bab>] error_code+0x2f/0x38
 [<c011c6e6>] kmap_atomic+0x73/0x178
 [<c014b006>] pte_alloc_map+0xd9/0xe2
 [<c014d4d1>] handle_mm_fault+0x8b/0x175
 [<c011addb>] do_page_fault+0x1ae/0x5c6
 [<c016dbc8>] dput+0x34/0x1a7
 [<c0166050>] link_path_walk+0x94/0xbe
 [<c02cf8a7>] schedule_timeout+0xda/0xee
 [<c01c0f8d>] vsnprintf+0x448/0x488
 [<c011ac2d>] do_page_fault+0x0/0x5c6
 [<c02d1bab>] error_code+0x2f/0x38
 [<c01c1c8a>] __copy_to_user_ll+0x30/0x46
 [<c0173e13>] seq_read+0x24a/0x2c2
 [<c0159c61>] vfs_read+0xb6/0xe2
 [<c0159e74>] sys_read+0x3c/0x62
 [<c02d10cf>] syscall_call+0x7/0xb
------------[ cut here ]------------
kernel BUG at arch/i386/mm/highmem.c:42!
invalid operand: 0000 [#4]
SMP 
Modules linked in: fusedriver(U) md5 ipv6 parport_pc
lp parport autofs4 i2c_dev i2c_core sunrpc
dm_multipath button battery ac uhci_hcd ehci_hcd e1000
floppy dm_snapshot dm_zero dm_mirror ext3 jbd dm_mod
3w_9xxx(U) sd_mod scsi_mod
CPU:    5
EIP:    0060:[<c011c6e6>]    Not tainted VLI
EFLAGS: 00010286   (2.6.9-22.ELsmp) 
EIP is at kmap_atomic+0x73/0x178
eax: c000a928   ebx: 80000000   ecx: 90b52163   edx:
000000c4
esi: f56a5980   edi: c847cbe8   ebp: c000af48   esp:
d8236e7c
ds: 007b   es: 007b   ss: 0068
Process search_pe (pid: 17600, threadinfo=d8236000
task=f3a95930)
Stack: 00000001 00000000 ce89ea80 00000001 00000000
00000000 00000000 00000000 
       00000000 fff25000 c3202bc0 f7f10b30 f56a5980
c847cbe8 00000c00 c014b006 
       f7f10b30 f7f10b30 f7f10b30 f56a59b0 c847cbe8
afb80004 c014d4d1 f3a68a6c 
Call Trace:
 [<c014b006>] pte_alloc_map+0xd9/0xe2
 [<c014d4d1>] handle_mm_fault+0x8b/0x175
 [<c011addb>] do_page_fault+0x1ae/0x5c6
 [<c014e7d7>] vma_merge+0x156/0x165
 [<c014ec91>] do_mmap_pgoff+0x3cd/0x666
 [<c014ee2c>] do_mmap_pgoff+0x568/0x666
 [<c010b67f>] sys_mmap2+0x7e/0xaf
 [<c011ac2d>] do_page_fault+0x0/0x5c6
 [<c02d1bab>] error_code+0x2f/0x38
 [<c02d007b>] __lock_text_end+0x11a/0x100f
Code: c8 40 c0 01 c2 8d 42 16 c1 e0 0c 29 c1 89 4c 24
24 8d 04 d5 00 00 00 00 89 e9 29 c1 89 c8 8b 09 8b 58
04 85 c9 75 04 85 db 74 08 <0f> 0b 2a 00 04 27 2e c0
8b 5c 24 28 8b 0d 78 29 32 c0 8b 03 89 
 <0>Fatal exception: panic in 5 seconds
bad: scheduling while atomic!
 [<c02ceb51>] schedule+0x2d/0x87a
 [<c020a293>] poke_blanked_console+0x3d/0x9a
 [<c02096a5>] vt_console_print+0x294/0x2a5
 [<c0129715>] __mod_timer+0x101/0x10b
 [<c02cf8a0>] schedule_timeout+0xd3/0xee
 [<c0129fba>] process_timeout+0x0/0x5
 [<c0122320>] printk+0xe/0x11
 [<c0106092>] die+0x15a/0x16b
 [<c01063f5>] do_invalid_op+0xcf/0xf2
 [<c011ffbe>] autoremove_wake_function+0xd/0x2d
 [<c011c6e6>] kmap_atomic+0x73/0x178
 [<c011e5b5>] __wake_up+0x29/0x3c
 [<c0278dc3>] __kfree_skb+0xf4/0xf7
 [<c02cbcad>] unix_stream_recvmsg+0x2cc/0x39d
 [<c0106326>] do_invalid_op+0x0/0xf2
 [<c02d1bab>] error_code+0x2f/0x38
 [<c011c6e6>] kmap_atomic+0x73/0x178
 [<c014b006>] pte_alloc_map+0xd9/0xe2
 [<c014d4d1>] handle_mm_fault+0x8b/0x175
 [<c011addb>] do_page_fault+0x1ae/0x5c6
 [<c014e7d7>] vma_merge+0x156/0x165
 [<c014ec91>] do_mmap_pgoff+0x3cd/0x666
 [<c014ee2c>] do_mmap_pgoff+0x568/0x666
 [<c010b67f>] sys_mmap2+0x7e/0xaf
 [<c011ac2d>] do_page_fault+0x0/0x5c6
 [<c02d1bab>] error_code+0x2f/0x38
 [<c02d007b>] __lock_text_end+0x11a/0x100f
------------[ cut here ]------------
kernel BUG at arch/i386/mm/highmem.c:42!
invalid operand: 0000 [#5]
SMP 
Modules linked in: fusedriver(U) md5 ipv6 parport_pc
lp parport autofs4 i2c_dev i2c_core sunrpc
dm_multipath button battery ac uhci_hcd ehci_hcd e1000
floppy dm_snapshot dm_zero dm_mirror ext3 jbd dm_mod
3w_9xxx(U) sd_mod scsi_mod
CPU:    5
EIP:    0060:[<c011c6e6>]    Not tainted VLI
EFLAGS: 00010286   (2.6.9-22.ELsmp) 
EIP is at kmap_atomic+0x73/0x178
eax: c000a928   ebx: 80000000   ecx: 90b52163   edx:
000000c4
esi: f4705380   edi: f4d065a8   ebp: c000af48   esp:
f55eee7c
ds: 007b   es: 007b   ss: 0068
Process mysqld (pid: 2882, threadinfo=f55ee000
task=f56c7230)
Stack: 00000057 00000000 f5754b80 00000057 00000001
c0140263 00000000 00000000 
       00000000 fff25000 c295d2a0 f7f10550 f4705380
f4d065a8 000002f8 c014b006 
       f7f10550 f7f10550 f7f10550 f47053b0 f4d065a8
96a5f004 c014d4d1 f3a8f7ac 
Call Trace:
 [<c0140263>] __generic_file_aio_read+0x19f/0x1bd
 [<c014b006>] pte_alloc_map+0xd9/0xe2
 [<c014d4d1>] handle_mm_fault+0x8b/0x175
 [<c011addb>] do_page_fault+0x1ae/0x5c6
 [<c014e1e9>] __vma_link+0x59/0x66
 [<c014e23a>] vma_link+0x44/0xbc
 [<c014ee2c>] do_mmap_pgoff+0x568/0x666
 [<c010b67f>] sys_mmap2+0x7e/0xaf
 [<c011ac2d>] do_page_fault+0x0/0x5c6
 [<c02d1bab>] error_code+0x2f/0x38
 [<c02d007b>] __lock_text_end+0x11a/0x100f
Code: c8 40 c0 01 c2 8d 42 16 c1 e0 0c 29 c1 89 4c 24
24 8d 04 d5 00 00 00 00 89 e9 29 c1 89 c8 8b 09 8b 58
04 85 c9 75 04 85 db 74 08 <0f> 0b 2a 00 04 27 2e c0
8b 5c 24 28 8b 0d 78 29 32 c0 8b 03 89 
 <0>Fatal exception: panic in 5 seconds
bad: scheduling while atomic!
 [<c02ceb51>] schedule+0x2d/0x87a
 [<c020a293>] poke_blanked_console+0x3d/0x9a
 [<c02096a5>] vt_console_print+0x294/0x2a5
 [<c0129715>] __mod_timer+0x101/0x10b
 [<c02cf8a0>] schedule_timeout+0xd3/0xee
 [<c0129fba>] process_timeout+0x0/0x5
 [<c0122320>] printk+0xe/0x11
 [<c0106092>] die+0x15a/0x16b
 [<c01063f5>] do_invalid_op+0xcf/0xf2
 [<c011ffbe>] autoremove_wake_function+0xd/0x2d
 [<c011c6e6>] kmap_atomic+0x73/0x178
 [<c011e5b5>] __wake_up+0x29/0x3c
 [<c0278dc3>] __kfree_skb+0xf4/0xf7
 [<c02cbcad>] unix_stream_recvmsg+0x2cc/0x39d
 [<c0106326>] do_invalid_op+0x0/0xf2
 [<c02d1bab>] error_code+0x2f/0x38
 [<c011c6e6>] kmap_atomic+0x73/0x178
 [<c0140263>] __generic_file_aio_read+0x19f/0x1bd
 [<c014b006>] pte_alloc_map+0xd9/0xe2
 [<c014d4d1>] handle_mm_fault+0x8b/0x175
 [<c011addb>] do_page_fault+0x1ae/0x5c6
 [<c014e1e9>] __vma_link+0x59/0x66
 [<c014e23a>] vma_link+0x44/0xbc
 [<c014ee2c>] do_mmap_pgoff+0x568/0x666
 [<c010b67f>] sys_mmap2+0x7e/0xaf
 [<c011ac2d>] do_page_fault+0x0/0x5c6
 [<c02d1bab>] error_code+0x2f/0x38
 [<c02d007b>] __lock_text_end+0x11a/0x100f
Kernel panic - not syncing: Fatal exception
 


 
____________________________________________________________________________________
Never miss an email again!
Yahoo! Toolbar alerts you the instant new Mail arrives.
http://tools.search.yahoo.com/toolbar/features/mail/
