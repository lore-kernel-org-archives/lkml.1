Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbYIZSHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbYIZSHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 14:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYIZSGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 14:06:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:37181 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbYIZSGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 14:06:03 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [git pull] kgdb 2.6.27-rc7 fixes 
Date: Fri, 26 Sep 2008 13:05:15 -0500
Message-Id: <1222452320-16281-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.90.g436ed.dirty
X-OriginalArrivalTime: 26 Sep 2008 18:05:34.0581 (UTC) FILETIME=[78D1D250:01C92002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the kgdb git tree fixes for 2.6.27-rc7

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Summary: 

Several regressions have been fixed for which there was no automated test.
 - Fix regression in flushing data/instruction cache on boundaries
 - User space single stepping should be ignored by kgdb
 - x86_64 had the BX and DX registers reversed in gdb
 - x86_64 eflags, CS, SS, registers were not properly passed to gdb
 - tty_io.c has one function repaired which is only used kgdboc
   to hook up to the tty system.  The input args were not properly
   checked.  Test case was:
     "echo ffff0 > /sys/module/kgdboc/parameters/kgdboc"
   

Short log follows:

--- 

Atsuo Igarashi (1):
      kgdb: could not write to the last of valid memory with kgdb

Jason Wessel (4):
      kgdb, x86, arm, mips, powerpc: ignore user space single stepping
      kgdb, x86_64: gdb serial has BX and DX reversed
      kgdb, x86_64: fix PS CS SS registers in gdb serial
      kgdboc,tty: Fix tty polling search to use name correctly

 arch/arm/kernel/kgdb.c     |    2 --
 arch/mips/kernel/kgdb.c    |    3 +--
 arch/powerpc/kernel/kgdb.c |    5 ++---
 arch/x86/kernel/kgdb.c     |   43 ++++++++++++++++++++++++++++++++-----------
 drivers/char/tty_io.c      |   14 ++++++++++++--
 include/asm-x86/kgdb.h     |   24 +++++++++++-------------
 kernel/kgdb.c              |   10 +++++-----
 7 files changed, 63 insertions(+), 38 deletions(-)
