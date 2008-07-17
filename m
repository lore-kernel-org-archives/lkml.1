Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbYGQHL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbYGQHL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbYGQHLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:11:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbYGQHLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:11:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 0/5] ptrace & wait cleanup
X-Zippy-Says: I've got a COUSIN who works in the GARMENT DISTRICT...
Message-Id: <20080717071141.012BD15411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:11:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I posted an earlier version of this patch series before, and I believe
this has fixed the quibbles there were with it before.  These changes
pave the way for cleaning up ptrace a lot more in the future.

This series is a prerequisite for the following "tracehook" series,
but only because of patch conflicts.  They can be reviewed separately.

This series of patches is also available in GIT at the URL below, and in a
mail folder of patch messages (use git-am or formail -s patch -p1) at:
	http://people.redhat.com/roland/utrace/2.6-current/ptrace-cleanup.mbox

The following changes since commit 33af79d12e0fa25545d49e86afc67ea8ad5f2f40:
  Chandra Seetharaman (1):
        scsi_dh: Verify "dev" is a sdev before accessing it.

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-utrace.git ptrace-cleanup

Roland McGrath (4):
      do_wait reorganization
      ptrace children revamp
      do_wait: return security_task_wait() error code in place of -ECHILD
      fix dangling zombie when new parent ignores children

 include/linux/init_task.h |    4 +-
 include/linux/sched.h     |   26 ++--
 kernel/exit.c             |  451 +++++++++++++++++++++++++++-----------------
 kernel/fork.c             |    6 +-
 kernel/ptrace.c           |   37 +++--
 5 files changed, 318 insertions(+), 206 deletions(-)


Thanks,
Roland
