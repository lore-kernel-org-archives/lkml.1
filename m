Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbYJWSq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbYJWSq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 14:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYJWSqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 14:46:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:16670 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbYJWSqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 14:46:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JMp29XGjD6I6GT3W9IxyHkbxmV23NiU4AkPDegHHHin9EU1wa9/6MIOwBUDFINRwEO
         urCykLHgp8ZHwyWsw5RyIHM25pHKnUn/i8uEfHUmVZHPN6ow9yeKkJYUPlsAlqmk1tQw
         sSK1M83HPjBFB2MJXmkoKeksoZbIDPmAmODuo=
Date: Thu, 23 Oct 2008 22:49:28 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT] /proc update
Message-ID: <20081023184928.GA22951@x200.localdomain>
References: <20081023183649.GA13432@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023183649.GA13432@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 10:36:49PM +0400, Alexey Dobriyan wrote:
> Linus, please, pull from
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc
> 
> to get
> a) /proc/*/smaps fix aka "[vsyscall] is listed twice"
> b) proc_misc.c disintegration patches which spread that collective
>    dumping ground into sensible pieces,
> c) trivial things.
> 
> Regarding (b), it wasn't in -next because of huge rejects, it wasn't in
> -mm because of huge rejects, but (!) various people acked pieces, it was
> booted in several configurations here and proc files were created and
> worked as usual, it's trivial.
> 
> Also, looks like, I can't put it into -next or into -mm and keep it for
> several months there because of rejects, and keeping it out of system
> will buy me approximately the same amount of testing as there is now.
> 
> However, fs/proc/ compiliation was tested on huge cross-compile setup here
> and many, many randconfigs without warnings or errors.
> 
> Now, if you don't buy it, pull from
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc-conservative
> 
> to get just /proc/*/smaps fix and trivial things.

Alexey Dobriyan (33):
      proc: proc_init_inodecache() can't fail
      proc: spread __init
      proc: switch /proc/loadavg to seq_file
      proc: switch /proc/uptime to seq_file
      proc: switch /proc/meminfo to seq_file
      proc: switch /proc/version to seq_file
      proc: move /proc/hardware to m68k-specific code
      proc: move /proc/stram to m68k-specific code
      proc: move /proc/filesystems to fs/filesystems.c
      proc: switch /proc/cmdline to seq_file
      proc: move /proc/execdomains to kernel/exec_domain.c
      proc: remove remnants of ->read_proc in proc_misc.c
      proc: move /proc/kmsg creation to fs/proc/kmsg.c
      proc: move rest of /proc/locks to fs/locks.c
      proc: move /proc/devices code to fs/proc/devices.c
      proc: move /proc/cpuinfo code to fs/proc/cpuinfo.c
      proc: move rest of /proc/partitions code to block/genhd.c
      proc: move /proc/stat to fs/proc/stat.c
      proc: move /proc/interrupts boilerplate code to fs/proc/interrupts.c
      proc: move /proc/slab_allocators boilerplate to mm/slab.c
      proc: move /proc/slabinfo boilerplate to mm/slub.c, mm/slab.c
      proc: move /proc/vmallocinfo to mm/vmalloc.c
      proc: move /proc/buddyinfo boilerplate to mm/vmstat.c
      proc: move /proc/pagetypeinfo boilerplate to mm/vmstat.c
      proc: move /proc/vmstat boilerplate to mm/vmstat.c
      proc: move /proc/zoneinfo boilerplate to mm/vmstat.c
      proc: move /proc/diskstats boilerplate to block/genhd.c
      proc: move /proc/modules boilerplate to kernel/module.c
      proc: move /proc/schedstat boilerplate to kernel/sched_stats.h
      proc: move all /proc/kcore stuff to fs/proc/kcore.c
      proc: move pagecount stuff to fs/proc/page.c
      proc: move /proc/vmcore creation to fs/proc/vmcore.c
      proc: remove fs/proc/proc_misc.c

Arjan van de Ven (1):
      proc: use WARN() rather than printk+backtrace

Joe Korty (1):
      proc: fix vma display mismatch between /proc/pid/{maps,smaps}


 arch/m68k/amiga/config.c    |   21 +-
 arch/m68k/atari/config.c    |   15 +-
 arch/m68k/atari/stram.c     |   28 +-
 arch/m68k/bvme6000/config.c |   11 -
 arch/m68k/kernel/setup.c    |   35 ++-
 arch/m68k/mvme147/config.c  |   10 -
 arch/m68k/mvme16x/config.c  |   15 +-
 arch/m68k/q40/config.c      |   10 -
 arch/m68k/sun3/config.c     |   12 +-
 arch/m68k/sun3x/config.c    |   12 +-
 arch/x86/mm/pageattr.c      |   11 +-
 block/genhd.c               |   37 ++-
 fs/filesystems.c            |   39 ++
 fs/locks.c                  |   22 +-
 fs/proc/Makefile            |   13 +-
 fs/proc/cmdline.c           |   29 ++
 fs/proc/cpuinfo.c           |   24 ++
 fs/proc/devices.c           |   70 ++++
 fs/proc/generic.c           |    3 +-
 fs/proc/inode.c             |    3 +-
 fs/proc/internal.h          |    3 +-
 fs/proc/interrupts.c        |   53 +++
 fs/proc/kcore.c             |   14 +-
 fs/proc/kmsg.c              |   12 +-
 fs/proc/loadavg.c           |   51 +++
 fs/proc/meminfo.c           |  168 ++++++++
 fs/proc/page.c              |  147 +++++++
 fs/proc/proc_devtree.c      |    3 +-
 fs/proc/proc_misc.c         |  933 -------------------------------------------
 fs/proc/proc_sysctl.c       |    4 +-
 fs/proc/root.c              |    8 +-
 fs/proc/stat.c              |  153 +++++++
 fs/proc/task_mmu.c          |   25 +-
 fs/proc/uptime.c            |   43 ++
 fs/proc/version.c           |   34 ++
 fs/proc/vmcore.c            |    6 +-
 include/asm-m68k/machdep.h  |    2 +-
 include/asm-x86/pgtable.h   |    3 +-
 include/linux/crash_dump.h  |    2 -
 include/linux/fs.h          |    1 -
 include/linux/genhd.h       |    3 -
 include/linux/hugetlb.h     |    6 +-
 include/linux/proc_fs.h     |    5 -
 include/linux/sched.h       |    4 -
 include/linux/slab.h        |    5 -
 include/linux/vmalloc.h     |    2 -
 include/linux/vmstat.h      |    4 -
 kernel/exec_domain.c        |   33 ++-
 kernel/module.c             |   59 ++-
 kernel/sched.c              |    1 +
 kernel/sched_stats.h        |    9 +-
 mm/hugetlb.c                |    5 +-
 mm/slab.c                   |   52 +++-
 mm/slub.c                   |   29 +-
 mm/vmalloc.c                |   33 ++-
 mm/vmstat.c                 |   69 +++-
 56 files changed, 1263 insertions(+), 1141 deletions(-)
 create mode 100644 fs/proc/cmdline.c
 create mode 100644 fs/proc/cpuinfo.c
 create mode 100644 fs/proc/devices.c
 create mode 100644 fs/proc/interrupts.c
 create mode 100644 fs/proc/loadavg.c
 create mode 100644 fs/proc/meminfo.c
 create mode 100644 fs/proc/page.c
 delete mode 100644 fs/proc/proc_misc.c
 create mode 100644 fs/proc/stat.c
 create mode 100644 fs/proc/uptime.c
 create mode 100644 fs/proc/version.c
