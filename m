Return-Path: <linux-kernel-owner+w=401wt.eu-S1765994AbYDVN4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765994AbYDVN4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763394AbYDVN4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:56:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763262AbYDVN4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:56:33 -0400
Date: Tue, 22 Apr 2008 08:51:16 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 2.6.26
Message-ID: <20080422135116.GA14594@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull dlm updates for 2.6.26 from:

 git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

They have been in linux-next and -mm for some time.  The only really notable
patch is the one that moves gfs2's posix lock handling into the dlm so that it
can be shared by both gfs2 and ocfs2.  The plock code isn't technically related
to the dlm, but it seems like a sensible common place for both gfs2 and ocfs2
to get to it.  It can also take advantage of the userspace cluster pieces
already in place for the dlm instead of replicating it.  The plock code was
never closely tied to gfs2 either, so the move required no functional changes.

Thanks,
Dave


Adrian Bunk (1):
      dlm: make dlm_print_rsb() static

David Teigland (4):
      dlm: save master info after failed no-queue request
      dlm: recover nodes that are removed and re-added
      dlm: move plock code from gfs2
      dlm: common max length definitions

Harvey Harrison (1):
      dlm: match signedness between dlm_config_info and cluster_set

Mike Frysinger (1):
      dlm: linux/{dlm,dlm_device}.h: cleanup for userspace


 fs/dlm/Makefile                |    1 +
 fs/dlm/config.c                |   50 ++++-
 fs/dlm/config.h                |    3 +-
 fs/dlm/dlm_internal.h          |    8 +-
 fs/dlm/lock.c                  |    5 +-
 fs/dlm/lock.h                  |    1 -
 fs/dlm/main.c                  |    7 +
 fs/dlm/member.c                |   34 +++-
 fs/dlm/plock.c                 |  439 ++++++++++++++++++++++++++++++++++++++++
 fs/dlm/recoverd.c              |    1 +
 fs/gfs2/locking/dlm/Makefile   |    2 +-
 fs/gfs2/locking/dlm/lock_dlm.h |   12 +-
 fs/gfs2/locking/dlm/main.c     |    8 -
 fs/gfs2/locking/dlm/mount.c    |   21 ++
 fs/gfs2/locking/dlm/plock.c    |  406 -------------------------------------
 include/linux/Kbuild           |    2 +-
 include/linux/dlm.h            |    7 +-
 include/linux/dlm_device.h     |   11 +-
 include/linux/dlm_plock.h      |   50 +++++
 include/linux/dlmconstants.h   |    4 +
 include/linux/lock_dlm_plock.h |   41 ----
 21 files changed, 614 insertions(+), 499 deletions(-)

