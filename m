Return-Path: <linux-kernel-owner+w=401wt.eu-S1759082AbXJXNZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082AbXJXNZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 09:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757401AbXJXNZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 09:25:47 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:55792 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398AbXJXNZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 09:25:46 -0400
Subject: 2.6.24-rc1 fails with lockup and BUG:
From: Romano Giannetti <romanol@upcomillas.es>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 24 Oct 2007 15:25:44 +0200
Message-Id: <1193232344.32208.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

2.6.23-rc1 fails for me. I have the sensation it is network-related, but
I am not sure, so I send this message just to the list. 
This same failure was present in git-5734-gd85714d, I sent
a message to the list but it seems it never arrived. I hope this will
pass through. My system is a toshiba satellite A305-S5077, dual core pentium.

The symptoms are quite strange. At boot, NetworkManager fails to activate
my eth0 (r8169). Just stopping/restarting NM will make it works.

Then, after one or two or maximum three suspend to ram and resume that
works, all go awry. Notice that I do not know if the s2ram is the cause, or
simply the way to accelerate the bug.

The suspend-to-ram will fail with a messages: 

"gnome-power-manager: (romano) DBUS timed out, but recovering"

and a number of processes go into D state (please find their sysrq-t traces
few lines down). Now I cannot create new windows, nor doing sudo (sudo
anything will go into D limbo), and not even a clean shutdown. Trying that
the system loops forever saying: 

BUG: soft lockup - CPU#0 stuck for 11s! [ifconfig: 7481]

and sysrq-b is the only option. 

Complete dmesg, config, etc at:
http://www.dea.icai.upcomillas.es/romano/linux/info/2624rc1_1/

Thanks, 

	Romano 

PS sorry for the disclaimer, I cannot stop it (¡!) 

nmbd          D ca9cbea4     0  5464      1
       c256eaa0 00000086 00000002 ca9cbea4 ca9cbe9c 00000000 c256ebdc c17fba80 
       c250e900 c0426080 c0426080 c22f67d0 c01773a3 00000010 c0426080 00013bab 
       00000000 000000ff 00000000 00000000 00000000 c03bc514 c03bc51c c03bc518 
