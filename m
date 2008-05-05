Return-Path: <linux-kernel-owner+w=401wt.eu-S1759864AbYEEKBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864AbYEEKBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 06:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759673AbYEEKAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 06:00:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:39466 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759462AbYEEKAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 06:00:43 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX18+WNELNVg+HDZ4NzuskuX7dshbsp8qdl9kRI3IC+
	DIvZRFXX6oCbn9
Date: Mon, 5 May 2008 12:00:08 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: suresh.b.siddha@intel.com
Subject: Re: Oops with strace_test
Message-ID: <20080505100008.GA2354@alice>
References: <20080430121202.GD18314@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080430121202.GD18314@alice>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.25 (x86_64)
X-Uptime: 11:57:06 up 8 min,  1 user,  load average: 0.21, 0.31, 0.20
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Sesterhenn (snakebyte@gmx.de) wrote:
> hi,
> 
> running the strace_test from ltp 20080229 (ltp.sf.net) gives me
> two different oopses, so far i was not able to pinpoint to a specific
> testcase (propably because the strace uses the rng to decided what fails
> and what not) one oops is in iret_exc(), the other in __copy_from_user_ll()
> The oopses dont happen with 2.6.24 so this appears to be a regression, i am starting
> a git-bisect, but this might take some time
> 
> Here is a full dmesg with the oopses happening, it usually takes less than a minute
> until they trigger, strangely they dont appear in /var/log/messages, only on the netconsole

[ first part of dmesg snipped ]

