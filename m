Return-Path: <linux-kernel-owner+w=401wt.eu-S1762205AbZLKLFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762205AbZLKLFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760362AbZLKLFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:05:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:5071 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840AbZLKLFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:05:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=v5jPy6yeLAsueAflY5qmLeVPHBOadZyzHkBM1U2b698doBj0zyABBPRFAMYR4Kgh2v
         BD0TdFqo6xJ4iDthsmwOS/fwzASDpmUpnMjmbKWm8/QyLBmZ2+RJHILK8hPzS+xSIQDE
         juOoJkckJ0Ut9ZHBXN2uRivtbY91dZVU7xYdI=
Message-ID: <4B222771.7010901@suse.cz>
Date: Fri, 11 Dec 2009 12:05:21 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-13.1 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Neil Horman <nhorman@tuxdriver.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [git pull -resend] pull request for writable limits for 2.6.33-rc0
References: <4B1D32D1.4090404@gmail.com> <4B1FF9A1.2040305@gmail.com>
In-Reply-To: <4B1FF9A1.2040305@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is there something wrong with the patchset? Did the email make it into
your inbox at all?

On 12/09/2009 08:25 PM, Jiri Slaby wrote:
> Hi,
> 
> I messed up the subject last time.
> 
> Now I rebased the tree to resolve conflicts, please pull.
> 
> ---
> The following changes since commit 2588465badb648a50cd19623f0dd0063c90d4e31:
>   Linus Torvalds (1):
>         Merge branch 'bkl-arch-for-linus' of
> git://git.kernel.org/.../tip/linux-2.6-tip
> 
> are available in the git repository at:
> 
>   git://decibel.fi.muni.cz/~xslaby/linux writable_limits
> 
> Jiri Slaby (25):
>       SECURITY: selinux, fix update_rlimit_cpu parameter
>       SECURITY: add task_struct to setrlimit
>       core: add task_struct to update_rlimit_cpu
>       core: split sys_setrlimit
>       core: allow setrlimit to non-current tasks
>       core: optimize setrlimit for current task
>       FS: proc, switch limits reading to fops
>       FS: proc, make limits writable
>       core: do security check under task_lock
>       core: rename setrlimit to do_setrlimit
>       resource: move kernel functions inside __KERNEL__
>       core: posix-cpu-timers, cleanup rlimits usage
>       resource: add helpers for fetching rlimits
>       IA64: use helpers for rlimits
>       PPC: use helpers for rlimits
>       S390: use helpers for rlimits
>       SPARC: use helpers for rlimits
>       X86: use helpers for rlimits
>       FS: use helpers for rlimits
>       MM: use helpers for rlimits
>       core: use helpers for rlimits
>       misc: use helpers for rlimits
>       core: implement getprlimit and setprlimit syscalls
>       COMPAT: add get/put_compat_rlimit
>       x86: add ia32 compat prlimit syscalls
> 
> Neil Horman (1):
>       unistd: add __NR_[get|set]prlimit syscall numbers
> 
> Oleg Nesterov (1):
>       sys_setrlimit: make sure ->rlim_max never grows
> 
>  arch/ia64/kernel/perfmon.c                     |    2 +-
>  arch/ia64/kernel/sys_ia64.c                    |    2 +-
>  arch/ia64/mm/init.c                            |    2 +-
>  arch/powerpc/mm/mmap_64.c                      |    4 +-
>  arch/powerpc/platforms/cell/spufs/coredump.c   |    2 +-
>  arch/s390/mm/mmap.c                            |    4 +-
>  arch/sparc/kernel/sys_sparc_64.c               |    6 +-
>  arch/x86/ia32/ia32_aout.c                      |    2 +-
>  arch/x86/ia32/ia32entry.S                      |    2 +
>  arch/x86/include/asm/unistd_32.h               |    4 +-
>  arch/x86/include/asm/unistd_64.h               |    4 +
>  arch/x86/kernel/syscall_table_32.S             |    2 +
>  arch/x86/mm/mmap.c                             |    4 +-
>  drivers/infiniband/core/umem.c                 |    2 +-
>  drivers/infiniband/hw/ipath/ipath_user_pages.c |    3 +-
>  fs/attr.c                                      |    2 +-
>  fs/binfmt_aout.c                               |    2 +-
>  fs/binfmt_flat.c                               |    2 +-
>  fs/exec.c                                      |    8 +-
>  fs/fcntl.c                                     |    2 +-
>  fs/file.c                                      |    2 +-
>  fs/proc/array.c                                |    4 +-
>  fs/proc/base.c                                 |  101 ++++++++++++++--
>  fs/select.c                                    |    2 +-
>  include/asm-generic/unistd.h                   |    6 +-
>  include/linux/Kbuild                           |    2 +-
>  include/linux/posix-timers.h                   |    2 +-
>  include/linux/resource.h                       |   10 ++-
>  include/linux/sched.h                          |   22 ++++
>  include/linux/security.h                       |    9 +-
>  include/linux/syscalls.h                       |    4 +
>  ipc/mqueue.c                                   |    2 +-
>  ipc/shm.c                                      |    3 +-
>  kernel/compat.c                                |   91 +++++++++++---
>  kernel/fork.c                                  |   10 +-
>  kernel/perf_event.c                            |    2 +-
>  kernel/posix-cpu-timers.c                      |   52 ++++----
>  kernel/sched.c                                 |    4 +-
>  kernel/sched_rt.c                              |    5 +-
>  kernel/signal.c                                |    2 +-
>  kernel/sys.c                                   |  161
> +++++++++++++++++++----
>  mm/filemap.c                                   |    2 +-
>  mm/mlock.c                                     |   12 +-
>  mm/mmap.c                                      |   13 +-
>  mm/mremap.c                                    |    2 +-
>  security/capability.c                          |    3 +-
>  security/security.c                            |    5 +-
>  security/selinux/hooks.c                       |   10 +-
>  48 files changed, 451 insertions(+), 153 deletions(-)


-- 
js
suse labs
