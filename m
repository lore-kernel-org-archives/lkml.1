Return-Path: <linux-kernel-owner+w=401wt.eu-S934779AbYEBSJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934779AbYEBSJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759816AbYEBSJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:09:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42335 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbYEBSJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:09:24 -0400
Date: Fri, 2 May 2008 19:09:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] more vfs patches
Message-ID: <20080502180922.GG5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Sanitizing files_struct handling (all internals taken from file.h
to fdtable.h, which is pulled by few files that need it, a bunch of places
in arch/* switched to saner ways of doing things that do not need to know
about low-level stuff, perfmon abuses of files_struct fixed along with
a huge pile of races).  Sanitized anon_inode_getfd() - the API had been
inherently racy.  Dealt with the fallout of making OPEN_NR a sysctl.

	Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (6):
      fix file and descriptor handling in perfmon
      remove horrors with irix tty ioctls handling
      make osf_select() use core_sys_select()
      split linux/file.h
      sanitize anon_inode_getfd()
      fix sysctl_nr_open bugs

Diffstat:
 arch/alpha/kernel/osf_sys.c                  |   69 +---------
 arch/ia64/kernel/perfmon.c                   |  199 +++++++++++---------------
 arch/mips/kernel/irixioctl.c                 |   55 ++------
 arch/mips/kernel/kspd.c                      |    1 +
 arch/powerpc/platforms/cell/spufs/coredump.c |    1 +
 drivers/char/tty_audit.c                     |    1 +
 drivers/char/tty_io.c                        |    1 +
 fs/anon_inodes.c                             |   13 +--
 fs/compat.c                                  |    1 +
 fs/dnotify.c                                 |    2 +-
 fs/eventfd.c                                 |   15 +--
 fs/eventpoll.c                               |   23 +--
 fs/exec.c                                    |    1 +
 fs/fcntl.c                                   |    1 +
 fs/file.c                                    |   23 +++-
 fs/file_table.c                              |    1 +
 fs/locks.c                                   |    1 +
 fs/open.c                                    |    1 +
 fs/proc/array.c                              |    1 +
 fs/proc/base.c                               |    1 +
 fs/select.c                                  |    3 +-
 fs/signalfd.c                                |   17 +--
 fs/timerfd.c                                 |   11 +-
 include/linux/anon_inodes.h                  |    3 +-
 include/linux/fdtable.h                      |   99 +++++++++++++
 include/linux/file.h                         |   86 +-----------
 include/linux/init_task.h                    |    2 +-
 include/linux/poll.h                         |    2 +
 kernel/exit.c                                |    1 +
 kernel/fork.c                                |    1 +
 kernel/kmod.c                                |    1 +
 security/selinux/hooks.c                     |    1 +
 virt/kvm/kvm_main.c                          |   21 +--
 33 files changed, 273 insertions(+), 386 deletions(-)
 create mode 100644 include/linux/fdtable.h

