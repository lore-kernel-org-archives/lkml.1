Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbZADV3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbZADV3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 16:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZADV3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 16:29:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57331 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbZADV3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 16:29:08 -0500
Date: Sun, 4 Jan 2009 21:29:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] audit
Message-ID: <20090104212903.GL28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted audit fixes for -rc1 - getting audit aux records handling to saner
shape (and killing a lot of allocations, while we are at it), fixing the
breakage in audit rules ordering introduced back when we started to put
AUDIT_WATCH/AUDIT_INODE into separate hash, etc.  Please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ audit.b61

Shortlog:
Al Viro (16):
      don't reallocate buffer in every audit_sockaddr()
      sanitize audit_socketcall
      sanitize audit_ipc_obj()
      sanitize audit_ipc_set_perm()
      sanitize audit_mq_getsetattr()
      sanitize audit_mq_notify()
      sanitize AUDIT_MQ_SENDRECV
      sanitize audit_mq_open()
      sanitize audit_fd_pair()
      sanitize audit_log_capset()
      audit_update_lsm_rules() misses the audit_inode_hash[] ones
      fixing audit rule ordering mess, part 1
      audit rules ordering, part 2
      make sure that filterkey of task,always rules is reported
      clean up audit_rule_{add,del} a bit
      audit: validate comparison operations, store them in sane form

Diffstat:
 fs/pipe.c                      |    7 +-
 include/linux/audit.h          |   98 +++---
 ipc/mqueue.c                   |   97 +++---
 ipc/shm.c                      |    4 +-
 ipc/util.c                     |   18 +-
 kernel/audit.h                 |    5 +-
 kernel/audit_tree.c            |    3 +-
 kernel/auditfilter.c           |  325 +++++++++---------
 kernel/auditsc.c               |  739 ++++++++++++++++------------------------
 kernel/capability.c            |    4 +-
 net/socket.c                   |   13 +-
 security/selinux/ss/services.c |   26 +-
 security/smack/smack_lsm.c     |    6 +-
 13 files changed, 579 insertions(+), 766 deletions(-)
