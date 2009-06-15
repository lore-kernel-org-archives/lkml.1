Return-Path: <linux-kernel-owner+w=401wt.eu-S1759721AbZFOO7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721AbZFOO7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbZFOO7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:59:40 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:48338 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbZFOO7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:59:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=Zvr6UNqLMtInMnsR4Q939IMHJKCaBlsClk6CC6ueGihrGptirfGtzHEJ77xigt+6Lo
         XFHfLqqP0zA+Z+3bsyFomAh3Un8Uhha77NHaZriJn4gyvrf6fLgUkbmFFOveYFasOufg
         W72etr2vEm3+VXjIzszzoeYRM4FRuYgu5n5UQ=
Date: Mon, 15 Jun 2009 16:59:34 +0200
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] kmemcheck for mainline
Message-ID: <20090615145933.GA26856@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906120933120.3237@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

2009/6/12 Linus Torvalds <torvalds@linux-foundation.org>:
>
>
> On Fri, 12 Jun 2009, Vegard Nossum wrote:
>>
>> Please consider pulling the kmemcheck tree;
>
> No.
>
> This seems to be 99% merges o fother branches.
>

I redid the tree by rebasing. I've backported and incorporated fixes except
in the (few) cases where multiple authors were involved, in order to preserve
authorship information. I rebased against the same version that the previous
pull request was merged to; this allows us to easily view the difference
between the two pull requests (minus the top commit, which is a merge with
your latest tree):

  $ git diff kmemcheck/for-linus..kmemcheck/for-linus2^

and account for any discrepancies (see the bottom of this e-mail). I've
tested the new tree on x86 and x86_64 with and without kmemcheck.


The following changes since commit 45e3e1935e2857c54783291107d33323b3ef33c8:
  Linus Torvalds (1):
        Merge branch 'master' of git://git.kernel.org/.../sam/kbuild-next

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git for-linus2


(Note: The top commit is a merge with your latest tree to get rid of a
MAINTAINERS conflict; if you prefer to get rid of this merge commit as well,
you could merge for-linus2^ instead and resolve it yourself.)


Jeremy Fitzhardinge (2):
      x86: make _PAGE_HIDDEN conditional
      x86: unify pte_hidden

Pekka Enberg (9):
      slab: move struct kmem_cache to headers
      kmemcheck: add Vegard and Pekka to MAINTAINERS
      kmemcheck: remove forward declarations from error.c
      kmemcheck: make initialization message less confusing
      kmemcheck: remove multiple ifdef'd definitions of the same global variable
      kmemcheck: move 64-bit ifdef out of kmemcheck_opcode_decode()
      kmemcheck: use kmemcheck_pte_lookup() instead of open-coding it
      slab: add hooks for kmemcheck
      kmemcheck: make kconfig accessible for other architectures

Randy Dunlap (1):
      kmemcheck: include module.h to prevent warnings