Call Trace:
 [cache_alloc_refill+115/1280] cache_alloc_refill+0x73/0x500
 [__mutex_lock_slowpath+85/144] __mutex_lock_slowpath+0x55/0x90
 [mutex_lock+20/32] mutex_lock+0x14/0x20
 [sock_ioctl+0/560] sock_ioctl+0x0/0x230
 [dev_ioctl+200/1312] dev_ioctl+0xc8/0x520
 [sock_init_data+108/384] sock_init_data+0x6c/0x180
 [inet_create+413/832] inet_create+0x19d/0x340
 [inotify_d_instantiate+24/128] inotify_d_instantiate+0x18/0x80
 [d_alloc+265/400] d_alloc+0x109/0x190
 [d_instantiate+59/80] d_instantiate+0x3b/0x50
 [udp_ioctl+0/160] udp_ioctl+0x0/0xa0
 [inet_ioctl+58/192] inet_ioctl+0x3a/0xc0
 [sock_ioctl+207/560] sock_ioctl+0xcf/0x230
 [sock_ioctl+0/560] sock_ioctl+0x0/0x230
 [do_ioctl+43/144] do_ioctl+0x2b/0x90
 [sys_socket+41/80] sys_socket+0x29/0x50
 [vfs_ioctl+92/656] vfs_ioctl+0x5c/0x290
 [sys_ioctl+61/112] sys_ioctl+0x3d/0x70
 [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
 =======================

x-session-man D c2c49d28     0  5774   5246
       c1c4d000 00200082 00000002 c2c49d28 c2c49d20 00000000 c1c4d13c c1803a80 
       c2c25c80 c0426080 c0426080 cab12550 c011d3c2 c03a13a0 c0426080 00016269 
       00000000 000000ff 00000000 00000000 00000000 c03bc514 c03bc51c c03bc518 
Call Trace:
 [enqueue_task+18/48] enqueue_task+0x12/0x30
 [__mutex_lock_slowpath+85/144] __mutex_lock_slowpath+0x55/0x90
 [mutex_lock+20/32] mutex_lock+0x14/0x20
 [rtnetlink_rcv+8/32] rtnetlink_rcv+0x8/0x20
 [netlink_unicast+502/544] netlink_unicast+0x1f6/0x220
 [copy_from_user+46/112] copy_from_user+0x2e/0x70
 [memcpy_fromiovec+56/80] memcpy_fromiovec+0x38/0x50
 [netlink_sendmsg+488/720] netlink_sendmsg+0x1e8/0x2d0
 [__wake_up_sync+65/128] __wake_up_sync+0x41/0x80
 [sock_sendmsg+206/256] sock_sendmsg+0xce/0x100
 [autoremove_wake_function+0/80] autoremove_wake_function+0x0/0x50
 [__wake_up+62/96] __wake_up+0x3e/0x60
 [netlink_insert+197/320] netlink_insert+0xc5/0x140
 [copy_from_user+46/112] copy_from_user+0x2e/0x70
 [sys_sendto+307/384] sys_sendto+0x133/0x180
 [move_addr_to_user+95/112] move_addr_to_user+0x5f/0x70
 [sys_getsockname+205/208] sys_getsockname+0xcd/0xd0
 [__netlink_create+97/176] __netlink_create+0x61/0xb0
 [inotify_d_instantiate+24/128] inotify_d_instantiate+0x18/0x80
 [d_alloc+265/400] d_alloc+0x109/0x190
 [d_instantiate+59/80] d_instantiate+0x3b/0x50
 [sock_attach_fd+128/192] sock_attach_fd+0x80/0xc0
 [sys_socketcall+408/640] sys_socketcall+0x198/0x280
 [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
 [clip_device_event+16/160] clip_device_event+0x10/0xa0
 =======================

ip            D cb573d28     0  7487   7486
       c1dc7aa0 00000082 00000002 cb573d28 cb573d20 00000000 c1dc7bdc c1803a80 
       c27ed740 c0426080 c0426080 001280d2 c218eeb0 c218ef54 c0426080 00010bb9 
       00000000 000000ff 00000000 00000000 00000000 c03bc514 c03bc51c c03bc518 
Call Trace:
 [__mutex_lock_slowpath+85/144] __mutex_lock_slowpath+0x55/0x90
 [mutex_lock+20/32] mutex_lock+0x14/0x20
 [rtnetlink_rcv+8/32] rtnetlink_rcv+0x8/0x20
 [netlink_unicast+502/544] netlink_unicast+0x1f6/0x220
 [copy_from_user+46/112] copy_from_user+0x2e/0x70
 [memcpy_fromiovec+56/80] memcpy_fromiovec+0x38/0x50
 [netlink_sendmsg+488/720] netlink_sendmsg+0x1e8/0x2d0
 [do_lookup+101/400] do_lookup+0x65/0x190
 [sock_sendmsg+206/256] sock_sendmsg+0xce/0x100
 [<f88fc042>] __ext3_journal_dirty_metadata+0x22/0x60 [ext3]
 [<f88de999>] journal_get_write_access+0x29/0x40 [jbd]
 [autoremove_wake_function+0/80] autoremove_wake_function+0x0/0x50
 [do_generic_mapping_read+871/1120] do_generic_mapping_read+0x367/0x460
 [file_read_actor+0/272] file_read_actor+0x0/0x110
 [current_fs_time+19/32] current_fs_time+0x13/0x20
 [touch_atime+122/288] touch_atime+0x7a/0x120
 [find_lock_page+47/160] find_lock_page+0x2f/0xa0
 [copy_from_user+46/112] copy_from_user+0x2e/0x70
 [sys_sendto+307/384] sys_sendto+0x133/0x180
 [__do_fault+423/896] __do_fault+0x1a7/0x380
 [unmap_vmas+847/1360] unmap_vmas+0x34f/0x550
 [handle_mm_fault+248/1536] handle_mm_fault+0xf8/0x600
 [sys_socketcall+408/640] sys_socketcall+0x198/0x280
 [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
 =======================
ip            D c1c033c0     0  7506   5140
       c1c47000 00000082 c1c033c0 c1c033c0 c0181c11 c210bc6c c1c4713c c1803a80 
       c2d99c80 c0426080 c0426080 c2cc1e00 c21da65c 00000000 c0426080 54652911 
       c3d936bc c2174f28 f88ff2e9 c2174f28 c019af72 c03bc514 c03bc51c c03bc518 
Call Trace:
 [permission+97/256] permission+0x61/0x100
 [__find_get_block+130/400] __find_get_block+0x82/0x190
 [__mutex_lock_slowpath+85/144] __mutex_lock_slowpath+0x55/0x90
 [mutex_lock+20/32] mutex_lock+0x14/0x20
 [rtnetlink_rcv+8/32] rtnetlink_rcv+0x8/0x20
 [netlink_unicast+502/544] netlink_unicast+0x1f6/0x220
 [copy_from_user+46/112] copy_from_user+0x2e/0x70
 [memcpy_fromiovec+56/80] memcpy_fromiovec+0x38/0x50
 [netlink_sendmsg+488/720] netlink_sendmsg+0x1e8/0x2d0
 [sock_sendmsg+206/256] sock_sendmsg+0xce/0x100
 [<f88fc042>] __ext3_journal_dirty_metadata+0x22/0x60 [ext3]
 [<f88de999>] journal_get_write_access+0x29/0x40 [jbd]
 [autoremove_wake_function+0/80] autoremove_wake_function+0x0/0x50
 [<f88de4c2>] journal_stop+0xf2/0x1a0 [jbd]
 [prio_tree_insert+485/592] prio_tree_insert+0x1e5/0x250
 [__wake_up+62/96] __wake_up+0x3e/0x60
 [find_lock_page+47/160] find_lock_page+0x2f/0xa0
 [copy_from_user+46/112] copy_from_user+0x2e/0x70
 [sys_sendto+307/384] sys_sendto+0x133/0x180
 [__do_fault+423/896] __do_fault+0x1a7/0x380
 [__alloc_pages+79/880] __alloc_pages+0x4f/0x370
 [handle_mm_fault+248/1536] handle_mm_fault+0xf8/0x600
 [sys_socketcall+408/640] sys_socketcall+0x198/0x280
 [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
 [clip_device_event+16/160] clip_device_event+0x10/0xa0
 =======================
sudo          D c1c033c0     0  7530   6462
       cacfdaa0 00000086 c1c033c0 c1c033c0 c0181c11 c210bc6c cacfdbdc c17fba80 
       c2c25900 c0426080 c0426080 c2cc1e00 c21e69dc 00000000 c0426080 db0505f3 
       c3d937fc c2174f28 f88ff2e9 c2174f28 c019af72 c03bc514 c03bc51c c03bc518 
Call Trace:
 [permission+97/256] permission+0x61/0x100
 [__find_get_block+130/400] __find_get_block+0x82/0x190
 [__mutex_lock_slowpath+85/144] __mutex_lock_slowpath+0x55/0x90
 [mutex_lock+20/32] mutex_lock+0x14/0x20
 [rtnetlink_rcv+8/32] rtnetlink_rcv+0x8/0x20
 [netlink_unicast+502/544] netlink_unicast+0x1f6/0x220
 [copy_from_user+46/112] copy_from_user+0x2e/0x70
 [memcpy_fromiovec+56/80] memcpy_fromiovec+0x38/0x50
 [netlink_sendmsg+488/720] netlink_sendmsg+0x1e8/0x2d0
 [do_lookup+101/400] do_lookup+0x65/0x190
 [sock_sendmsg+206/256] sock_sendmsg+0xce/0x100
 [<f88fc042>] __ext3_journal_dirty_metadata+0x22/0x60 [ext3]
 [<f88de999>] journal_get_write_access+0x29/0x40 [jbd]
 [mntput_no_expire+27/128] mntput_no_expire+0x1b/0x80
 [autoremove_wake_function+0/80] autoremove_wake_function+0x0/0x50
 [__wake_up+62/96] __wake_up+0x3e/0x60
 [find_lock_page+47/160] find_lock_page+0x2f/0xa0
 [copy_from_user+46/112] copy_from_user+0x2e/0x70
 [sys_sendto+307/384] sys_sendto+0x133/0x180
 [__do_fault+423/896] __do_fault+0x1a7/0x380
 [handle_mm_fault+248/1536] handle_mm_fault+0xf8/0x600
 [sys_socketcall+408/640] sys_socketcall+0x198/0x280
 [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
 =======================
   
   


--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
