Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755986AbYLQFLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbYLQFLT (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbYLQFLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:11:04 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37006 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYLQFLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:11:02 -0500
To: linux-audit@redhat.com
Subject: [PATCHSET] audit patches for .29-rc1
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LCogW-000088-SO@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 17 Dec 2008 05:11:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch series is intended for the next merge cycle; review
and testing would be welcome.  It seems to survive light beating here...

It can also be found in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ audit.b60

Have fun.

Shortlog:

Al Viro (15):
      don't reallocate buffer in every audit_sockaddr()
      sanitize audit_socketcall
      sanitize audit_ipc_obj()
      sanitize audit_ipc_set_perm()
      sanitize audit_mq_getsetattr()
      sanitize audit_mq_notify()
      sanitize AUDIT_MQ_SENDRECV
      sanitize audit_mq_open()
      sanitize audit_fd_pair()
      audit_update_lsm_rules() misses the audit_inode_hash[] ones
      fixing audit rule ordering mess, part 1
      audit rules ordering, part 2
      make sure that filterkey of task,always rules is reported
      clean up audit_rule_{add,del} a bit
      audit: validate comparison operations, store them in sane form

Diffstat:
 fs/pipe.c                      |    7 +-
 include/linux/audit.h          |   89 +++---
 ipc/mqueue.c                   |   97 +++---
 ipc/shm.c                      |    4 +-
 ipc/util.c                     |   19 +-
 kernel/audit.h                 |    5 +-
 kernel/audit_tree.c            |    3 +-
 kernel/auditfilter.c           |  325 ++++++++++----------
 kernel/auditsc.c               |  691 ++++++++++++++++------------------------
 net/socket.c                   |   13 +-
 security/selinux/ss/services.c |   26 +-
 security/smack/smack_lsm.c     |    6 +-
 12 files changed, 557 insertions(+), 728 deletions(-)