> [  194.539607] BUG: unable to handle kernel NULL pointer dereference at 00000000
> [  194.539919] IP: [<c03eb611>] __copy_from_user_ll+0x61/0xe0
> [  194.540150] Oops: 0003 [#1] PREEMPT DEBUG_PAGEALLOC
> [  194.540432] Modules linked in: nfsd exportfs
> [  194.540788] 
> [  194.540949] Pid: 7340, comm: strace Tainted: G        W (2.6.25-06679-g0ff5ce7 #30)
> [  194.541105] EIP: 0060:[<c03eb611>] EFLAGS: 00010216 CPU: 0
> [  194.541187] EIP is at __copy_from_user_ll+0x61/0xe0
> [  194.541187] EAX: 00000000 EBX: 00000073 ECX: 00000200 EDX: 00000000
> [  194.541187] ESI: 00000073 EDI: 00000000 EBP: cbf23e98 ESP: cbf23e90
> [  194.541187]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [  194.541187] Process strace (pid: 7340, ti=cbf23000 task=caa5af40 task.ti=cbf23000)
> [  194.541187] Stack: 00000000 caa5af40 cbf23f1c c010a599 00000003 00000000 00000000 cbf23ed4 
> [  194.541187]        c8001dd8 00000046 00000002 00000001 c0138f7a 00000002 00000000 cbf37694 
> [  194.541187]        caa5af40 00000046 00000002 00000000 cbf37694 caa5af40 00000002 00000000 
> [  194.541187] Call Trace:
> [  194.541187]  [<c010a599>] ? restore_i387+0x89/0x190
> [  194.541187]  [<c0138f7a>] ? remove_wait_queue+0x1a/0x40
> [  194.541187]  [<c0103067>] ? restore_sigcontext+0x1c7/0x1f0
> [  194.541187]  [<c01032e9>] ? sys_sigreturn+0xe9/0x190
> [  194.541187]  [<c012fdd8>] ? sys_rt_sigaction+0x68/0x90
> [  194.541187]  [<c0103d7d>] ? sysenter_past_esp+0x6a/0xb1
> [  194.541187]  =======================
> [  194.541187] Code: c1 e9 02 83 e0 03 f3 a5 89 c1 f3 a4 8b 34 24 89 c8 8b 7c 24 04 89 ec 5d c3 90 8b 46 20 83 f9 43 76 04 8b 46 40 90 8b 06 8b 56 04 <89> 07 89 57 04 8b 46 08 8b 56 0c 89 47 08 89 57 0c 8b 46 10 8b 
> [  194.541187] EIP: [<c03eb611>] __copy_from_user_ll+0x61/0xe0 SS:ESP 0068:cbf23e90
> [  194.594334] ---[ end trace a7919e7f17c0a725 ]---
> [  204.592336] BUG: unable to handle kernel NULL pointer dereference at 00000000
> [  204.592678] IP: [<c03eb611>] __copy_from_user_ll+0x61/0xe0
> [  204.592880] *pde = 0a94d067 *pte = 09ffb065 
> [  204.593140] Oops: 0003 [#2] PREEMPT DEBUG_PAGEALLOC
> [  204.593423] Modules linked in: nfsd exportfs
> [  204.593780] 
> [  204.593941] Pid: 7638, comm: strace Tainted: G      D W (2.6.25-06679-g0ff5ce7 #30)
> [  204.594097] EIP: 0060:[<c03eb611>] EFLAGS: 00010216 CPU: 0
> [  204.594215] EIP is at __copy_from_user_ll+0x61/0xe0
> [  204.594328] EAX: 00000000 EBX: 00000074 ECX: 00000200 EDX: 00000000
> [  204.594506] ESI: 00000074 EDI: 00000000 EBP: cc82de98 ESP: cc82de90
> [  204.594625]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [  204.594645] Process strace (pid: 7638, ti=cc82d000 task=ca9bbf00 task.ti=cc82d000)
> [  204.594645] Stack: 00000000 ca9bbf00 cc82df1c c010a599 00000004 00000000 00000000 cc82ded4 
> [  204.594645]        ca98acd8 00000046 00000002 00000001 c0138f7a 00000002 00000000 cbfceb94 
> [  204.594645]        ca9bbf00 00000046 00000002 00000000 cbfceb94 ca9bbf00 00000002 00000000 
> [  204.594645] Call Trace:
> [  204.594645]  [<c010a599>] ? restore_i387+0x89/0x190
> [  204.594645]  [<c0138f7a>] ? remove_wait_queue+0x1a/0x40
> [  204.594645]  [<c0103067>] ? restore_sigcontext+0x1c7/0x1f0
> [  204.594645]  [<c01032e9>] ? sys_sigreturn+0xe9/0x190
> [  204.594645]  [<c012fdd8>] ? sys_rt_sigaction+0x68/0x90
> [  204.594645]  [<c0103d7d>] ? sysenter_past_esp+0x6a/0xb1
> [  204.594645]  =======================
> [  204.594645] Code: c1 e9 02 83 e0 03 f3 a5 89 c1 f3 a4 8b 34 24 89 c8 8b 7c 24 04 89 ec 5d c3 90 8b 46 20 83 f9 43 76 04 8b 46 40 90 8b 06 8b 56 04 <89> 07 89 57 04 8b 46 08 8b 56 0c 89 47 08 89 57 0c 8b 46 10 8b 
> [  204.594645] EIP: [<c03eb611>] __copy_from_user_ll+0x61/0xe0 SS:ESP 0068:cc82de90
> [  204.785891] ---[ end trace a7919e7f17c0a725 ]---
> [  207.866195] BUG: unable to handle kernel NULL pointer dereference at 00000000
> [  207.866555] IP: [<c067b1b5>] iret_exc+0x605/0x992
> [  207.866753] *pde = 0aac3067 *pte = 00000000 
> [  207.867013] Oops: 0002 [#3] PREEMPT DEBUG_PAGEALLOC
> [  207.867296] Modules linked in: nfsd exportfs
> [  207.867653] 
> [  207.867815] Pid: 7897, comm: strace Tainted: G      D W (2.6.25-06679-g0ff5ce7 #30)
> [  207.867973] EIP: 0060:[<c067b1b5>] EFLAGS: 00010246 CPU: 0
> [  207.868091] EIP is at iret_exc+0x605/0x992
> [  207.868201] EAX: 00000000 EBX: 00000077 ECX: 00000200 EDX: 00000077
> [  207.868379] ESI: 00000077 EDI: 00000000 EBP: ccbaae98 ESP: ccbaae88
> [  207.868498]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [  207.868521] Process strace (pid: 7897, ti=ccbaa000 task=cbf7cec0 task.ti=ccbaa000)
> [  207.868521] Stack: 00000077 00000200 00000000 cbf7cec0 ccbaaf1c c010a599 00000007 00000000 
> [  207.868521]        00000000 ccbaaed4 c8000ef8 00000046 00000002 00000001 c0138f7a 00000002 
> [  207.868521]        00000000 cbf57c14 cbf7cec0 00000046 00000002 00000000 cbf57c14 cbf7cec0 
> [  207.868521] Call Trace:
> [  207.868521]  [<c010a599>] ? restore_i387+0x89/0x190
> [  207.868521]  [<c0138f7a>] ? remove_wait_queue+0x1a/0x40
> [  207.868521]  [<c0103067>] ? restore_sigcontext+0x1c7/0x1f0
> [  207.868521]  [<c01032e9>] ? sys_sigreturn+0xe9/0x190
> [  207.868521]  [<c012fdd8>] ? sys_rt_sigaction+0x68/0x90
> [  207.868521]  [<c0103d7d>] ? sysenter_past_esp+0x6a/0xb1
> [  207.868521]  =======================
> [  207.868521] Code: ff 01 c1 e9 00 04 d7 ff 8d 0c 88 e9 f8 03 d7 ff 01 c1 eb 03 8d 0c 88 51 50 31 c0 f3 aa 58 59 e9 44 04 d7 ff 8d 0c 88 51 50 31 c0 <f3> aa 58 59 e9 c9 04 d7 ff 01 c1 e9 0d 05 d7 ff 8d 0c 88 e9 05 
> [  207.868521] EIP: [<c067b1b5>] iret_exc+0x605/0x992 SS:ESP 0068:ccbaae88
> [  208.002448] ---[ end trace a7919e7f17c0a725 ]---

after some bisecting i found commit
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=aa283f49276e7d840a40fb01eee6de97eaa7e012;hp=61c4628b538608c1a85211ed8438136adfeb9a95
to be guilty. After reverting this manually (didnt revert cleanly)
i was unable to reproduce the oopses

Greetings, Eric
