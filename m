Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbXEAORk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbXEAORk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 10:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbXEAORk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 10:17:40 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1533 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbXEAORS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:17:18 -0400
Message-ID: <46374BEB.6080900@xs4all.nl>
Date: Tue, 01 May 2007 16:17:15 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: "circular locking dependency detected" while doing cp   was Re: Found
 this in my logs
References: <462F7637.3080506@xs4all.nl> <462F8DCA.2070404@xs4all.nl>
In-Reply-To: <462F8DCA.2070404@xs4all.nl>
X-Enigmail-Version: 0.95.0
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel wrote:
> Udo van den Heuvel wrote:
>> Apr 25 17:28:18 epia kernel: [ INFO: possible circular locking
>> dependency detected ]
>> Apr 25 17:28:18 epia kernel: 2.6.20.1 #8
> [cut]
> 
> I think I was copying a not so large file to my windoze box. The cp took
> relatively long and afterwards I noticed the logged things.
> Do I need to post this in bugzilla?
> 
> 
Hello I made a bugzilla entry:
http://bugzilla.kernel.org/show_bug.cgi?id=8377
I also changed the title of this thred to reflect the contents a bit better.

After I did a cp over to a cifs share on a windoze box which took
unusually long I found the stuff below in my logs. How to fix?
What should I add to the bugzilla entry to facilitate?

