Return-Path: <linux-kernel-owner+w=401wt.eu-S1758348AbZEHCLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbZEHCLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 22:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbZEHCLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:11:05 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62553 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbZEHCLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:11:00 -0400
Message-Id: <200905080210.n482ALpZ048382@www262.sakura.ne.jp>
Subject: Re: [TOMOYO] Add garbage collector support.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: jmorris@namei.org
Cc: pavel@ucw.cz, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 08 May 2009 11:10:21 +0900
References: <20090501102438.GA7470@elf.ucw.cz> <200905012207.BFC60616.QStOHOMJFOLFFV@I-love.SAKURA.ne.jp> <20090503215615.GA1368@ucw.cz> <200905041524.GGH52160.FFFVMSJOOLtHOQ@I-love.SAKURA.ne.jp> <200905062116.HCI09807.VOFFHFSMOLOtQJ@I-love.SAKURA.ne.jp> <200905072042.AFF10698.LJFHOOFFQtMOSV@I-love.SAKURA.ne.jp> <alpine.LRH.2.00.0905081140500.2761@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.0905081140500.2761@tundra.namei.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 07052009 #1939649, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> > James, it is possible to apply below commits to security-testing-2.6#next ?
> > I get a lot of warning messages in my environment.
> 
> Please elaborate.

Without commits

  mm: pass correct mm when growing stack
  Revert "kobject: don't block for each kobject_uevent".
  x86: clean up old gcc warnings

I get compiler warnings

  # make init/main.o
  scripts/kconfig/conf -s arch/x86/Kconfig
    CHK     include/linux/version.h
    CHK     include/linux/utsrelease.h
    SYMLINK include/asm -> include/asm-x86
    CALL    scripts/checksyscalls.sh
    CC      init/main.o
  In file included from /usr/src/all/security-testing-2.6.git/arch/x86/include/asm/page.h:8,
                   from /usr/src/all/security-testing-2.6.git/arch/x86/include/asm/processor.h:18,
                   from include/linux/prefetch.h:14,
                   from include/linux/list.h:6,
                   from include/linux/module.h:9,
                   from init/main.c:13:
  /usr/src/all/security-testing-2.6.git/arch/x86/include/asm/page_types.h:48: warning: parameter has incomplete type
  /usr/src/all/security-testing-2.6.git/arch/x86/include/asm/page_types.h:50: warning: parameter has incomplete type

and runtime warnings

  ------------[ cut here ]------------
  WARNING: at security/security.c:217 security_vm_enough_memory+0x9b/0xb0()
  Hardware name: VMware Virtual Platform
  Modules linked in: pcnet32 crc32
  Pid: 3277, comm: khelper Not tainted 2.6.29 #3
  Call Trace:
   [<c015f400>] ? zap_locks+0x110/0x130
   [<c015e5fd>] warn_slowpath+0x8d/0xf0
   [<c019b2ec>] ? validate_chain+0x3fc/0x540
   [<c019b2ec>] ? validate_chain+0x3fc/0x540
   [<c019d79c>] ? __lock_acquire+0x29c/0x8b0
   [<c019f159>] ? __lock_acquired+0x109/0x1c0
   [<c035bbdb>] security_vm_enough_memory+0x9b/0xb0
   [<c02089bb>] acct_stack_growth+0xcb/0x190
   [<c0208ba1>] expand_downwards+0x121/0x1a0
   [<c0208c3d>] expand_stack+0xd/0x10
   [<c0208cdd>] find_extend_vma+0x9d/0x130
   [<c01ff5d5>] __get_user_pages+0x95/0x6c0
   [<c01ffc73>] get_user_pages+0x73/0x90
   [<c0233cd8>] get_arg_page+0x48/0x130
   [<c02342a5>] copy_strings+0x165/0x2f0
   [<c02366ba>] do_execve+0x31a/0x900
   [<c010252a>] sys_execve+0x5a/0xb0
   [<c01040b4>] syscall_call+0x7/0xb
   [<c010b624>] ? kernel_execve+0x24/0x30
   [<c017ab73>] ? ____call_usermodehelper+0x103/0x190
   [<c017aa70>] ? ____call_usermodehelper+0x0/0x190
   [<c0104a73>] ? kernel_thread_helper+0x7/0x10
  ---[ end trace 636cdcc028137283 ]---

in my environment.

These commits are already in 2.6.30-rc4.
These warnings will disappear when security-testing-2.6#next is refreshed
using 2.6.30-rcX . But security-testing-2.6#next is using 2.6.29.
Thus, I wished these commits applied to security-testing-2.6#next
if there is no problem.
