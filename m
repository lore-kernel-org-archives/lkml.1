Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbZCZBbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbZCZBbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 21:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZCZBbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 21:31:31 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53541 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbZCZBba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 21:31:30 -0400
Message-Id: <200903260130.n2Q1U9EJ040448@www262.sakura.ne.jp>
Subject: current->mm == NULL in security_vm_enough_memory().
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: alan@redhat.com, hooanon05@yahoo.co.jp, jmorris@namei.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 26 Mar 2009 10:30:09 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 26032009 #1779876, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

2.6.28 and later have a "current->mm != NULL" checking
added by commit 731572d39fcd3498702eda4600db4c43d51e0b26 .

  int security_vm_enough_memory(long pages)
  {
  	WARN_ON(current->mm == NULL);
  	return security_ops->vm_enough_memory(current->mm, pages);
  }

I encountered this warning on Debian Sarge.
Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.29-next-20090324 .

Mounting local filesystems...
[   18.746829] kjournald starting.  Commit interval 5 seconds
[   18.754102] EXT3 FS on sdb1, internal journal
[   18.756928] EXT3-fs: mounted filesystem with ordered data mode.
/dev/sdb1 on /usr/src/all type ext3 (rw,noatime,nodiratime)
Cleaning /tmp /var/run /var/lock.
Detecting hardware: agpgart pcnet32 piix BusLogic ide_scsi
Skipping unavailable/built-in agpgart module.
pcnet32 disabled in configuration.
Skipping unavailable/built-in piix module.
Skipping unavailable/built-in BusLogic module.
Skipping unavailable/built-in ide_scsi module.
Running 0dns-down to make sure resolv.conf is ok...done.
Setting up networking...done.
Starting hotplug subsystem:
   pci
     ignoring pci display device 00:0f.0
[   28.728908] pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[   28.735902] pcnet32: PCnet/PCI II 79C970A at 0x2000, 00:0c:29:9e:eb:32 assigned IRQ 18.
[   28.754197] eth0: registered as PCnet/PCI II 79C970A
[   28.758543] pcnet32: 1 cards_found.
[   28.765817] ------------[ cut here ]------------
[   28.768916] WARNING: at security/security.c:217 security_vm_enough_memory+0xa0/0xb0()
[   28.772484] Hardware name: VMware Virtual Platform
[   28.774099] Modules linked in: pcnet32 crc32
[   28.776920] Pid: 3286, comm: khelper Not tainted 2.6.29-next-20090324-dirty #3
[   28.780317] Call Trace:
[   28.781323]  [<c0159200>] ? have_callable_console+0x30/0x50
[   28.784171]  [<c0158497>] warn_slowpath+0x97/0xf0
[   28.785739]  [<c0190f7c>] ? validate_chain+0x3fc/0x540
[   28.788402]  [<c0190f7c>] ? validate_chain+0x3fc/0x540
[   28.790103]  [<c0192dfc>] ? __lock_acquire+0x29c/0x8a0
[   28.792809]  [<c0194859>] ? __lock_acquired+0x109/0x1c0
[   28.794539]  [<c0338ea0>] security_vm_enough_memory+0xa0/0xb0
[   28.797391]  [<c0202117>] acct_stack_growth+0xd7/0x160
[   28.798842]  [<c02022b9>] expand_downwards+0x119/0x150
[   28.801709]  [<c020230d>] expand_stack+0xd/0x10
[   28.804171]  [<c02023bd>] find_extend_vma+0xad/0x110
[   28.805806]  [<c01f9c04>] __get_user_pages+0x94/0x610
[   28.808557]  [<c01fa1fb>] get_user_pages+0x7b/0x90
[   28.810483]  [<c022c028>] get_arg_page+0x48/0x100
[   28.812972]  [<c022c58c>] copy_strings+0x16c/0x2a0
[   28.814552]  [<c022ea52>] do_execve+0x6b2/0x7e0
[   28.817138]  [<c02320eb>] ? getname+0x6b/0xa0
[   28.818622]  [<c010237e>] sys_execve+0x5e/0xb0
[   28.821006]  [<c0103d19>] syscall_call+0x7/0xb
[   28.822469]  [<c010ae94>] ? kernel_execve+0x24/0x30
[   28.825161]  [<c01729af>] ? ____call_usermodehelper+0xff/0x170
[   28.828052]  [<c01728b0>] ? ____call_usermodehelper+0x0/0x170
[   28.829944]  [<c0104707>] ? kernel_thread_helper+0x7/0x10
[   28.832802] ---[ end trace 2e6964f14bb57083 ]---

May I ignore this warning?

Regards.