Vegard Nossum (28):
      x86: add save_stack_trace_bp() for tracing from a specific stack frame
      stacktrace: add forward-declaration struct task_struct
      tasklets: new tasklet scheduling function
      kmemcheck: add the kmemcheck documentation
      kmemcheck: add the kmemcheck core
      x86: add hooks for kmemcheck
      kmemcheck: add mm functions
      kmemcheck: add DMA hooks
      slub: add hooks for kmemcheck
      crypto: don't track xor test pages with kmemcheck
      kmemcheck: don't track page tables
      kmemcheck: add hooks for page- and sg-dma-mappings
      kmemcheck: add hooks for the page allocator
      kmemcheck: enable in the x86 Kconfig
      kmemcheck: add opcode self-testing at boot
      kmemcheck: introduce bitfield API
      net: use kmemcheck bitfields API for skbuff
      net: annotate bitfields in struct inet_sock
      ieee1394: annotate bitfield
      ieee1394/csr1212: fix false positive kmemcheck report
      net: annotate inet_timewait_sock bitfields
      c2port: annotate bitfield for kmemcheck
      net: annotate struct sock bitfield
      trace: annotate bitfields in struct ring_buffer_event
      fs: introduce __getname_gfp()
      fs: fix do_mount_root() false positive kmemcheck warning
      signal: fix __send_signal() false positive kmemcheck warning
      Merge commit 'linus/master' into HEAD

 Documentation/kmemcheck.txt          |  773 ++++++++++++++++++++++++++++++++++
 MAINTAINERS                          |    8 +
 arch/x86/Kconfig                     |    1 +
 arch/x86/Makefile                    |    5 +
 arch/x86/include/asm/dma-mapping.h   |    7 +
 arch/x86/include/asm/kmemcheck.h     |   42 ++
 arch/x86/include/asm/pgtable.h       |    5 +
 arch/x86/include/asm/pgtable_types.h |    9 +-
 arch/x86/include/asm/string_32.h     |    8 +
 arch/x86/include/asm/string_64.h     |    8 +
 arch/x86/include/asm/thread_info.h   |    4 +-
 arch/x86/include/asm/xor.h           |    5 +
 arch/x86/kernel/cpu/intel.c          |   23 +
 arch/x86/kernel/process.c            |    2 +-
 arch/x86/kernel/stacktrace.c         |    7 +
 arch/x86/kernel/traps.c              |    5 +
 arch/x86/mm/Makefile                 |    2 +
 arch/x86/mm/fault.c                  |   18 +-
 arch/x86/mm/init.c                   |    2 +-
 arch/x86/mm/init_32.c                |    2 +-
 arch/x86/mm/init_64.c                |    4 +-
 arch/x86/mm/kmemcheck/Makefile       |    1 +
 arch/x86/mm/kmemcheck/error.c        |  228 ++++++++++
 arch/x86/mm/kmemcheck/error.h        |   15 +
 arch/x86/mm/kmemcheck/kmemcheck.c    |  640 ++++++++++++++++++++++++++++
 arch/x86/mm/kmemcheck/opcode.c       |  106 +++++
 arch/x86/mm/kmemcheck/opcode.h       |    9 +
 arch/x86/mm/kmemcheck/pte.c          |   22 +
 arch/x86/mm/kmemcheck/pte.h          |   10 +
 arch/x86/mm/kmemcheck/selftest.c     |   69 +++
 arch/x86/mm/kmemcheck/selftest.h     |    6 +
 arch/x86/mm/kmemcheck/shadow.c       |  162 +++++++
 arch/x86/mm/kmemcheck/shadow.h       |   16 +
 arch/x86/mm/pageattr.c               |    2 +-
 arch/x86/mm/pgtable.c                |   12 +-
 crypto/xor.c                         |    7 +-
 drivers/ieee1394/csr1212.c           |    2 +
 drivers/ieee1394/nodemgr.c           |    5 +
 drivers/misc/c2port/core.c           |    2 +
 include/linux/c2port.h               |    3 +
 include/linux/fs.h                   |    5 +-
 include/linux/gfp.h                  |   14 +-
 include/linux/interrupt.h            |   14 +
 include/linux/kmemcheck.h            |  153 +++++++
 include/linux/mm_types.h             |    8 +
 include/linux/ring_buffer.h          |    4 +
 include/linux/skbuff.h               |    7 +
 include/linux/slab.h                 |    7 +
 include/linux/slab_def.h             |   81 ++++
 include/linux/stacktrace.h           |    3 +
 include/net/inet_sock.h              |   14 +-
 include/net/inet_timewait_sock.h     |    5 +-
 include/net/sock.h                   |    2 +
 init/do_mounts.c                     |    3 +-
 init/main.c                          |    1 +
 kernel/fork.c                        |   14 +-
 kernel/signal.c                      |   11 +-
 kernel/softirq.c                     |   11 +
 kernel/sysctl.c                      |   12 +
 kernel/trace/ring_buffer.c           |    3 +
 lib/Kconfig.debug                    |    6 +-
 lib/Kconfig.kmemcheck                |   91 ++++
 mm/Kconfig.debug                     |    1 +
 mm/Makefile                          |    1 +
 mm/kmemcheck.c                       |  122 ++++++
 mm/page_alloc.c                      |   18 +
 mm/slab.c                            |  108 +----
 mm/slub.c                            |   38 ++-
 net/core/skbuff.c                    |    8 +
 net/core/sock.c                      |    2 +
 net/ipv4/inet_timewait_sock.c        |    3 +
 71 files changed, 2899 insertions(+), 128 deletions(-)
 create mode 100644 Documentation/kmemcheck.txt
 create mode 100644 arch/x86/include/asm/kmemcheck.h
 create mode 100644 arch/x86/mm/kmemcheck/Makefile
 create mode 100644 arch/x86/mm/kmemcheck/error.c
 create mode 100644 arch/x86/mm/kmemcheck/error.h
 create mode 100644 arch/x86/mm/kmemcheck/kmemcheck.c
 create mode 100644 arch/x86/mm/kmemcheck/opcode.c
 create mode 100644 arch/x86/mm/kmemcheck/opcode.h
 create mode 100644 arch/x86/mm/kmemcheck/pte.c
 create mode 100644 arch/x86/mm/kmemcheck/pte.h
 create mode 100644 arch/x86/mm/kmemcheck/selftest.c
 create mode 100644 arch/x86/mm/kmemcheck/selftest.h
 create mode 100644 arch/x86/mm/kmemcheck/shadow.c
 create mode 100644 arch/x86/mm/kmemcheck/shadow.h
 create mode 100644 include/linux/kmemcheck.h
 create mode 100644 lib/Kconfig.kmemcheck
 create mode 100644 mm/kmemcheck.c

