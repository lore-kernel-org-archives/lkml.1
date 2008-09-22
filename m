Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbYIVSkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbYIVSkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbYIVSkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:40:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54648 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbYIVSkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:40:41 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] dlm patches for 2.6.28
Date: Mon, 22 Sep 2008 13:28:33 -0500
Message-Id: <1222108119-24928-1-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

These are the pending dlm patches for the 2.6.28 merge.  They have all
been in linux-next for quite a while.  There are two minor enhancements in
addition to the fixes.  The first allows a lockspace to be created and
used from both kernel and userspace threads at once.  This is to support
ocfs2 tools using the dlm along with the fs.  The second copies an idea
from ocfs2: it allows the dlm to detect when the necessary userspace
control daemon fails, and stop locking activity in response.
Dave


Andrew Morton (1):
      dlm: choose better identifiers

David Teigland (5):
      dlm: allow multiple lockspace creates
      dlm: detect available userspace daemon
      dlm: fix locking of lockspace list in dlm_scand
      dlm: fix address compare
      dlm: remove bkl


 fs/dlm/config.c             |   77 ++++++++++++++-------
 fs/dlm/dlm_internal.h       |    7 ++-
 fs/dlm/lockspace.c          |  158 ++++++++++++++++++++++++++++++++-----------
 fs/dlm/lockspace.h          |    1 +
 fs/dlm/user.c               |  124 +++++++++++++++++++++++++--------
 fs/dlm/user.h               |    4 +-
 fs/gfs2/locking/dlm/mount.c |    3 +-
 include/linux/dlm.h         |    5 +-
 include/linux/dlm_device.h  |    2 +-
 9 files changed, 281 insertions(+), 100 deletions(-)

