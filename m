Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbXJKVEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbXJKVEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbXJKVD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:03:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57952 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbXJKVD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:03:56 -0400
Subject: What's in v2.6.24-lockdep
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Thu, 11 Oct 2007 23:03:03 +0200
Message-Id: <1192136583.5797.20.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A heads up of what I inted to present for merging in v2.6.24.

  - Peter (who is new at this game) Zijlstra


against the current x86 tree

git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git v2.6.24-lockdep

Gregory Haskins (1):
      lockdep: fix mismatched lockdep_depth/curr_chain_hash

Heiko Carstens (1):
      lockdep: s390: connect the sysexit hook

Peter Zijlstra (8):
      lockdep: maintainers
      lockdep: fixup mutex annotations
      lockdep: syscall exit check
      lockdep: i386: connect the sysexit hook
      lockdep: x86_64: connect the sysexit hook
      lockdep: annotate journal_start()
      lockdep: annotate rcu_read_{,un}lock{,_bh}
      lockdep: annotate kprobes irq fiddling

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
 fs/jbd/transaction.c          |    9 ++++++
 include/asm-x86/irqflags_32.h |   13 +++++++++
 include/asm-x86/irqflags_64.h |   14 +++++++++
 include/linux/jbd.h           |    5 +++
 include/linux/lockdep.h       |    9 ++++++
 include/linux/mutex.h         |    9 ++++--
 include/linux/rcupdate.h      |   14 +++++++++
 kernel/lockdep.c              |   26 ++++++++++++++---
 kernel/lockdep_proc.c         |   61 ++++++++++++++++++++++++++++-------------
 kernel/mutex.c                |   35 +++++++++++++----------
 kernel/rcupdate.c             |    8 +++++
 19 files changed, 224 insertions(+), 54 deletions(-)