============================================

These are the differences since previous pull request, with some inline
comments explaining why they're there. I don't actually expect you to look at
this, but in case you do, here's proof that I was very careful to ensure that
my rebase didn't do anything I didn't intend to do (that should make up for
the fact that the tree was rebased not so many hours ago, and thus has lost
some of the credibility of months of testing in Ingo's test farm).

$ git diff --stat kmemcheck/for-linus..kmemcheck/for-linus2^

 MAINTAINERS                        |   12 ++++++------
[reordered to match alphabetical order]

 arch/x86/Kconfig.debug             |    1 -
[this was the result of a mismerge; fixed now]

 arch/x86/include/asm/dma-mapping.h |    7 +++----
[call kmemcheck hooks _after_ the sanity checks]

 arch/x86/include/asm/page_types.h  |    8 --------
[zapped unrelated patch]

 arch/x86/include/asm/pgtable.h     |   10 +++++-----
[moved pte_hidden() to stay with the other pte_*() functions]

 arch/x86/kernel/setup.c            |    1 -
[zapped unrelated patch]

 arch/x86/kernel/traps.c            |    2 +-
[include file reorder]

 arch/x86/mm/init.c                 |   13 ++++++-------
 arch/x86/mm/init_32.c              |   28 ++++++++--------------------
 arch/x86/mm/init_64.c              |   33 ++++++++++++++-------------------
[zapped unrelated patch]

 arch/x86/mm/kmemcheck/kmemcheck.c  |    7 +++++--
 include/linux/kmemcheck.h          |    8 ++------
 init/main.c                        |    5 +----
[made kmemcheck_init() an early initcall]

 kernel/sysctl.c                    |   21 +++++++++++----------
[use /proc/sys/kernel/kmemcheck instead of /proc/sys/vm/kmemcheck; mismerge fix]

 mm/Kconfig.debug                   |    1 +
[the second half of the mismerge in arch/x86/Kconfig.debug; see above]

 mm/slab.c                          |    2 +-
[bugfix]

 mm/slub.c                          |    2 +-
[include file reorder]

 17 files changed, 65 insertions(+), 96 deletions(-)


Vegard
