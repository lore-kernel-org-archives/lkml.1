Return-Path: <linux-kernel-owner+w=401wt.eu-S1758568AbZFKTKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbZFKTKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbZFKTKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:10:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52221 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbZFKTKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:10:04 -0400
Subject: [GIT PULL] fsnotify notification infrastructure
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk, hch@infradead.org
Content-Type: text/plain
Date: Thu, 11 Jun 2009 15:09:13 -0400
Message-Id: <1244747353.3037.23.camel@dhcp231-142.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
   Please consider pulling the new filesystem notification patch queue
which has been in linux-next for a number of weeks. This patch series
implements a new generic infrastructure called fsnotify and reimplements
inotify-user and dnotify on top of the generic infrastructure.  I will
be working with Al in the coming days to find a way to merge the last in
kernel user of inotify (audit) so we can start start to kick that old
inotify code out.  Big winner here, new extensible notification
framework and we shrink struct inode.

-Eric

The following changes since commit c9059598ea8981d02356eead3188bf7fa4d717b8:
  Linus Torvalds (1):
        Merge branch 'for-2.6.31' of git://git.kernel.dk/linux-2.6-block

are available in the git repository at:

  git://git.infradead.org/users/eparis/notify.git for-linus

Eric Paris (16):
      fsnotify: unified filesystem notification backend
      fsnotify: add marks to inodes so groups can interpret how to handle those inodes
      fsnotify: parent event notification
      dnotify: reimplement dnotify using fsnotify
      fsnotify: generic notification queue and waitq
      fsnotify: include pathnames with entries when possible
      fsnotify: add correlations between events
      fsnotify: allow groups to add private data to events
      fsnotify: fsnotify marks on inodes pin them in core
      fsnotify: handle filesystem unmounts with fsnotify marks
      inotify: reimplement inotify using fsnotify
      fsnotify: move events should indicate the event was on a child
      dnotify: do not use ?true:false when assigning to a bool
      dnotify: do not bother to lock entry->lock when reading mask
      inotify/dnotify: should_send_event shouldn't match on FS_EVENT_ON_CHILD
      fsnotify: allow groups to set freeing_mark to null

 MAINTAINERS                          |    8 +-
 fs/inode.c                           |   10 +
 fs/notify/Kconfig                    |   13 +
 fs/notify/Makefile                   |    2 +
 fs/notify/dnotify/Kconfig            |    1 +
 fs/notify/dnotify/dnotify.c          |  464 +++++++++++++++-----
 fs/notify/fsnotify.c                 |  186 ++++++++
 fs/notify/fsnotify.h                 |   34 ++
 fs/notify/group.c                    |  254 ++++++++++
 fs/notify/inode_mark.c               |  426 +++++++++++++++++
 fs/notify/inotify/Kconfig            |   20 +-
 fs/notify/inotify/Makefile           |    2 +-
 fs/notify/inotify/inotify.c          |   20 +
 fs/notify/inotify/inotify.h          |   21 +
 fs/notify/inotify/inotify_fsnotify.c |  138 ++++++
 fs/notify/inotify/inotify_user.c     |  837 ++++++++++++++++------------------
 fs/notify/notification.c             |  411 +++++++++++++++++
 include/linux/dcache.h               |    4 +-
 include/linux/dnotify.h              |   29 +-
 include/linux/fs.h                   |    6 +-
 include/linux/fsnotify.h             |  199 +++++----
 include/linux/fsnotify_backend.h     |  387 ++++++++++++++++
 init/Kconfig                         |    3 +-
 23 files changed, 2813 insertions(+), 662 deletions(-)
 create mode 100644 fs/notify/fsnotify.c
 create mode 100644 fs/notify/fsnotify.h
 create mode 100644 fs/notify/group.c
 create mode 100644 fs/notify/inode_mark.c
 create mode 100644 fs/notify/inotify/inotify.h
 create mode 100644 fs/notify/inotify/inotify_fsnotify.c
 create mode 100644 fs/notify/notification.c
 create mode 100644 include/linux/fsnotify_backend.h


