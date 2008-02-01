Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbYBAUrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbYBAUrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 15:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbYBAUr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 15:47:27 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49331 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbYBAUr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 15:47:26 -0500
Date: Fri, 1 Feb 2008 20:47:25 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] audit updates
Message-ID: <20080201204724.GM27894@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Misc audit updates and fixes.  Please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ audit.b46

Shortlog:

Al Viro (2):
      switch audit_get_loginuid() to task_struct *
      get rid of loginuid races

Andrew Morton (1):
      [patch 1/2] kernel/audit.c: warning fix

Eric Paris (11):
      [AUDIT] return EINTR not ERESTART*
      [AUDIT] collect uid, loginuid, and comm in OBJ_PID records
      [AUDIT] add session id to audit messages
      [AUDIT] Add End of Event record
      [AUDIT] do not panic on exclude messages in audit_log_pid_context()
      [AUDIT] include audit type in audit message when using printk
      [AUDIT] break large execve argument logging into smaller messages
      [AUDIT] make audit=0 really stop audit messages
      [AUDIT] clean up audit_receive_msg()
      [AUDIT] create context if auditing was ever enabled
      [AUDIT] ratelimit printk messages audit

Klaus Heinrich Kiwi (1):
      [AUDIT] Add uid, gid fields to ANOM_PROMISCUOUS message

Richard Knutsson (1):
      [patch 2/2] audit: complement va_copy with va_end()

Diffstat:
 Documentation/filesystems/proc.txt |    7 -
 drivers/char/tty_audit.c           |   19 +-
 fs/proc/base.c                     |    2 +-
 include/linux/audit.h              |   13 +-
 include/linux/init_task.h          |    8 +
 include/linux/sched.h              |    4 +
 kernel/audit.c                     |  434 +++++++++++++++---------------------
 kernel/auditfilter.c               |   54 +++--
 kernel/auditsc.c                   |  349 +++++++++++++++++++++--------
 kernel/sysctl.c                    |   11 -
 net/core/dev.c                     |   15 +-
 net/key/af_key.c                   |   14 +-
 net/netlink/af_netlink.c           |    2 +-
 net/xfrm/xfrm_state.c              |    2 +-
 security/selinux/selinuxfs.c       |   17 +-
 security/selinux/ss/services.c     |    5 +-
 16 files changed, 533 insertions(+), 423 deletions(-)
