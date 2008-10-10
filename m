Return-Path: <linux-kernel-owner+w=401wt.eu-S1762208AbYJJSGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762208AbYJJSGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 14:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762728AbYJJSG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 14:06:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39306 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761331AbYJJSG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 14:06:26 -0400
Date: Fri, 10 Oct 2008 12:52:49 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 2.6.28
Message-ID: <20081010175249.GF4284@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull dlm updates for 2.6.28 from:

 git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

They have all been in linux-next for a long time.  There are two minor
enhancements in addition to the fixes.  The first allows a lockspace to be
created and used from both kernel and userspace threads at once.  This is to
support ocfs2 tools using the dlm along with the fs.  The second copies an
idea from ocfs2.  It allows the dlm to detect when the necessary userspace
control daemon fails, and to stop locking activity in response.

Thanks,
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

