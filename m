Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbZLCNcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbZLCNcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbZLCNck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:32:40 -0500
Received: from tundra.namei.org ([65.99.196.166]:44521 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbZLCNcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:32:39 -0500
Date: Fri, 4 Dec 2009 00:32:37 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [GIT] Security subsystem changes for 2.6.33
Message-ID: <alpine.LRH.2.00.0912040030400.16314@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi from FOSS.IN -- please pull.


The following changes since commit 22763c5cf3690a681551162c15d34d935308c8d7:
  Linus Torvalds (1):
        Linux 2.6.32

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 next

Alan Cox (1):
      selinux: Fix warnings

Andrew G. Morgan (1):
      Silence the existing API for capability version compatibility check.

Arjan van de Ven (1):
      capabilities: simplify bound checks for copy_from_user()

Eric Paris (5):
      SELinux: reset the security_ops before flushing the avc cache
      SELinux: add .gitignore files for dynamic classes
      security: report the module name to security_module_request
      SELinux: header generation may hit infinite loop
      SELinux: print denials for buggy kernel with unknown perms

James Morris (3):
      Merge branch 'master' into next
      security: remove root_plug
      Merge branch 'master' into next

John Johansen (1):
      Config option to set a default LSM

Kees Cook (1):
      sysctl: require CAP_SYS_RAWIO to set mmap_min_addr

Matt Domsch (1):
      tpm: autoload tpm_tis based on system PnP IDs

Mimi Zohar (2):
      LSM: imbed ima calls in the security hooks
      tpm add default function definitions

Rajiv Andrade (3):
      TPM: increase default TPM buffer
      TPM: fix pcrread
      tpm_tis: TPM_STS_DATA_EXPECT workaround

Randy Dunlap (1):
      tpm: fix header for modular build

Serge E. Hallyn (2):
      define convenient securebits masks for prctl users (v2)
      remove CONFIG_SECURITY_FILE_CAPABILITIES compile option

Stephen Hemminger (1):
      tomoyo: improve hash bucket dispersion

Stephen Smalley (4):
      selinux: dynamic class/perm discovery
      selinux: generate flask headers during kernel build
      selinux: drop remapping of netlink classes
      SELinux: fix locking issue introduced with c6d3aaa4e35c71a3

Tetsuo Handa (5):
      LSM: Add security_path_chmod() and security_path_chown().
      LSM: Add security_path_chroot().
      LSM: Pass original mount flags to security_sb_mount().
      LSM: Move security_path_chmod()/security_path_chown() to after mutex_lock().
      TOMOYO: Add recursive directory matching operator support.

 Documentation/dontdiff                           |    3 +
 Documentation/kernel-parameters.txt              |   10 -
 drivers/char/tpm/tpm.c                           |    2 +-
 drivers/char/tpm/tpm_tis.c                       |   11 +-
 fs/exec.c                                        |    4 -
 fs/file_table.c                                  |    2 -
 fs/inode.c                                       |   10 -
 fs/namespace.c                                   |   20 +-
 fs/open.c                                        |   27 +-
 include/linux/Kbuild                             |    1 +
 include/linux/capability.h                       |    2 -
 include/linux/init_task.h                        |    4 -
 include/linux/lsm_audit.h                        |   18 +-
 include/linux/securebits.h                       |   24 +-
 include/linux/security.h                         |   48 ++-
 include/linux/tpm.h                              |    9 +-
 kernel/capability.c                              |   15 +-
 kernel/kmod.c                                    |    8 +-
 mm/mmap.c                                        |    4 -
 scripts/selinux/Makefile                         |    4 +-
 scripts/selinux/genheaders/.gitignore            |    1 +
 scripts/selinux/genheaders/Makefile              |    5 +
 scripts/selinux/genheaders/genheaders.c          |  118 +++
 scripts/selinux/mdp/mdp.c                        |  151 +---
 security/Kconfig                                 |   54 +-
 security/Makefile                                |    1 -
 security/capability.c                            |   21 +-
 security/commoncap.c                             |   74 +--
 security/integrity/ima/Kconfig                   |    1 +
 security/lsm_audit.c                             |    4 +
 security/min_addr.c                              |    3 +
 security/root_plug.c                             |   90 ---
 security/security.c                              |   61 ++-
 security/selinux/.gitignore                      |    2 +
 security/selinux/Makefile                        |   10 +-
 security/selinux/avc.c                           |   78 +--
 security/selinux/hooks.c                         |   25 +-
 security/selinux/include/av_inherit.h            |   34 -
 security/selinux/include/av_perm_to_string.h     |  183 -----
 security/selinux/include/av_permissions.h        |  870 ----------------------
 security/selinux/include/avc_ss.h                |   21 +-
 security/selinux/include/class_to_string.h       |   80 --
 security/selinux/include/classmap.h              |  150 ++++
 security/selinux/include/common_perm_to_string.h |   58 --
 security/selinux/include/flask.h                 |   91 ---
 security/selinux/include/security.h              |   13 +-
 security/selinux/selinuxfs.c                     |    4 +-
 security/selinux/ss/Makefile                     |    2 +-
 security/selinux/ss/mls.c                        |    2 +-
 security/selinux/ss/policydb.c                   |   47 ++-
 security/selinux/ss/policydb.h                   |    7 +-
 security/selinux/ss/services.c                   |  562 ++++++++-------
 security/tomoyo/common.c                         |  200 +++--
 security/tomoyo/common.h                         |    4 -
 security/tomoyo/realpath.c                       |   13 +-
 55 files changed, 1083 insertions(+), 2183 deletions(-)
 create mode 100644 scripts/selinux/genheaders/.gitignore
 create mode 100644 scripts/selinux/genheaders/Makefile
 create mode 100644 scripts/selinux/genheaders/genheaders.c
 delete mode 100644 security/root_plug.c
 create mode 100644 security/selinux/.gitignore
 delete mode 100644 security/selinux/include/av_inherit.h
 delete mode 100644 security/selinux/include/av_perm_to_string.h
 delete mode 100644 security/selinux/include/av_permissions.h
 delete mode 100644 security/selinux/include/class_to_string.h
 create mode 100644 security/selinux/include/classmap.h
 delete mode 100644 security/selinux/include/common_perm_to_string.h
 delete mode 100644 security/selinux/include/flask.h


-- 
James Morris
<jmorris@namei.org>
