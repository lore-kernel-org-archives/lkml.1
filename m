Return-Path: <linux-kernel-owner+w=401wt.eu-S932412AbZLKPhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412AbZLKPhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759116AbZLKPhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:37:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:57529 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758988AbZLKPhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:37:08 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [GIT PULL] kgdb 2.6.33
Date: Fri, 11 Dec 2009 09:36:08 -0600
Message-Id: <1260545777-8089-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 11 Dec 2009 15:36:24.0222 (UTC) FILETIME=[B2292BE0:01CA7A77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the kgdb git tree for 2.6.33

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Summary: 

The patches in this series have been in linux-next and thoroughly
tested over the last two kernel cycles.  There are no new features
here, everything is just a fix against a problem found in the use of
kgdb.

The perf event API merge has caused kgdb's HW breakpoint support to
cease working.  This makes the kgdb test suite fail and hang the
kernel in most cases (you would see this with a allyesconfig).  I have
an experimental patch which I will work with the perf event
maintainers to repair the kgdb hw breakpoint support during the
2.6.33 cycle.

Thanks,
Jason.
   
Short log follows:

--- 

Geert Uytterhoeven (1):
      kgdb: Replace strstr() by strchr() for single-character needles

Jason Wessel (6):
      kgdb: Read buffer overflow
      kgdb,i386: Fix corner case access to ss with NMI watch dog exception
      kgdb: allow for cpu switch when single stepping
      kgdb,x86: do not set kgdb_single_step on x86
      kgdb: continue and warn on signal passing from gdb
      kgdb: Always process the whole breakpoint list on activate or deactivate

Roel Kluin (2):
      kgdb,x86: remove redundant test
      kgdbts: Read buffer overflow

 arch/x86/kernel/kgdb.c |   14 +++++++----
 drivers/misc/kgdbts.c  |   14 ++++++++---
 kernel/kgdb.c          |   56 ++++++++++++++++++++++++++++++++++-------------
 3 files changed, 59 insertions(+), 25 deletions(-)
