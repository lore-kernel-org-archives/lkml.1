Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbYJFTRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbYJFTRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 15:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYJFTRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 15:17:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:59747 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbYJFTRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 15:17:37 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [git pull] kgdb 2.6.27-rc8 fixes 
Date: Mon,  6 Oct 2008 14:14:13 -0500
Message-Id: <1223320455-9266-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.2
X-OriginalArrivalTime: 06 Oct 2008 19:14:14.0964 (UTC) FILETIME=[B8E3DF40:01C927E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the kgdb git tree fixes for 2.6.27-rc8

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Summary: 

Testing the kgdb with kvm has found 2 problems:
 - NMI code has a race where it can be invoked twice
 - The softlockup watchdog must be touched when running
   with CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1, else
   the kernel executes a reboot if debugged for too long.
   

Short log follows:

--- 

Jan Kiszka (1):
      kgdb, x86: Avoid invoking kgdb_nmicallback twice per NMI

Jason Wessel (1):
      kgdb: call touch_softlockup_watchdog on resume

 arch/x86/kernel/kgdb.c |    7 +------
 kernel/kgdb.c          |    3 +++
 2 files changed, 4 insertions(+), 6 deletions(-)
