Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab0CHU4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:56:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab0CHU4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:56:08 -0500
Subject: [GIT PULL] notification: after one week
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 15:55:39 -0500
Message-ID: <1268081739.3227.5.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having you tell me to wait a week after rebasing (and probably being the
only person who waited a week after rebasing to ask for a pull) I'm
back.  I hoped to hear some review but none came.  If it does, rest
assured addressing those issues will be my top priority.  Since the last
pull request the only change is that I corrected the build flags to not
add -Wsigned-pointer and I actually dropped the permissions bits from
this branch (those bits are and have been in linux-next for a long time
now as well though)

-Eric

The following changes since commit
3a5b27bf6f29574d667230c7e76e4b83fe3014e0:
  Linus Torvalds (1):
        Merge branch 'for-linus' of
git://gitorious.org/linux-omap-dss2/linux

are available in the git repository at:

  git://git.infradead.org/users/eparis/notify.git for-linus

Al Viro (2):
      Lose the new_name argument of fsnotify_move()
      Lose the first argument of audit_inode_child()

Alexey Dobriyan (1):
      dnotify: move dir_notify_enable declaration

Andreas Gruenbacher (15):
      fsnotify: kill FSNOTIFY_EVENT_FILE
      fsnotify: take inode->i_lock inside fsnotify_find_mark_entry()
      fanotify: create_fd cleanup
      fanotify: Add pids to events
      fsnotify/vfsmount: add fsnotify fields to struct vfsmount
      fsnotify: Infrastructure for per-mount watches
      fanotify: remove fanotify_update_mark
      fanotify: do not call fanotify_update_object_mask in
fanotify_remove_mark
      fanotify: do not call fanotify_update_object_mask in
fanotify_add_mark
      fanotify: do not return pointer from fanotify_add_*_mark
      fanotify: remove fanotify_add_mark
      fanotify: rename FAN_MARK_ON_VFSMOUNT to FAN_MARK_MOUNT
      fanotify: split fanotify_remove_mark
      fanotify: remove fanotify.h declarations
      fanotify: remove outgoing function checks in fanotify.h

Dave Young (1):
      sysctl extern cleanup: inotify

Eric Paris (72):
      inotify: simplify the inotify idr handling
      Audit: clean up the audit_watch split
      audit: convert audit watches to use fsnotify instead of inotify
      audit: redo audit watch locking and refcnt in light of fsnotify
      audit: do not get and put just to free a watch
      fsnotify: duplicate fsnotify_mark_entry data between 2 marks
      fsnotify: allow addition of duplicate fsnotify marks
      audit: reimplement audit_trees using fsnotify rather than inotify
      Audit: audit watches depend on fsnotify
      Audit: split audit watch Kconfig
      Audit: audit watch init should not be before fsnotify init
      fsnotify: use fsnotify_create_event to allocate the q_overflow
event
      inotify: use container_of instead of casting
      fsnotify: kzalloc fsnotify groups
      fsnotify: use kmem_cache_zalloc to simplify event initialization
      inotify: do not reuse watch descriptors
      inotify: remove inotify in kernel interface
      inotify: do not spam console without limit
      fsnotify: provide the data type to should_send_event
      fsnotify: include data in should_send calls
      fsnotify: pass a file instead of an inode to open, read, and write
      fsnotify: send struct file when sending events to parents when
possible
      fsnotify: per group notification queue merge types
      fsnotify: clone existing events
      fsnotify: replace an event on a list
      fsnotify: lock annotation for event replacement
      fsnotify: remove group_num altogether
      fsnotify: fsnotify_obtain_group kzalloc cleanup
      fsnotify: fsnotify_obtain_group should be fsnotify_alloc_group
      Audit: only set group mask when something is being watched
      fsnotify: drop mask argument from fsnotify_alloc_group
      fsnotify: rename fsnotify_groups to fsnotify_inode_groups
      fsnotify: initialize the group->num_marks in a better place
      fsnotify: add groups to fsnotify_inode_groups when registering
inode watch
      fsnotify: mount point listeners list and global mask
      fsnotify: include vfsmount in should_send_event when appropriate
      fsnotify: put inode specific fields in an fsnotify_mark in a union
      fsnotify: add vfsmount specific fields to the fsnotify_mark_entry
