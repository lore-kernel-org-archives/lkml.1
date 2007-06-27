Return-Path: <linux-kernel-owner+w=401wt.eu-S1763483AbXF0W5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763483AbXF0W5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbXF0W5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:57:12 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2872 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbXF0W5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:57:11 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: akpm@linux-foundation.org, Adrian Bunk <bunk@stusta.de>
Subject: Re: mm snapshot broken-out-2007-06-27-03-28.tar.gz uploaded
Date: Thu, 28 Jun 2007 00:57:07 +0200
User-Agent: KMail/1.9.5
Cc: paulus@samba.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
References: <200706271030.l5RAUgKE015163@imap1.linux-foundation.org>
In-Reply-To: <200706271030.l5RAUgKE015163@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706280057.07481.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	Build problems on iMac G3.

1) allnoconfig results in this:

 CC      arch/powerpc/mm/tlb_32.o
In file included from include/asm/tlb.h:60,
                 from arch/powerpc/mm/tlb_32.c:30:
include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
include/asm-generic/tlb.h: In function 'tlb_remove_page':
include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'
make[1]: *** [arch/powerpc/mm/tlb_32.o] Blad 1
make: *** [arch/powerpc/mm] Blad 2


The patch below fixes that for me.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 arch/powerpc/mm/tlb_32.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.22-rc6-bo-a/arch/powerpc/mm/tlb_32.c	2007-06-27 23:38:49.000000000 +0200
+++ linux-2.6.22-rc6-bo-b/arch/powerpc/mm/tlb_32.c	2007-06-27 23:18:05.000000000 +0200
@@ -26,6 +26,8 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/highmem.h>
+#include <linux/pagemap.h>
+
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 


2) These are conflicts introduced by kernel-sys_nic-should-include-linux-syscallsh.patch

  CC      kernel/sys_ni.o
