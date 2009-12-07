Return-Path: <linux-kernel-owner+w=401wt.eu-S935454AbZLGQwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935454AbZLGQwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935411AbZLGQwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:52:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:26645 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935398AbZLGQwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:52:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=sr+R8X91xVj849691DTm4ewSYFCwKXl7Kum9ySh5aajYRgCxW/OFTOeuXUcYJQNlSr
         S/cGXCWv2tUqxm3kPgVDHv506iOM0SSuEcy5RSDgpQAypld53dv95+dqhaePUwj7COh0
         fVi26tdCt50raYRUm/XZ/2jRyO3c5icjvMsEk=
Message-ID: <4B1D32D1.4090404@gmail.com>
Date: Mon, 07 Dec 2009 17:52:33 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091122 SUSE/3.0.0-9.1 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Neil Horman <nhorman@tuxdriver.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [PULL] pull request for writable limits for 2.6.33-rc1
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from writable limits git. It contains naming fixes suggested
by Ingo, so that we have task_rlimit() and similar helpers for rlimits now.

--
The following changes since commit 6ec22f9b037fc0c2e00ddb7023fad279c365324d:
  Linus Torvalds (1):
        Merge branch 'x86-debug-for-linus' of
git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://decibel.fi.muni.cz/~xslaby/linux writable_limits

Jiri Slaby (25):
      SECURITY: selinux, fix update_rlimit_cpu parameter
      SECURITY: add task_struct to setrlimit
      core: add task_struct to update_rlimit_cpu
      core: split sys_setrlimit
      core: allow setrlimit to non-current tasks
      core: optimize setrlimit for current task
      FS: proc, switch limits reading to fops
      FS: proc, make limits writable
      core: do security check under task_lock
      core: rename setrlimit to do_setrlimit
      resource: move kernel functions inside __KERNEL__
      core: posix-cpu-timers, cleanup rlimits usage
      resource: add helpers for fetching rlimits
      IA64: use helpers for rlimits
      PPC: use helpers for rlimits
      S390: use helpers for rlimits
      SPARC: use helpers for rlimits
      X86: use helpers for rlimits
      FS: use helpers for rlimits
      MM: use helpers for rlimits
      core: use helpers for rlimits
      misc: use helpers for rlimits
      core: implement getprlimit and setprlimit syscalls
      COMPAT: add get/put_compat_rlimit
      x86: add ia32 compat prlimit syscalls

Neil Horman (1):
      unistd: add __NR_[get|set]prlimit syscall numbers

Oleg Nesterov (1):
      sys_setrlimit: make sure ->rlim_max never grows

 arch/ia64/kernel/perfmon.c                     |    2 +-
 arch/ia64/kernel/sys_ia64.c                    |    2 +-
 arch/ia64/mm/init.c                            |    2 +-
 arch/powerpc/mm/mmap_64.c                      |    4 +-
 arch/powerpc/platforms/cell/spufs/coredump.c   |    2 +-
 arch/s390/mm/mmap.c                            |    4 +-
 arch/sparc/kernel/sys_sparc_64.c               |    6 +-
 arch/x86/ia32/ia32_aout.c                      |    2 +-
 arch/x86/ia32/ia32entry.S                      |    2 +
 arch/x86/include/asm/unistd_32.h               |    4 +-
 arch/x86/include/asm/unistd_64.h               |    4 +
 arch/x86/kernel/syscall_table_32.S             |    2 +
 arch/x86/mm/mmap.c                             |    4 +-
 drivers/infiniband/core/umem.c                 |    2 +-
 drivers/infiniband/hw/ipath/ipath_user_pages.c |    3 +-
 fs/attr.c                                      |    2 +-
 fs/binfmt_aout.c                               |    2 +-
 fs/binfmt_flat.c                               |    2 +-
 fs/exec.c                                      |    8 +-
 fs/fcntl.c                                     |    2 +-
 fs/file.c                                      |    2 +-
 fs/proc/array.c                                |    4 +-
 fs/proc/base.c                                 |  101 ++++++++++++++--
 fs/select.c                                    |    2 +-
 include/asm-generic/unistd.h                   |    6 +-
 include/linux/Kbuild                           |    2 +-
 include/linux/posix-timers.h                   |    2 +-
 include/linux/resource.h                       |   10 ++-
 include/linux/sched.h                          |   22 ++++
 include/linux/security.h                       |    9 +-
 include/linux/syscalls.h                       |    4 +
 ipc/mqueue.c                                   |    2 +-
 ipc/shm.c                                      |    3 +-
 kernel/compat.c                                |   91 +++++++++++---
 kernel/fork.c                                  |   10 +-
 kernel/perf_event.c                            |    2 +-
 kernel/posix-cpu-timers.c                      |   52 ++++----
 kernel/sched.c                                 |    4 +-
 kernel/sched_rt.c                              |    5 +-
 kernel/signal.c                                |    2 +-
 kernel/sys.c                                   |  161
+++++++++++++++++++----
 mm/filemap.c                                   |    2 +-
 mm/mlock.c                                     |   12 +-
 mm/mmap.c                                      |   13 +-
 mm/mremap.c                                    |    2 +-
 security/capability.c                          |    3 +-
 security/security.c                            |    5 +-
 security/selinux/hooks.c                       |   10 +-
 48 files changed, 451 insertions(+), 153 deletions(-)

thanks,
-- 
js
