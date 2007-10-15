Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbXJORbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbXJORbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765605AbXJORa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:30:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59132 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765587AbXJORa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:30:58 -0400
Subject: [git pull] lockdep for v2.6.24
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 19:30:55 +0200
Message-Id: <1192469455.27435.87.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the lockdep tree from:

 git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git v2.6.24-lockdep

Ingo suggested to add me to the MAINTAINERS file for lockdep/lockstat.

The rest of the pull contains a few fixes, a few annotations and a new
'feature'. The new thing is ensuring we don't hold any locks when returning to
userspace. This will give a much earlier warning about imbalanced lock
acquisitions.

Peter

---
Gregory Haskins (1):
      lockdep: fix mismatched lockdep_depth/curr_chain_hash

Heiko Carstens (1):
      lockdep: s390: connect the sysexit hook

Peter Zijlstra (10):
      lockdep: maintainers
      lockdep: fixup mutex annotations
      lockdep: syscall exit check
      lockdep: i386: connect the sysexit hook
      lockdep: x86_64: connect the sysexit hook
      lockdep: annotate journal_start()
      lockdep: annotate rcu_read_{,un}lock{,_bh}
      lockdep: annotate kprobes irq fiddling
      lockdep: per filesystem inode lock class
      lockdep: annotate dir vs file i_mutex

Tim Pepper (1):
      lockdep: Avoid /proc/lockdep & lock_stat infinite output

 MAINTAINERS                   |    9 ++++++
 arch/s390/kernel/entry.S      |   12 ++++++++
 arch/s390/kernel/entry64.S    |    9 ++++++
 arch/x86/kernel/entry_32.S    |    4 +++
 arch/x86/kernel/entry_64.S    |   23 +++++++--------
 arch/x86/kernel/kprobes_32.c  |    7 +++++
 arch/x86/kernel/kprobes_64.c  |    7 +++++
 arch/x86/lib/thunk_64.S       |    4 +++
 fs/inode.c                    |   24 ++++++++++++++--
 fs/jbd/transaction.c          |    9 ++++++
 include/asm-x86/irqflags_32.h |   13 +++++++++
 include/asm-x86/irqflags_64.h |   14 +++++++++
 include/linux/fs.h            |    6 ++++
 include/linux/jbd.h           |    5 +++
 include/linux/lockdep.h       |    9 ++++++
 include/linux/mutex.h         |    9 ++++--
 include/linux/rcupdate.h      |   14 +++++++++
 kernel/lockdep.c              |   26 ++++++++++++++---
 kernel/lockdep_proc.c         |   61 ++++++++++++++++++++++++++++-------------
 kernel/mutex.c                |   35 +++++++++++++----------
 kernel/rcupdate.c             |    8 +++++
 21 files changed, 251 insertions(+), 57 deletions(-)