kernel/sys_ni.c:16: error: conflicting types for 'sys_nfsservctl'
include/linux/syscalls.h:497: error: previous declaration of 'sys_nfsservctl' was here
kernel/sys_ni.c:17: error: conflicting types for 'sys_quotactl'
include/linux/syscalls.h:396: error: previous declaration of 'sys_quotactl' was here
kernel/sys_ni.c:18: error: conflicting types for 'sys_acct'
include/linux/syscalls.h:107: error: previous declaration of 'sys_acct' was here
kernel/sys_ni.c:19: error: conflicting types for 'sys_lookup_dcookie'
include/linux/syscalls.h:394: error: previous declaration of 'sys_lookup_dcookie' was here
kernel/sys_ni.c:20: error: conflicting types for 'sys_swapon'
include/linux/syscalls.h:489: error: previous declaration of 'sys_swapon' was here
kernel/sys_ni.c:21: error: conflicting types for 'sys_swapoff'
include/linux/syscalls.h:490: error: previous declaration of 'sys_swapoff' was here
kernel/sys_ni.c:22: error: conflicting types for 'sys_kexec_load'
include/linux/syscalls.h:167: error: previous declaration of 'sys_kexec_load' was here
kernel/sys_ni.c:24: error: conflicting types for 'sys_init_module'
include/linux/syscalls.h:183: error: previous declaration of 'sys_init_module' was here
kernel/sys_ni.c:25: error: conflicting types for 'sys_delete_module'
include/linux/syscalls.h:185: error: previous declaration of 'sys_delete_module' was here
kernel/sys_ni.c:26: error: conflicting types for 'sys_socketpair'
include/linux/syscalls.h:422: error: previous declaration of 'sys_socketpair' was here
kernel/sys_ni.c:27: error: conflicting types for 'sys_bind'
include/linux/syscalls.h:408: error: previous declaration of 'sys_bind' was here
kernel/sys_ni.c:28: error: conflicting types for 'sys_listen'
include/linux/syscalls.h:424: error: previous declaration of 'sys_listen' was here
kernel/sys_ni.c:29: error: conflicting types for 'sys_accept'
include/linux/syscalls.h:410: error: previous declaration of 'sys_accept' was here
kernel/sys_ni.c:30: error: conflicting types for 'sys_connect'
include/linux/syscalls.h:409: error: previous declaration of 'sys_connect' was here
kernel/sys_ni.c:31: error: conflicting types for 'sys_getsockname'
include/linux/syscalls.h:411: error: previous declaration of 'sys_getsockname' was here
kernel/sys_ni.c:32: error: conflicting types for 'sys_getpeername'
include/linux/syscalls.h:412: error: previous declaration of 'sys_getpeername' was here
kernel/sys_ni.c:33: error: conflicting types for 'sys_sendto'
include/linux/syscalls.h:415: error: previous declaration of 'sys_sendto' was here
kernel/sys_ni.c:34: error: conflicting types for 'sys_send'
include/linux/syscalls.h:413: error: previous declaration of 'sys_send' was here
kernel/sys_ni.c:35: error: conflicting types for 'sys_recvfrom'
include/linux/syscalls.h:419: error: previous declaration of 'sys_recvfrom' was here
kernel/sys_ni.c:36: error: conflicting types for 'sys_recv'
include/linux/syscalls.h:417: error: previous declaration of 'sys_recv' was here
kernel/sys_ni.c:37: error: conflicting types for 'sys_socket'
include/linux/syscalls.h:421: error: previous declaration of 'sys_socket' was here
kernel/sys_ni.c:38: error: conflicting types for 'sys_setsockopt'
include/linux/syscalls.h:405: error: previous declaration of 'sys_setsockopt' was here
kernel/sys_ni.c:39: error: conflicting types for 'sys_getsockopt'
include/linux/syscalls.h:407: error: previous declaration of 'sys_getsockopt' was here
kernel/sys_ni.c:40: error: conflicting types for 'sys_shutdown'
include/linux/syscalls.h:161: error: previous declaration of 'sys_shutdown' was here
kernel/sys_ni.c:41: error: conflicting types for 'sys_sendmsg'
include/linux/syscalls.h:416: error: previous declaration of 'sys_sendmsg' was here
kernel/sys_ni.c:42: error: conflicting types for 'sys_recvmsg'
include/linux/syscalls.h:420: error: previous declaration of 'sys_recvmsg' was here
kernel/sys_ni.c:43: error: conflicting types for 'sys_socketcall'
include/linux/syscalls.h:423: error: previous declaration of 'sys_socketcall' was here
kernel/sys_ni.c:44: error: conflicting types for 'sys_futex'
include/linux/syscalls.h:180: error: previous declaration of 'sys_futex' was here
kernel/sys_ni.c:46: error: conflicting types for 'sys_set_robust_list'
include/linux/syscalls.h:607: error: previous declaration of 'sys_set_robust_list' was here
kernel/sys_ni.c:48: error: conflicting types for 'sys_get_robust_list'
include/linux/syscalls.h:605: error: previous declaration of 'sys_get_robust_list' was here
kernel/sys_ni.c:50: error: conflicting types for 'sys_epoll_create'
include/linux/syscalls.h:429: error: previous declaration of 'sys_epoll_create' was here
kernel/sys_ni.c:51: error: conflicting types for 'sys_epoll_ctl'
include/linux/syscalls.h:431: error: previous declaration of 'sys_epoll_ctl' was here
kernel/sys_ni.c:52: error: conflicting types for 'sys_epoll_wait'
include/linux/syscalls.h:433: error: previous declaration of 'sys_epoll_wait' was here
kernel/sys_ni.c:53: error: conflicting types for 'sys_epoll_pwait'
include/linux/syscalls.h:437: error: previous declaration of 'sys_epoll_pwait' was here
kernel/sys_ni.c:54: error: conflicting types for 'sys_semget'
include/linux/syscalls.h:460: error: previous declaration of 'sys_semget' was here
kernel/sys_ni.c:55: error: conflicting types for 'sys_semop'
include/linux/syscalls.h:462: error: previous declaration of 'sys_semop' was here
kernel/sys_ni.c:56: error: conflicting types for 'sys_semtimedop'
include/linux/syscalls.h:466: error: previous declaration of 'sys_semtimedop' was here
kernel/sys_ni.c:57: error: conflicting types for 'sys_semctl'
include/linux/syscalls.h:463: error: previous declaration of 'sys_semctl' was here
kernel/sys_ni.c:58: error: conflicting types for 'sys_msgget'
include/linux/syscalls.h:453: error: previous declaration of 'sys_msgget' was here
kernel/sys_ni.c:59: error: conflicting types for 'sys_msgsnd'
include/linux/syscalls.h:455: error: previous declaration of 'sys_msgsnd' was here
kernel/sys_ni.c:60: error: conflicting types for 'sys_msgrcv'
include/linux/syscalls.h:457: error: previous declaration of 'sys_msgrcv' was here
kernel/sys_ni.c:61: error: conflicting types for 'sys_msgctl'
include/linux/syscalls.h:458: error: previous declaration of 'sys_msgctl' was here
kernel/sys_ni.c:62: error: conflicting types for 'sys_shmget'
include/linux/syscalls.h:468: error: previous declaration of 'sys_shmget' was here
kernel/sys_ni.c:63: error: conflicting types for 'sys_shmat'
include/linux/syscalls.h:467: error: previous declaration of 'sys_shmat' was here
kernel/sys_ni.c:64: error: conflicting types for 'sys_shmdt'
include/linux/syscalls.h:469: error: previous declaration of 'sys_shmdt' was here
kernel/sys_ni.c:65: error: conflicting types for 'sys_shmctl'
include/linux/syscalls.h:470: error: previous declaration of 'sys_shmctl' was here
kernel/sys_ni.c:66: error: conflicting types for 'sys_mq_open'
include/linux/syscalls.h:472: error: previous declaration of 'sys_mq_open' was here
kernel/sys_ni.c:67: error: conflicting types for 'sys_mq_unlink'
include/linux/syscalls.h:473: error: previous declaration of 'sys_mq_unlink' was here
kernel/sys_ni.c:68: error: conflicting types for 'sys_mq_timedsend'
include/linux/syscalls.h:474: error: previous declaration of 'sys_mq_timedsend' was here
kernel/sys_ni.c:69: error: conflicting types for 'sys_mq_timedreceive'
include/linux/syscalls.h:475: error: previous declaration of 'sys_mq_timedreceive' was here
kernel/sys_ni.c:70: error: conflicting types for 'sys_mq_notify'
include/linux/syscalls.h:476: error: previous declaration of 'sys_mq_notify' was here
kernel/sys_ni.c:71: error: conflicting types for 'sys_mq_getsetattr'
include/linux/syscalls.h:477: error: previous declaration of 'sys_mq_getsetattr' was here
kernel/sys_ni.c:77: error: conflicting types for 'sys_mbind'
include/linux/syscalls.h:538: error: previous declaration of 'sys_mbind' was here
kernel/sys_ni.c:78: error: conflicting types for 'sys_get_mempolicy'
include/linux/syscalls.h:542: error: previous declaration of 'sys_get_mempolicy' was here
kernel/sys_ni.c:79: error: conflicting types for 'sys_set_mempolicy'
include/linux/syscalls.h:520: error: previous declaration of 'sys_set_mempolicy' was here
kernel/sys_ni.c:83: error: conflicting types for 'sys_add_key'
include/linux/syscalls.h:507: error: previous declaration of 'sys_add_key' was here
kernel/sys_ni.c:84: error: conflicting types for 'sys_request_key'
include/linux/syscalls.h:512: error: previous declaration of 'sys_request_key' was here
kernel/sys_ni.c:85: error: conflicting types for 'sys_keyctl'
include/linux/syscalls.h:515: error: previous declaration of 'sys_keyctl' was here
kernel/sys_ni.c:89: error: conflicting types for 'sys_inotify_add_watch'
include/linux/syscalls.h:546: error: previous declaration of 'sys_inotify_add_watch' was here
kernel/sys_ni.c:90: error: conflicting types for 'sys_inotify_rm_watch'
include/linux/syscalls.h:547: error: previous declaration of 'sys_inotify_rm_watch' was here
kernel/sys_ni.c:91: error: conflicting types for 'sys_migrate_pages'
include/linux/syscalls.h:523: error: previous declaration of 'sys_migrate_pages' was here
kernel/sys_ni.c:92: error: conflicting types for 'sys_move_pages'
include/linux/syscalls.h:528: error: previous declaration of 'sys_move_pages' was here
kernel/sys_ni.c:118: error: conflicting types for 'sys_pciconfig_read'
include/linux/syscalls.h:482: error: previous declaration of 'sys_pciconfig_read' was here
kernel/sys_ni.c:119: error: conflicting types for 'sys_pciconfig_write'
include/linux/syscalls.h:485: error: previous declaration of 'sys_pciconfig_write' was here
kernel/sys_ni.c:120: error: conflicting types for 'sys_pciconfig_iobase'
include/linux/syscalls.h:479: error: previous declaration of 'sys_pciconfig_iobase' was here
kernel/sys_ni.c:124: error: conflicting types for 'sys_spu_run'
include/linux/syscalls.h:550: error: previous declaration of 'sys_spu_run' was here
kernel/sys_ni.c:125: error: conflicting types for 'sys_spu_create'
include/linux/syscalls.h:552: error: previous declaration of 'sys_spu_create' was here
kernel/sys_ni.c:128: error: conflicting types for 'sys_mprotect'
include/linux/syscalls.h:267: error: previous declaration of 'sys_mprotect' was here
kernel/sys_ni.c:129: error: conflicting types for 'sys_msync'
include/linux/syscalls.h:274: error: previous declaration of 'sys_msync' was here
kernel/sys_ni.c:130: error: conflicting types for 'sys_mlock'
include/linux/syscalls.h:278: error: previous declaration of 'sys_mlock' was here
kernel/sys_ni.c:131: error: conflicting types for 'sys_munlock'
include/linux/syscalls.h:279: error: previous declaration of 'sys_munlock' was here
kernel/sys_ni.c:132: error: conflicting types for 'sys_mlockall'
include/linux/syscalls.h:280: error: previous declaration of 'sys_mlockall' was here
kernel/sys_ni.c:134: error: conflicting types for 'sys_mincore'
include/linux/syscalls.h:284: error: previous declaration of 'sys_mincore' was here
kernel/sys_ni.c:135: error: conflicting types for 'sys_madvise'
include/linux/syscalls.h:282: error: previous declaration of 'sys_madvise' was here
kernel/sys_ni.c:136: error: conflicting types for 'sys_mremap'
include/linux/syscalls.h:270: error: previous declaration of 'sys_mremap' was here
kernel/sys_ni.c:137: error: conflicting types for 'sys_remap_file_pages'
include/linux/syscalls.h:273: error: previous declaration of 'sys_remap_file_pages' was here
kernel/sys_ni.c:138: error: conflicting types for 'compat_sys_move_pages'
include/linux/syscalls.h:533: error: previous declaration of 'compat_sys_move_pages' was here
kernel/sys_ni.c:142: error: conflicting types for 'sys_bdflush'
include/linux/syscalls.h:206: error: previous declaration of 'sys_bdflush' was here
kernel/sys_ni.c:143: error: conflicting types for 'sys_ioprio_set'
include/linux/syscalls.h:517: error: previous declaration of 'sys_ioprio_set' was here
kernel/sys_ni.c:144: error: conflicting types for 'sys_ioprio_get'
include/linux/syscalls.h:518: error: previous declaration of 'sys_ioprio_get' was here
kernel/sys_ni.c:147: error: conflicting types for 'sys_signalfd'
include/linux/syscalls.h:609: error: previous declaration of 'sys_signalfd' was here
kernel/sys_ni.c:148: error: conflicting types for 'sys_timerfd'
include/linux/syscalls.h:611: error: previous declaration of 'sys_timerfd' was here
kernel/sys_ni.c:151: error: conflicting types for 'sys_eventfd'
include/linux/syscalls.h:612: error: previous declaration of 'sys_eventfd' was here
make[1]: *** [kernel/sys_ni.o] Blad 1
make: *** [kernel] Blad 2
