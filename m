Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbZCZBlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbZCZBlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 21:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZCZBl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 21:41:27 -0400
Received: from tundra.namei.org ([65.99.196.166]:4499 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbZCZBl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 21:41:26 -0400
Date: Thu, 26 Mar 2009 12:41:01 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: alan@redhat.com, hooanon05@yahoo.co.jp, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: current->mm == NULL in security_vm_enough_memory().
In-Reply-To: <200903260130.n2Q1U9EJ040448@www262.sakura.ne.jp>
Message-ID: <alpine.LRH.2.00.0903261236580.30336@tundra.namei.org>
References: <200903260130.n2Q1U9EJ040448@www262.sakura.ne.jp>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009, Tetsuo Handa wrote:

> [   28.765817] ------------[ cut here ]------------
> [   28.768916] WARNING: at security/security.c:217 security_vm_enough_memory+0xa0/0xb0()
> [   28.772484] Hardware name: VMware Virtual Platform
> [   28.774099] Modules linked in: pcnet32 crc32
> [   28.776920] Pid: 3286, comm: khelper Not tainted 2.6.29-next-20090324-dirty #3
> [   28.780317] Call Trace:
> [   28.781323]  [<c0159200>] ? have_callable_console+0x30/0x50
> [   28.784171]  [<c0158497>] warn_slowpath+0x97/0xf0
> [   28.785739]  [<c0190f7c>] ? validate_chain+0x3fc/0x540
> [   28.788402]  [<c0190f7c>] ? validate_chain+0x3fc/0x540
> [   28.790103]  [<c0192dfc>] ? __lock_acquire+0x29c/0x8a0
> [   28.792809]  [<c0194859>] ? __lock_acquired+0x109/0x1c0
> [   28.794539]  [<c0338ea0>] security_vm_enough_memory+0xa0/0xb0
> [   28.797391]  [<c0202117>] acct_stack_growth+0xd7/0x160
> [   28.798842]  [<c02022b9>] expand_downwards+0x119/0x150
> [   28.801709]  [<c020230d>] expand_stack+0xd/0x10
> [   28.804171]  [<c02023bd>] find_extend_vma+0xad/0x110
> [   28.805806]  [<c01f9c04>] __get_user_pages+0x94/0x610
> [   28.808557]  [<c01fa1fb>] get_user_pages+0x7b/0x90
> [   28.810483]  [<c022c028>] get_arg_page+0x48/0x100
> [   28.812972]  [<c022c58c>] copy_strings+0x16c/0x2a0
> [   28.814552]  [<c022ea52>] do_execve+0x6b2/0x7e0
> [   28.817138]  [<c02320eb>] ? getname+0x6b/0xa0
> [   28.818622]  [<c010237e>] sys_execve+0x5e/0xb0
> [   28.821006]  [<c0103d19>] syscall_call+0x7/0xb
> [   28.822469]  [<c010ae94>] ? kernel_execve+0x24/0x30
> [   28.825161]  [<c01729af>] ? ____call_usermodehelper+0xff/0x170
> [   28.828052]  [<c01728b0>] ? ____call_usermodehelper+0x0/0x170
> [   28.829944]  [<c0104707>] ? kernel_thread_helper+0x7/0x10
> [   28.832802] ---[ end trace 2e6964f14bb57083 ]---
> 
> May I ignore this warning?

khelper is a kernel thread, so it should not have an ->mm, but I wonder 
why this hasn't shown up before.  Odd...


- James
-- 
James Morris
<jmorris@namei.org>