union
      fsnotify: add flags to fsnotify_mark_entries
      fsnotify: rename fsnotify_mark_entry to just fsnotify_mark
      fsnotify: rename fsnotify_find_mark_entry to fsnotify_find_mark
      fsnotify: rename mark_entry to just mark
      inotify: rename mark_entry to just mark
      dnotify: rename mark_entry to mark
      vfs: introduce FMODE_NONOTIFY
      fanotify: fscking all notification system
      fanotify:drop notification if they exist in the outgoing queue
      fanotify: merge notification events with different masks
      fanotify: do not clone on merge unless needed
      fanotify: fanotify_init syscall declaration
      fanotify: fanotify_init syscall implementation
      fanotify: sys_fanotify_mark declartion
      fanotify: fanotify_mark syscall implementation
      fanotify: send events using read
      fsnotify: split generic and inode specific mark code
      fsnotify: clear marks to 0 in fsnotify_init_mark
      fsnotify: vfsmount marks generic functions
      fanotify: should_send_event needs to handle vfsmounts
      fanotify: infrastructure to add an remove marks on vfsmounts
      fanotify: hooks the fanotify_mark syscall to the vfsmount code
      fsnotify: allow marks to not pin inodes in core
      fsnotify: ignored_mask - excluding notification
      fanotify: ignored_mask to ignore events
      fanotify: allow users to set an ignored_mask
      fsnotify: clear ignored mask on modify
      fsnotify: allow ignored_mask to survive modification
      fanotify: allow ignored_masks to survive modify
      fanotify: clear all fanotify marks
      fsnotify: add group priorities
      fsnotify: intoduce a notification merge argument
      fanotify: use merge argument to determine actual event added to
queue
      fsnotify: use unsigned char * for dentry->d_name.name

Heiko Carstens (1):
      fanotify: CONFIG_HAVE_SYSCALL_WRAPPERS for sys_fanotify_mark

Paul Mundt (1):
      fanotify: select ANON_INODES.

Signed-off-by: Wu Fengguang (1):
      fanotify: FMODE_NONOTIFY and __O_SYNC in sparc conflict

 Documentation/feature-removal-schedule.txt |    8 -
 arch/x86/ia32/ia32entry.S                  |    2 +
 arch/x86/ia32/sys_ia32.c                   |    9 +
 arch/x86/include/asm/sys_ia32.h            |    3 +
 arch/x86/include/asm/unistd_32.h           |    4 +-
 arch/x86/include/asm/unistd_64.h           |    4 +
 arch/x86/kernel/syscall_table_32.S         |    2 +
 fs/compat.c                                |    5 +-
 fs/debugfs/inode.c                         |    2 +-
 fs/exec.c                                  |    4 +-
 fs/inode.c                                 |    8 +-
 fs/namei.c                                 |   10 +-
 fs/namespace.c                             |    5 +
 fs/nfsd/vfs.c                              |    4 +-
 fs/notify/Kconfig                          |    1 +
 fs/notify/Makefile                         |    4 +-
 fs/notify/dnotify/dnotify.c                |  198 +++----
 fs/notify/fanotify/Kconfig                 |   12 +
 fs/notify/fanotify/Makefile                |    1 +
 fs/notify/fanotify/fanotify.c              |  206 ++++++
 fs/notify/fanotify/fanotify_user.c         |  601 ++++++++++++++++++
 fs/notify/fsnotify.c                       |  138 ++++-
 fs/notify/fsnotify.h                       |   33 +-
 fs/notify/group.c                          |  178 +++---
 fs/notify/inode_mark.c                     |  309 +++-------
 fs/notify/inotify/Kconfig                  |   15 -
 fs/notify/inotify/Makefile                 |    1 -
 fs/notify/inotify/inotify.c                |  933
----------------------------
 fs/notify/inotify/inotify.h                |    7 +-
 fs/notify/inotify/inotify_fsnotify.c       |  114 +++-
 fs/notify/inotify/inotify_user.c           |  305 ++++++----
 fs/notify/mark.c                           |  325 ++++++++++
 fs/notify/notification.c                   |  180 +++---
 fs/notify/vfsmount_mark.c                  |  176 ++++++
 fs/open.c                                  |    3 +-
 fs/read_write.c                            |    8 +-
 include/asm-generic/fcntl.h                |    8 +
 include/linux/Kbuild                       |    1 +
 include/linux/audit.h                      |   11 +-
 include/linux/dnotify.h                    |    1 +
 include/linux/fanotify.h                   |   82 +++
 include/linux/fs.h                         |   16 +-
 include/linux/fsnotify.h                   |  152 ++---
 include/linux/fsnotify_backend.h           |  146 +++--
 include/linux/inotify.h                    |  175 +-----
 include/linux/mount.h                      |    6 +-
 include/linux/syscalls.h                   |    5 +
 init/Kconfig                               |   10 +-
 kernel/Makefile                            |    5 +-
 kernel/audit.c                             |    1 -
 kernel/audit.h                             |   26 +-
 kernel/audit_tree.c                        |  232 ++++---
 kernel/audit_watch.c                       |  295 +++++----
 kernel/auditfilter.c                       |   39 +-
 kernel/auditsc.c                           |   17 +-
 kernel/sys_ni.c                            |    4 +
 kernel/sysctl.c                            |    7 +-
 57 files changed, 2794 insertions(+), 2263 deletions(-)
 create mode 100644 fs/notify/fanotify/Kconfig
 create mode 100644 fs/notify/fanotify/Makefile
 create mode 100644 fs/notify/fanotify/fanotify.c
 create mode 100644 fs/notify/fanotify/fanotify_user.c
 delete mode 100644 fs/notify/inotify/inotify.c
 create mode 100644 fs/notify/mark.c
 create mode 100644 fs/notify/vfsmount_mark.c
 create mode 100644 include/linux/fanotify.h

