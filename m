Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbZGUUD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbZGUUD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbZGUUD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:03:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52844 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbZGUUD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:03:56 -0400
Subject: [GIT PULL] notification tree - numerous inotify fixes
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 21 Jul 2009 16:03:37 -0400
Message-Id: <1248206617.2654.351.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus please consider pulling from the notification tree.  They are all
bug fixes in either inotify or fsnotify which were introduced with the
fsnotify conversion.  We've got a DoS, OOM, deadlock, functionality
regression, and all sorts of fun.....

-Eric

The following changes since commit aea1f7964ae6cba5eb419a958956deb9016b3341:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../sam/kbuild-fixes

are available in the git repository at:

  git://git.infradead.org/users/eparis/notify.git for-linus

Eric Paris (7):
      inotify: drop user watch count when a watch is removed
      inotify: do not leak inode marks in inotify_add_watch
      inotify: fix error paths in inotify_update_watch
      fsnotify: use def_bool in kconfig instead of letting the user choose
      inotify: check filename before dropping repeat events
      fsnotify: fix inotify tail drop check with path entries
      inotify: use GFP_NOFS under potential memory pressure

 fs/notify/Kconfig                |   12 +----
 fs/notify/dnotify/Kconfig        |    2 +-
 fs/notify/fsnotify.c             |    4 +-
 fs/notify/inotify/Kconfig        |    2 +-
 fs/notify/inotify/inotify_user.c |  109 ++++++++++++++++++++++++-------------
 fs/notify/notification.c         |   19 +++++--
 include/linux/fsnotify_backend.h |    2 +-
 7 files changed, 91 insertions(+), 59 deletions(-)


