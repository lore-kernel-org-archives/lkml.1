Return-Path: <linux-kernel-owner+w=401wt.eu-S1752268AbZLWFoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbZLWFoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 00:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbZLWFoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 00:44:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbZLWFoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 00:44:06 -0500
Subject: Re: [GIT -maybe- PULL] notification - fanotify
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk, hch@infradead.org
In-Reply-To: <1261104984.2868.39.camel@localhost>
References: <1261104984.2868.39.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Dec 2009 00:43:49 -0500
Message-ID: <1261547029.6283.50.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 21:56 -0500, Eric Paris wrote:
> This pull is the basics of fanotify as a notification mechanism.  It has
> been in linux-next for months without any complaints.  I know both viro
> and hch have concerns that neither of them have reviewed the code.  I'm
> putting it out because code has been available in some similar (although
> with a changing user interface) for more than 2 years or so at this
> point and without me asking it to be pulled I assume it will continue to
> be ignored.  If either would like to NAK the code and publicly agree to
> review in the next cycle that seems reasonable.  The user interface has
> seen many comments which have all (it appears) been addresses, but the
> internals are admittedly lacking in intelligent review.  Getting
> notification in order is my highest priority for my paying job and I'm
> willing to address any issues anyone have.  But after years of hoping
> and having gone an entire cycle on list and in linux-next with neither a
> single suggestion nor problem I put it forth to the list for acceptance.
> (there are some known feature requests though)
> 
> This code does NOT do any kind of permissions checking.  It is purely a
> novel notification system which includes an fd with the event.  I have
> another branch with permissions and blocking which makes this usable to
> AV, HSM, and other 3rd party vendors.  I am not proposing that for this
> cycle.  The main issue of this patch is that it adds two syscalls.
> 
> SYSCALL_DEFINE3(fanotify_init, unsigned int, flags, unsigned int,
> 		event_f_flags, unsigned int, priority)
> SYSCALL_DEFINE(fanotify_mark)(int fanotify_fd, unsigned int flags,
> 			      __u64 mask, int dfd,
> 			      const char  __user * pathname)
> 
> These are the only 2 syscalls needed to implement all of the fanotify
> requests to date (including permissions and blocking)
> 
> Please, if people object speak up.  This has gone on long enough.

This branch is still here and still hoping to be pulled although I know
holding my request until the VFS branch was pulled (this branch required
those changed) delayed it until hours before the merge window closure
was announced.

Would someone like to object technically and give reasons?  I've got
users lined and hoping to go on this.  If I'm rejected solely due to
timing I'll just go sulk in my corner knowing the path is free and clear
for .34.

The following changes since commit 2330021862b003962fd615df63af5a4ecfc9622a:
  Eric Paris (1):
        inotify: do not spam console without limit

are available in the git repository at:

  git://git.infradead.org/users/eparis/notify.git for-linus-fanotify

Andreas Gruenbacher (15):
      fsnotify: kill FSNOTIFY_EVENT_FILE
      fsnotify: take inode->i_lock inside fsnotify_find_mark_entry()
      fanotify: create_fd cleanup
      fanotify: Add pids to events
      fsnotify/vfsmount: add fsnotify fields to struct vfsmount
      fsnotify: Infrastructure for per-mount watches
      fanotify: remove fanotify_update_mark
      fanotify: do not call fanotify_update_object_mask in fanotify_remove_mark
      fanotify: do not call fanotify_update_object_mask in fanotify_add_mark
      fanotify: do not return pointer from fanotify_add_*_mark
      fanotify: remove fanotify_add_mark
      fanotify: rename FAN_MARK_ON_VFSMOUNT to FAN_MARK_MOUNT
      fanotify: split fanotify_remove_mark
      fanotify: remove fanotify.h declarations
      fanotify: remove outgoing function checks in fanotify.h

Eric Paris (42):
      fsnotify: provide the data type to should_send_event
      fsnotify: include data in should_send calls
      fsnotify: pass a file instead of an inode to open, read, and write
      fsnotify: send struct file when sending events to parents when possible
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
      fsnotify: add groups to fsnotify_inode_groups when registering inode watch
      fsnotify: mount point listeners list and global mask
      fsnotify: include vfsmount in should_send_event when appropriate
      fsnotify: put inode specific fields in an fsnotify_mark in a union
      fsnotify: add vfsmount specific fields to the fsnotify_mark_entry union
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

Heiko Carstens (1):
      fanotify: CONFIG_HAVE_SYSCALL_WRAPPERS for sys_fanotify_mark

Paul Mundt (1):
      fanotify: select ANON_INODES.

 arch/x86/ia32/ia32entry.S            |    2 +
 arch/x86/ia32/sys_ia32.c             |    9 +
 arch/x86/include/asm/sys_ia32.h      |    3 +
 arch/x86/include/asm/unistd_32.h     |    4 +-
 arch/x86/include/asm/unistd_64.h     |    4 +
 arch/x86/kernel/syscall_table_32.S   |    2 +
 fs/compat.c                          |    5 +-
 fs/exec.c                            |    4 +-
 fs/inode.c                           |    2 +-
 fs/namespace.c                       |    5 +
 fs/nfsd/vfs.c                        |    4 +-
 fs/notify/Kconfig                    |    1 +
 fs/notify/Makefile                   |    4 +-
 fs/notify/dnotify/dnotify.c          |  198 ++++++-------
 fs/notify/fanotify/Kconfig           |   12 +
 fs/notify/fanotify/Makefile          |    1 +
 fs/notify/fanotify/fanotify.c        |  184 +++++++++++
 fs/notify/fanotify/fanotify_user.c   |  573 ++++++++++++++++++++++++++++++++++
 fs/notify/fsnotify.c                 |  104 +++++--
 fs/notify/fsnotify.h                 |   31 ++-
 fs/notify/group.c                    |  140 ++++-----
 fs/notify/inode_mark.c               |  282 +++--------------
 fs/notify/inotify/inotify.h          |    7 +-
 fs/notify/inotify/inotify_fsnotify.c |  112 +++++--
 fs/notify/inotify/inotify_user.c     |  209 ++++++-------
 fs/notify/mark.c                     |  293 +++++++++++++++++
 fs/notify/notification.c             |  155 ++++++----
 fs/notify/vfsmount_mark.c            |  171 ++++++++++
 fs/open.c                            |    2 +-
 fs/read_write.c                      |    8 +-
 include/asm-generic/fcntl.h          |    8 +
 include/linux/Kbuild                 |    1 +
 include/linux/fanotify.h             |   77 +++++
 include/linux/fs.h                   |    8 +-
 include/linux/fsnotify.h             |   87 ++++--
 include/linux/fsnotify_backend.h     |  122 +++++---
 include/linux/mount.h                |    6 +-
 include/linux/syscalls.h             |    5 +
 kernel/audit_tree.c                  |   53 ++--
 kernel/audit_watch.c                 |   38 ++-
 kernel/auditsc.c                     |    4 +-
 kernel/sys_ni.c                      |    4 +
 42 files changed, 2149 insertions(+), 795 deletions(-)
 create mode 100644 fs/notify/fanotify/Kconfig
 create mode 100644 fs/notify/fanotify/Makefile
 create mode 100644 fs/notify/fanotify/fanotify.c
 create mode 100644 fs/notify/fanotify/fanotify_user.c
 create mode 100644 fs/notify/mark.c
 create mode 100644 fs/notify/vfsmount_mark.c
 create mode 100644 include/linux/fanotify.h

