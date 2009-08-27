Return-Path: <linux-kernel-owner+w=401wt.eu-S1751380AbZH0HHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbZH0HHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 03:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZH0HHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 03:07:31 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48133 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZH0HHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 03:07:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 27 Aug 2009 16:05:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, oleg@redhat.com
Subject: Re: mmotm 2009-08-24-16-24 uploaded
Message-Id: <20090827160532.d6386722.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090827144453.25f1161b.kamezawa.hiroyu@jp.fujitsu.com>
References: <200908242328.n7ONSUHI022326@imap1.linux-foundation.org>
	<20090827144453.25f1161b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009 14:44:53 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> 
> In the newest mmotom, my S14nfslock hangs up. (x86-64/Fedora10)
> 
> On Mon, 24 Aug 2009 16:28:30 -0700
> akpm@linux-foundation.org wrote:
> 
> > ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
> > do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
> 
> bisected. following 2 patches for filtering SIGCHLD cause hang (for my environ).
> 
> > do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
> > do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch

removed S14nfslockd from rc5.d and check it by strace
==
 2712] fstat(6, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
[pid  2712] mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fc6f263c000
[pid  2712] dup(6)                      = 7
[pid  2712] write(6, "2712\n"..., 5)    = 5
[pid  2712] close(6)                    = 0
[pid  2712] munmap(0x7fc6f263c000, 4096) = 0
[pid  2712] clone(Process 2713 attached
child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7fc6f2625780) = 2713
[pid  2712] wait4(2713, Process 2712 suspended
 <unfinished ...>
==
When process 2713 exits, process 2712 don't wake up.

Then, I sent SIGTERM to 2712
==
Process 2713 detached

[pid  2712] <... wait4 resumed> NULL, 0, NULL) = -1 ECHILD (No child processes)
[pid  2712] --- SIGTERM (Terminated) @ 0 (0) ---
==

2713 was not caught by 2712.

Thanks,
-Kame





