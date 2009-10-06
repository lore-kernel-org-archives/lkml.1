Return-Path: <linux-kernel-owner+w=401wt.eu-S932626AbZJFR04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbZJFR04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932351AbZJFR0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:26:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:36892 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932326AbZJFR0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:26:54 -0400
Date: Tue, 6 Oct 2009 17:26:02 +0000
From: Kyle McMartin <kyle@hera.kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: [git patches] parisc for 2.6.32
Message-ID: <20091006172602.GA1924@hera.kernel.org>
Reply-To: kyle@mcmartin.ca
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 06 Oct 2009 17:26:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly fixes, except for the tracehook stuff... then again cleaning up
ptrace is a pretty big fix in and of itself. ;-)

The following changes since commit 17d857be649a21ca90008c6dc425d849fa83db5c:
  Linus Torvalds (1):
        Linux 2.6.32-rc1

are available in the git repository at:

  hera.kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6.git fixes

Christoph Hellwig (1):
      parisc: convert to asm-generic/hardirq.h

Helge Deller (3):
      parisc: rename parisc's vmalloc_start to parisc_vmalloc_start
      parisc: Fix linker script breakage.
      agp: parisc-agp.c - use correct page_mask function

James Bottomley (1):
      parisc: add me to Maintainers

Jaswinder Singh Rajput (1):
      parisc: includecheck fix: signal.c

Julia Lawall (1):
      parisc: correct use of SHF_ALLOC

Kyle McMartin (7):
      parisc: tracehook_report_syscall
      parisc: tracehook_signal_handler
      parisc: add missing TI_TASK macro in syscall.S
      parisc: split syscall_trace into two halves
      parisc: stop using task->ptrace for {single,block}step flags
      parisc: add skeleton syscall.h
      parisc: HAVE_ARCH_TRACEHOOK

Tim Abbott (1):
      parisc: Make THREAD_SIZE available to assembly files and linker scripts.

 MAINTAINERS                           |    1 +
 arch/parisc/Kconfig                   |    1 +
 arch/parisc/include/asm/fixmap.h      |    4 +-
 arch/parisc/include/asm/hardirq.h     |   20 +---------------
 arch/parisc/include/asm/ptrace.h      |    5 +++-
 arch/parisc/include/asm/syscall.h     |   40 +++++++++++++++++++++++++++++++
 arch/parisc/include/asm/thread_info.h |   14 +++++++----
 arch/parisc/kernel/asm-offsets.c      |    4 +-
 arch/parisc/kernel/entry.S            |   21 ++++++++--------
 arch/parisc/kernel/irq.c              |    5 ----
 arch/parisc/kernel/module.c           |    2 +-
 arch/parisc/kernel/ptrace.c           |   42 ++++++++++++++++----------------
 arch/parisc/kernel/signal.c           |    5 +++-
 arch/parisc/kernel/syscall.S          |   22 +++++++++++------
 arch/parisc/kernel/vmlinux.lds.S      |   10 ++++++++
 arch/parisc/mm/init.c                 |   11 ++++----
 drivers/char/agp/parisc-agp.c         |    2 +-
 17 files changed, 128 insertions(+), 81 deletions(-)
 create mode 100644 arch/parisc/include/asm/syscall.h