Apr 25 17:28:18 epia kernel:
Apr 25 17:28:18 epia kernel:
=======================================================
Apr 25 17:28:18 epia kernel: [ INFO: possible circular locking
dependency detected ]
Apr 25 17:28:18 epia kernel: 2.6.20.1 #8
Apr 25 17:28:18 epia kernel:
-------------------------------------------------------
Apr 25 17:28:18 epia kernel: cp/30380 is trying to acquire lock:
Apr 25 17:28:18 epia kernel:  (sk_lock-AF_INET){--..}, at:
[tcp_sendmsg+22/2523] tcp_sendmsg+0x16/0x9db
Apr 25 17:28:18 epia kernel:  (sk_lock-AF_INET){--..}, at: [<c02b8918>]
tcp_sendmsg+0x16/0x9db
Apr 25 17:28:18 epia kernel:
Apr 25 17:28:18 epia kernel: but task is already holding lock:
Apr 25 17:28:18 epia kernel:  (&inode->i_alloc_sem){--..}, at:
[notify_change+241/732] notify_change+0xf1/0x2dc
Apr 25 17:28:18 epia kernel:  (&inode->i_alloc_sem){--..}, at:
[<c0166719>] notify_change+0xf1/0x2dc
Apr 25 17:28:18 epia kernel:
Apr 25 17:28:18 epia kernel: which lock already depends on the new lock.
Apr 25 17:28:19 epia kernel:
Apr 25 17:28:19 epia kernel:
Apr 25 17:28:19 epia kernel: the existing dependency chain (in reverse
order) is:
Apr 25 17:28:19 epia kernel:
Apr 25 17:28:19 epia kernel: -> #3 (&inode->i_alloc_sem){--..}:
Apr 25 17:28:19 epia kernel:        [__lock_acquire+2307/2616]
__lock_acquire+0x903/0xa38
Apr 25 17:28:19 epia kernel:        [<c012b1f4>] __lock_acquire+0x903/0xa38
Apr 25 17:28:19 epia kernel:        [lock_acquire+104/130]
lock_acquire+0x68/0x82
Apr 25 17:28:19 epia kernel:        [<c012b391>] lock_acquire+0x68/0x82
Apr 25 17:28:19 epia kernel:        [down_write+58/83] down_write+0x3a/0x53
Apr 25 17:28:19 epia kernel:        [<c0126fb7>] down_write+0x3a/0x53
Apr 25 17:28:19 epia kernel:        [notify_change+241/732]
notify_change+0xf1/0x2dc
Apr 25 17:28:19 epia kernel:        [<c0166719>] notify_change+0xf1/0x2dc
Apr 25 17:28:19 epia kernel:        [do_truncate+83/108]
do_truncate+0x53/0x6c
Apr 25 17:28:19 epia kernel:        [<c0153572>] do_truncate+0x53/0x6c
Apr 25 17:28:19 epia kernel:        [may_open+442/514] may_open+0x1ba/0x202
Apr 25 17:28:19 epia kernel:        [<c015bfda>] may_open+0x1ba/0x202
Apr 25 17:28:19 epia kernel:        [open_namei+639/1455]
open_namei+0x27f/0x5af
Apr 25 17:28:19 epia kernel:        [<c015df44>] open_namei+0x27f/0x5af
Apr 25 17:28:19 epia kernel:        [do_filp_open+38/59]
do_filp_open+0x26/0x3b
Apr 25 17:28:19 epia kernel:        [<c01532d7>] do_filp_open+0x26/0x3b
Apr 25 17:28:19 epia kernel:        [do_sys_open+67/194]
do_sys_open+0x43/0xc2
Apr 25 17:28:19 epia kernel:        [<c015332f>] do_sys_open+0x43/0xc2
Apr 25 17:28:19 epia kernel:        [sys_open+28/30] sys_open+0x1c/0x1e
Apr 25 17:28:19 epia kernel:        [<c01533e6>] sys_open+0x1c/0x1e
Apr 25 17:28:19 epia kernel:        [syscall_call+7/11] syscall_call+0x7/0xb
Apr 25 17:28:19 epia kernel:        [<c0102af0>] syscall_call+0x7/0xb
Apr 25 17:28:19 epia kernel:        [<ffffffff>] 0xffffffff
Apr 25 17:28:19 epia kernel:
Apr 25 17:28:19 epia kernel: -> #2 (&sysfs_inode_imutex_key){--..}:
Apr 25 17:28:19 epia kernel:        [__lock_acquire+2307/2616]
__lock_acquire+0x903/0xa38
Apr 25 17:28:19 epia kernel:        [<c012b1f4>] __lock_acquire+0x903/0xa38
Apr 25 17:28:19 epia kernel:        [lock_acquire+104/130]
lock_acquire+0x68/0x82
Apr 25 17:28:19 epia kernel:        [<c012b391>] lock_acquire+0x68/0x82
Apr 25 17:28:19 epia kernel:        [__mutex_lock_slowpath+220/614]
__mutex_lock_slowpath+0xdc/0x266
Apr 25 17:28:19 epia kernel:        [<c02ea424>]
__mutex_lock_slowpath+0xdc/0x266
Apr 25 17:28:19 epia kernel:        [mutex_lock+28/31] mutex_lock+0x1c/0x1f
Apr 25 17:28:19 epia kernel:        [<c02ea5ca>] mutex_lock+0x1c/0x1f
Apr 25 17:28:19 epia kernel:        [create_dir+32/406]
create_dir+0x20/0x196
Apr 25 17:28:19 epia kernel:        [<c018a53d>] create_dir+0x20/0x196
Apr 25 17:28:19 epia kernel:        [sysfs_create_dir+70/96]
sysfs_create_dir+0x46/0x60
Apr 25 17:28:19 epia kernel:        [<c018ad9a>] sysfs_create_dir+0x46/0x60
Apr 25 17:28:19 epia kernel:        [kobject_add+207/392]
kobject_add+0xcf/0x188
Apr 25 17:28:19 epia kernel:        [<c01d0f74>] kobject_add+0xcf/0x188
Apr 25 17:28:19 epia kernel:        [class_device_add+158/909]
class_device_add+0x9e/0x38d
Apr 25 17:28:19 epia kernel:        [<c0220c4c>] class_device_add+0x9e/0x38d
Apr 25 17:28:19 epia kernel:        [netdev_register_sysfs+112/117]
netdev_register_sysfs+0x70/0x75
Apr 25 17:28:19 epia kernel:        [<c029dd90>]
netdev_register_sysfs+0x70/0x75
Apr 25 17:28:19 epia kernel:        [register_netdevice+556/740]
register_netdevice+0x22c/0x2e4
Apr 25 17:28:19 epia kernel:        [<c0293d76>]
register_netdevice+0x22c/0x2e4
Apr 25 17:28:19 epia kernel:        [register_netdev+64/77]
register_netdev+0x40/0x4d
Apr 25 17:28:19 epia kernel:        [<c0294eb4>] register_netdev+0x40/0x4d
Apr 25 17:28:19 epia kernel:        [rhine_init_one+1171/1616]
rhine_init_one+0x493/0x650
Apr 25 17:28:19 epia kernel:        [<c0225ae5>] rhine_init_one+0x493/0x650
Apr 25 17:28:19 epia kernel:        [pci_device_probe+57/91]
pci_device_probe+0x39/0x5b
Apr 25 17:28:19 epia kernel:        [<c01dfab8>] pci_device_probe+0x39/0x5b
Apr 25 17:28:19 epia kernel:        [really_probe+127/258]
really_probe+0x7f/0x102
Apr 25 17:28:19 epia kernel:        [<c02201da>] really_probe+0x7f/0x102
Apr 25 17:28:19 epia kernel:        [driver_probe_device+149/161]
driver_probe_device+0x95/0xa1
Apr 25 17:28:19 epia kernel:        [<c02202f2>]
driver_probe_device+0x95/0xa1
Apr 25 17:28:19 epia kernel:        [__driver_attach+106/161]
__driver_attach+0x6a/0xa1
Apr 25 17:28:19 epia kernel:        [<c02203fd>] __driver_attach+0x6a/0xa1
Apr 25 17:28:19 epia kernel:        [bus_for_each_dev+54/91]
bus_for_each_dev+0x36/0x5b
Apr 25 17:28:19 epia kernel:        [<c021f809>] bus_for_each_dev+0x36/0x5b
Apr 25 17:28:19 epia kernel:        [driver_attach+25/27]
driver_attach+0x19/0x1b
Apr 25 17:28:19 epia kernel:        [<c022008c>] driver_attach+0x19/0x1b
Apr 25 17:28:19 epia kernel:        [bus_add_driver+106/368]
bus_add_driver+0x6a/0x170
Apr 25 17:28:19 epia kernel:        [<c021faf9>] bus_add_driver+0x6a/0x170
Apr 25 17:28:19 epia kernel:        [driver_register+121/126]
driver_register+0x79/0x7e
Apr 25 17:28:19 epia kernel:        [<c0220608>] driver_register+0x79/0x7e
Apr 25 17:28:19 epia kernel:        [__pci_register_driver+117/162]
__pci_register_driver+0x75/0xa2
Apr 25 17:28:19 epia kernel:        [<c01dfc39>]
__pci_register_driver+0x75/0xa2
Apr 25 17:28:19 epia kernel:        [rhine_init+15/17] rhine_init+0xf/0x11
Apr 25 17:28:19 epia kernel:        [<c03f3425>] rhine_init+0xf/0x11
Apr 25 17:28:19 epia kernel:        [init+149/573] init+0x95/0x23d
Apr 25 17:28:19 epia kernel:        [<c01003ee>] init+0x95/0x23d
Apr 25 17:28:19 epia kernel:        [kernel_thread_helper+7/16]
kernel_thread_helper+0x7/0x10
Apr 25 17:28:19 epia kernel:        [<c0103ca7>]
kernel_thread_helper+0x7/0x10
Apr 25 17:28:19 epia kernel:        [<ffffffff>] 0xffffffff
Apr 25 17:28:19 epia kernel:
Apr 25 17:28:19 epia kernel: -> #1 (rtnl_mutex){--..}:
Apr 25 17:28:19 epia kernel:        [__lock_acquire+2307/2616]
__lock_acquire+0x903/0xa38
Apr 25 17:28:19 epia kernel:        [<c012b1f4>] __lock_acquire+0x903/0xa38
Apr 25 17:28:19 epia kernel:        [lock_acquire+104/130]
lock_acquire+0x68/0x82
Apr 25 17:28:19 epia kernel:        [<c012b391>] lock_acquire+0x68/0x82
Apr 25 17:28:19 epia kernel:        [__mutex_lock_slowpath+220/614]
__mutex_lock_slowpath+0xdc/0x266
Apr 25 17:28:19 epia kernel:        [<c02ea424>]
__mutex_lock_slowpath+0xdc/0x266
Apr 25 17:28:19 epia kernel:        [mutex_lock+28/31] mutex_lock+0x1c/0x1f
Apr 25 17:28:19 epia kernel:        [<c02ea5ca>] mutex_lock+0x1c/0x1f
Apr 25 17:28:19 epia kernel:        [rtnl_lock+13/15] rtnl_lock+0xd/0xf
Apr 25 17:28:19 epia kernel:        [<c029b5fd>] rtnl_lock+0xd/0xf
Apr 25 17:28:19 epia kernel:        [ip_mc_join_group+44/201]
ip_mc_join_group+0x2c/0xc9
Apr 25 17:28:19 epia kernel:        [<c02d3a88>] ip_mc_join_group+0x2c/0xc9
Apr 25 17:28:19 epia kernel:        [ip_setsockopt+1607/2466]
ip_setsockopt+0x647/0x9a2
Apr 25 17:28:19 epia kernel:        [<c02b51f6>] ip_setsockopt+0x647/0x9a2
Apr 25 17:28:19 epia kernel:        [udp_setsockopt+67/74]
udp_setsockopt+0x43/0x4a
Apr 25 17:28:19 epia kernel:        [<c02caa0c>] udp_setsockopt+0x43/0x4a
Apr 25 17:28:19 epia kernel:        [sock_common_setsockopt+30/36]
sock_common_setsockopt+0x1e/0x24
Apr 25 17:28:19 epia kernel:        [<c028ccae>]
sock_common_setsockopt+0x1e/0x24
Apr 25 17:28:19 epia kernel:        [sys_setsockopt+123/151]
sys_setsockopt+0x7b/0x97
Apr 25 17:28:19 epia kernel:        [<c028b45a>] sys_setsockopt+0x7b/0x97
Apr 25 17:28:19 epia kernel:        [sys_socketcall+488/577]
sys_socketcall+0x1e8/0x241
Apr 25 17:28:19 epia kernel:        [<c028c9c7>] sys_socketcall+0x1e8/0x241
Apr 25 17:28:19 epia kernel:        [syscall_call+7/11] syscall_call+0x7/0xb
Apr 25 17:28:19 epia kernel:        [<c0102af0>] syscall_call+0x7/0xb
Apr 25 17:28:19 epia kernel:        [<ffffffff>] 0xffffffff
Apr 25 17:28:19 epia kernel:
Apr 25 17:28:19 epia kernel: -> #0 (sk_lock-AF_INET){--..}:
Apr 25 17:28:19 epia kernel:        [__lock_acquire+2052/2616]
__lock_acquire+0x804/0xa38
Apr 25 17:28:19 epia kernel:        [<c012b0f5>] __lock_acquire+0x804/0xa38
Apr 25 17:28:19 epia kernel:        [lock_acquire+104/130]
lock_acquire+0x68/0x82
Apr 25 17:28:19 epia kernel:        [<c012b391>] lock_acquire+0x68/0x82
Apr 25 17:28:19 epia kernel:        [lock_sock_nested+186/199]
lock_sock_nested+0xba/0xc7
Apr 25 17:28:19 epia kernel:        [<c028d3d7>] lock_sock_nested+0xba/0xc7
Apr 25 17:28:19 epia kernel:        [tcp_sendmsg+22/2523]
tcp_sendmsg+0x16/0x9db
Apr 25 17:28:19 epia kernel:        [<c02b8918>] tcp_sendmsg+0x16/0x9db
Apr 25 17:28:19 epia kernel:        [inet_sendmsg+62/73]
inet_sendmsg+0x3e/0x49
Apr 25 17:28:19 epia kernel:        [<c02d043c>] inet_sendmsg+0x3e/0x49
Apr 25 17:28:19 epia kernel:        [sock_sendmsg+231/260]
sock_sendmsg+0xe7/0x104
Apr 25 17:28:19 epia kernel:        [<c028b89b>] sock_sendmsg+0xe7/0x104
Apr 25 17:28:19 epia kernel:        [kernel_sendmsg+40/55]
kernel_sendmsg+0x28/0x37
Apr 25 17:28:19 epia kernel:        [<c028ca48>] kernel_sendmsg+0x28/0x37
Apr 25 17:28:19 epia kernel:        [pg0+510032686/1067033600]
smb_send+0x92/0x11c [cifs]
Apr 25 17:28:19 epia kernel:        [<deccbb2e>] smb_send+0x92/0x11c [cifs]
Apr 25 17:28:19 epia kernel:        [pg0+510033207/1067033600]
SendReceive+0x17f/0x3dc [cifs]
Apr 25 17:28:19 epia kernel:        [<deccbd37>] SendReceive+0x17f/0x3dc
[cifs]
Apr 25 17:28:19 epia kernel:        [pg0+509966217/1067033600]
CIFSSMBSetEOF+0x1e6/0x229 [cifs]
Apr 25 17:28:19 epia kernel:        [<decbb789>]
CIFSSMBSetEOF+0x1e6/0x229 [cifs]
Apr 25 17:28:19 epia kernel:        [pg0+510014126/1067033600]
cifs_setattr+0x25d/0x79c [cifs]
Apr 25 17:28:19 epia kernel:        [<decc72ae>]
cifs_setattr+0x25d/0x79c [cifs]
Apr 25 17:28:19 epia kernel:        [notify_change+313/732]
notify_change+0x139/0x2dc
Apr 25 17:28:19 epia kernel:        [<c0166761>] notify_change+0x139/0x2dc
Apr 25 17:28:19 epia kernel:        [do_truncate+83/108]
do_truncate+0x53/0x6c
Apr 25 17:28:19 epia kernel:        [<c0153572>] do_truncate+0x53/0x6c
Apr 25 17:28:19 epia kernel:        [may_open+442/514] may_open+0x1ba/0x202
Apr 25 17:28:19 epia kernel:        [<c015bfda>] may_open+0x1ba/0x202
Apr 25 17:28:19 epia kernel:        [open_namei+639/1455]
open_namei+0x27f/0x5af
Apr 25 17:28:19 epia kernel:        [<c015df44>] open_namei+0x27f/0x5af
Apr 25 17:28:19 epia kernel:        [do_filp_open+38/59]
do_filp_open+0x26/0x3b
Apr 25 17:28:19 epia kernel:        [<c01532d7>] do_filp_open+0x26/0x3b
Apr 25 17:28:19 epia kernel:        [do_sys_open+67/194]
do_sys_open+0x43/0xc2
Apr 25 17:28:19 epia kernel:        [<c015332f>] do_sys_open+0x43/0xc2
Apr 25 17:28:19 epia kernel:        [sys_open+28/30] sys_open+0x1c/0x1e
Apr 25 17:28:19 epia kernel:        [<c01533e6>] sys_open+0x1c/0x1e
Apr 25 17:28:19 epia kernel:        [syscall_call+7/11] syscall_call+0x7/0xb
Apr 25 17:28:19 epia kernel:        [<c0102af0>] syscall_call+0x7/0xb
Apr 25 17:28:19 epia kernel:        [<ffffffff>] 0xffffffff
Apr 25 17:28:19 epia kernel:
Apr 25 17:28:19 epia kernel: other info that might help us debug this:
Apr 25 17:28:19 epia kernel:
Apr 25 17:28:19 epia kernel: 2 locks held by cp/30380:
Apr 25 17:28:19 epia kernel:  #0:  (&inode->i_mutex){--..}, at:
[mutex_lock+28/31] mutex_lock+0x1c/0x1f
Apr 25 17:28:19 epia kernel: node->i_mutex){--..}, at: [<c02ea5ca>]
mutex_lock+0x1c/0x1f
Apr 25 17:28:19 epia kernel:  #1:  (&inode->i_alloc_sem){--..}, at:
[notify_change+241/732] notify_change+0xf1/0x2dc
Apr 25 17:28:19 epia kernel:  #1:  (&inode->i_alloc_sem){--..}, at:
[<c0166719>] notify_change+0xf1/0x2dc
Apr 25 17:28:19 epia kernel:
Apr 25 17:28:19 epia kernel: stack backtrace:
Apr 25 17:28:19 epia kernel:  [show_trace_log_lvl+26/47]
show_trace_log_lvl+0x1a/0x2f
Apr 25 17:28:19 epia kernel:  [<c0104003>] show_trace_log_lvl+0x1a/0x2f
Apr 25 17:28:19 epia kernel:  [show_trace+18/20] show_trace+0x12/0x14
Apr 25 17:28:19 epia kernel:  [<c0104656>] show_trace+0x12/0x14
Apr 25 17:28:19 epia kernel:  [dump_stack+22/24] dump_stack+0x16/0x18
Apr 25 17:28:19 epia kernel:  [<c01046f3>] dump_stack+0x16/0x18
Apr 25 17:28:19 epia kernel:  [print_circular_bug_tail+95/104]
print_circular_bug_tail+0x5f/0x68
Apr 25 17:28:19 epia kernel:  [<c0129a7f>] print_circular_bug_tail+0x5f/0x68
Apr 25 17:28:19 epia kernel:  [__lock_acquire+2052/2616]
__lock_acquire+0x804/0xa38
Apr 25 17:28:19 epia kernel:  [<c012b0f5>] __lock_acquire+0x804/0xa38
Apr 25 17:28:19 epia kernel:  [lock_acquire+104/130] lock_acquire+0x68/0x82
Apr 25 17:28:19 epia kernel:  [<c012b391>] lock_acquire+0x68/0x82
Apr 25 17:28:19 epia kernel:  [lock_sock_nested+186/199]
lock_sock_nested+0xba/0xc7
Apr 25 17:28:19 epia kernel:  [<c028d3d7>] lock_sock_nested+0xba/0xc7
Apr 25 17:28:19 epia kernel:  [tcp_sendmsg+22/2523] tcp_sendmsg+0x16/0x9db
Apr 25 17:28:19 epia kernel:  [<c02b8918>] tcp_sendmsg+0x16/0x9db
Apr 25 17:28:19 epia kernel:  [inet_sendmsg+62/73] inet_sendmsg+0x3e/0x49
Apr 25 17:28:19 epia kernel:  [<c02d043c>] inet_sendmsg+0x3e/0x49
Apr 25 17:28:19 epia kernel:  [sock_sendmsg+231/260] sock_sendmsg+0xe7/0x104
Apr 25 17:28:19 epia kernel:  [<c028b89b>] sock_sendmsg+0xe7/0x104
Apr 25 17:28:19 epia kernel:  [kernel_sendmsg+40/55]
kernel_sendmsg+0x28/0x37
Apr 25 17:28:19 epia kernel:  [<c028ca48>] kernel_sendmsg+0x28/0x37
Apr 25 17:28:19 epia kernel:  [pg0+510032686/1067033600]
smb_send+0x92/0x11c [cifs]
Apr 25 17:28:19 epia kernel:  [<deccbb2e>] smb_send+0x92/0x11c [cifs]
Apr 25 17:28:19 epia kernel:  [pg0+510033207/1067033600]
SendReceive+0x17f/0x3dc [cifs]
Apr 25 17:28:19 epia kernel:  [<deccbd37>] SendReceive+0x17f/0x3dc [cifs]
Apr 25 17:28:19 epia kernel:  [pg0+509966217/1067033600]
CIFSSMBSetEOF+0x1e6/0x229 [cifs]
Apr 25 17:28:19 epia kernel:  [<decbb789>] CIFSSMBSetEOF+0x1e6/0x229 [cifs]
Apr 25 17:28:19 epia kernel:  [pg0+510014126/1067033600]
cifs_setattr+0x25d/0x79c [cifs]
Apr 25 17:28:19 epia kernel:  [<decc72ae>] cifs_setattr+0x25d/0x79c [cifs]
Apr 25 17:28:19 epia kernel:  [notify_change+313/732]
notify_change+0x139/0x2dc
Apr 25 17:28:19 epia kernel:  [<c0166761>] notify_change+0x139/0x2dc
Apr 25 17:28:19 epia kernel:  [do_truncate+83/108] do_truncate+0x53/0x6c
Apr 25 17:28:19 epia kernel:  [<c0153572>] do_truncate+0x53/0x6c
Apr 25 17:28:19 epia kernel:  [may_open+442/514] may_open+0x1ba/0x202
Apr 25 17:28:19 epia kernel:  [<c015bfda>] may_open+0x1ba/0x202
Apr 25 17:28:19 epia kernel:  [open_namei+639/1455] open_namei+0x27f/0x5af
Apr 25 17:28:19 epia kernel:  [<c015df44>] open_namei+0x27f/0x5af
Apr 25 17:28:19 epia kernel:  [do_filp_open+38/59] do_filp_open+0x26/0x3b
Apr 25 17:28:19 epia kernel:  [<c01532d7>] do_filp_open+0x26/0x3b
Apr 25 17:28:19 epia kernel:  [do_sys_open+67/194] do_sys_open+0x43/0xc2
Apr 25 17:28:19 epia kernel:  [<c015332f>] do_sys_open+0x43/0xc2
Apr 25 17:28:19 epia kernel:  [sys_open+28/30] sys_open+0x1c/0x1e
Apr 25 17:28:19 epia kernel:  [<c01533e6>] sys_open+0x1c/0x1e
Apr 25 17:28:19 epia kernel:  [syscall_call+7/11] syscall_call+0x7/0xb
Apr 25 17:28:19 epia kernel:  [<c0102af0>] syscall_call+0x7/0xb
Apr 25 17:28:19 epia kernel:  =======================
Apr 25 17:28:19 epia kernel: pwc: Too many ISOC errors, bailing out.
Apr 25 17:28:19 epia last message repeated 5 times

