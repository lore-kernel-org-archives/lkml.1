Return-Path: <linux-kernel-owner+w=401wt.eu-S934018AbYDQLH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018AbYDQLH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761319AbYDQLGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:06:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:41591 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760823AbYDQLGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:06:31 -0400
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Security testing tree patch review for 2.6.26
Date: Thu, 17 Apr 2008 11:05:57 +0000
Message-Id: <1208430369-23156-1-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please review the following security patches for 2.6.26, which have
been undergoing testing in the "next" tree and affect multiple LSMs.


The following changes since commit 4b119e21d0c66c22e8ca03df05d9de623d0eb50f:
  Linus Torvalds (1):
        Linux 2.6.25

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git for-linus

Ahmed S. Darwish (10):
      LSM: Introduce inode_getsecid and ipc_getsecid hooks
      SELinux: setup new inode/ipc getsecid hooks
      Audit: use new LSM hooks instead of SELinux exports
      Netlink: Use generic LSM hook
      SELinux: remove redundant exports
      LSM/Audit: Introduce generic Audit LSM hooks
      Audit: internally use the new LSM audit hooks
      SELinux: use new audit hooks, remove redundant exports
      Audit: Final renamings and cleanup
      Security: Introduce security= boot parameter

James Morris (2):
      Tell git about security/selinux/include/audit.h
      security: fix up documentation for security_module_enable

 Documentation/kernel-parameters.txt |    6 ++
 include/linux/audit.h               |   29 ++++++++
 include/linux/security.h            |  114 +++++++++++++++++++++++++++++-
 include/linux/selinux.h             |  134 -----------------------------------
 kernel/audit.c                      |   24 +++----
 kernel/audit.h                      |   25 -------
 kernel/auditfilter.c                |   99 ++++++++++----------------
 kernel/auditsc.c                    |   74 ++++++++++---------
 net/netlink/af_netlink.c            |    3 +-
 security/dummy.c                    |   51 +++++++++++++-
 security/security.c                 |   73 +++++++++++++++++++-
 security/selinux/exports.c          |   42 -----------
 security/selinux/hooks.c            |   34 ++++++++-
 security/selinux/include/audit.h    |   65 +++++++++++++++++
 security/selinux/ss/services.c      |   45 +++++++++---
 security/smack/smack.h              |    2 +
 security/smack/smack_lsm.c          |    7 ++-
 security/smack/smackfs.c            |   11 +++-
 18 files changed, 503 insertions(+), 335 deletions(-)
 create mode 100644 security/selinux/include/audit.h
