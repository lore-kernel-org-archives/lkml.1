Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbYL2MNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbYL2MNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbYL2MM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:12:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47775 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbYL2MM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:12:58 -0500
Date: Mon, 29 Dec 2008 13:12:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: introducing asm/sys_ia32.h
Message-ID: <20081229121249.GC9628@elte.hu>
References: <1230394031.8231.2.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230394031.8231.2.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:

> Impact: cleanup, avoid 44 sparse warnings, new file asm/sys_ia32.h
> 
> Fixes following sparse warnings:
>   CHECK   arch/x86/ia32/sys_ia32.c
> arch/x86/ia32/sys_ia32.c:53:17: warning: symbol 'sys32_truncate64' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:60:17: warning: symbol 'sys32_ftruncate64' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:98:17: warning: symbol 'sys32_stat64' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:109:17: warning: symbol 'sys32_lstat64' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:119:17: warning: symbol 'sys32_fstat64' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:128:17: warning: symbol 'sys32_fstatat' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:164:17: warning: symbol 'sys32_mmap' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:195:17: warning: symbol 'sys32_mprotect' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:201:17: warning: symbol 'sys32_pipe' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:215:17: warning: symbol 'sys32_rt_sigaction' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:291:17: warning: symbol 'sys32_sigaction' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:330:17: warning: symbol 'sys32_rt_sigprocmask' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:370:17: warning: symbol 'sys32_alarm' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:383:17: warning: symbol 'sys32_old_select' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:393:17: warning: symbol 'sys32_waitpid' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:401:17: warning: symbol 'sys32_sysfs' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:406:17: warning: symbol 'sys32_sched_rr_get_interval' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:421:17: warning: symbol 'sys32_rt_sigpending' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:445:17: warning: symbol 'sys32_rt_sigqueueinfo' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:472:17: warning: symbol 'sys32_sysctl' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:517:17: warning: symbol 'sys32_pread' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:524:17: warning: symbol 'sys32_pwrite' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:532:17: warning: symbol 'sys32_personality' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:545:17: warning: symbol 'sys32_sendfile' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:565:17: warning: symbol 'sys32_mmap2' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:589:17: warning: symbol 'sys32_olduname' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:626:6: warning: symbol 'sys32_uname' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:641:6: warning: symbol 'sys32_ustat' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:663:17: warning: symbol 'sys32_execve' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:678:17: warning: symbol 'sys32_clone' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:693:6: warning: symbol 'sys32_lseek' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:698:6: warning: symbol 'sys32_kill' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:703:6: warning: symbol 'sys32_fadvise64_64' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:712:6: warning: symbol 'sys32_vm86_warning' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:726:6: warning: symbol 'sys32_lookup_dcookie' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:732:20: warning: symbol 'sys32_readahead' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:738:17: warning: symbol 'sys32_sync_file_range' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:746:17: warning: symbol 'sys32_fadvise64' was not declared. Should it be static?
> arch/x86/ia32/sys_ia32.c:753:17: warning: symbol 'sys32_fallocate' was not declared. Should it be static?
>   CHECK   arch/x86/ia32/ia32_signal.c
> arch/x86/ia32/ia32_signal.c:126:17: warning: symbol 'sys32_sigsuspend' was not declared. Should it be static?
> arch/x86/ia32/ia32_signal.c:141:17: warning: symbol 'sys32_sigaltstack' was not declared. Should it be static?
> arch/x86/ia32/ia32_signal.c:249:17: warning: symbol 'sys32_sigreturn' was not declared. Should it be static?
> arch/x86/ia32/ia32_signal.c:279:17: warning: symbol 'sys32_rt_sigreturn' was not declared. Should it be static?
>   CHECK   arch/x86/ia32/ipc32.c
> arch/x86/ia32/ipc32.c:12:17: warning: symbol 'sys32_ipc' was not declared. Should it be static?
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/ia32/ia32_signal.c     |    3 +-
>  arch/x86/ia32/ipc32.c           |    1 +
>  arch/x86/ia32/sys_ia32.c        |    2 +-
>  arch/x86/include/asm/sys_ia32.h |  101 +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 104 insertions(+), 3 deletions(-)
>  create mode 100644 arch/x86/include/asm/sys_ia32.h

applied to tip/x86/cleanups, thanks.

	Ingo
