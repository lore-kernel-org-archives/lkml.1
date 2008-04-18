Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbYDRSSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbYDRSSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 14:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759546AbYDRSRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 14:17:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759535AbYDRSRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 14:17:39 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] dlm patches for 2.6.26
Date: Fri, 18 Apr 2008 13:12:42 -0500
Message-Id: <1208542368-13417-1-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

These are the pending dlm patches for the 2.6.26 merge.  They have all been
in linux-next and -mm for some time.  The only really notable patch is the
one that moves gfs2's posix lock handling into the dlm so that it can be
shared by both gfs2 and ocfs2.  The plock code isn't technically related to
the dlm, but it seems like a sensible common place for both gfs2 and ocfs2 to
get to it.  It can also take advantage of the userspace cluster pieces
already in place for the dlm instead of replicating it.  The plock code
was never closely tied to gfs2 either, so the move required no functional
changes.  Dave


Adrian Bunk (1):
      dlm: make dlm_print_rsb() static

David Teigland (4):
      dlm: save master info after failed no-queue request
      dlm: recover nodes that are removed and re-added
      dlm: move plock code from gfs2
      dlm: common max length definitions

Harvey Harrison (1):
      dlm: match signedness between dlm_config_info and cluster_set


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
 fs/gfs2/locking/dlm/lock_dlm.h |   11 +-
 fs/gfs2/locking/dlm/main.c     |    8 -
 fs/gfs2/locking/dlm/mount.c    |   21 ++
 fs/gfs2/locking/dlm/plock.c    |  406 -------------------------------------
 include/linux/Kbuild           |    2 +-
 include/linux/dlm.h            |    4 -
 include/linux/dlm_device.h     |    3 -
 include/linux/dlm_plock.h      |   50 +++++
 include/linux/dlmconstants.h   |    4 +
 include/linux/lock_dlm_plock.h |   41 ----
 21 files changed, 604 insertions(+), 497 deletions(-)

