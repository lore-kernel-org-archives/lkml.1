Return-Path: <linux-kernel-owner+w=401wt.eu-S1760535AbZFJXtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535AbZFJXtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 19:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZFJXtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 19:49:47 -0400
Received: from tundra.namei.org ([65.99.196.166]:45983 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbZFJXtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 19:49:46 -0400
Date: Thu, 11 Jun 2009 09:49:48 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Subject: What's in the security-testing tree for 2.6.31
Message-ID: <alpine.LRH.2.00.0906110945450.29166@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's what's queued in the 'next' branch for 2.6.31.

(Note that Linus has asked people to test 2.6.30 for a week before opening 
the merge window).

Eric Paris (12):
      SELinux: drop secondary_ops->sysctl
      IMA: use current_cred() instead of current->cred
      IMA: Handle dentry_open failures
      IMA: open all files O_LARGEFILE
      securityfs: securityfs_remove should handle IS_ERR pointers
      TPM: get_event_name stack corruption
      IMA: remove read permissions on the ima policy file
      IMA: do not measure everything opened by root by default
      SELinux: move SELINUX_MAGIC into magic.h
      IMA: Minimal IMA policy and boot param for TCB IMA policy
      IMA: Add __init notation to ima functions
      SELinux: define audit permissions for audit tree netlink messages

Tetsuo Handa (9):
      tomoyo: remove "undelete domain" command.
      rootplug: Remove redundant initialization.
      smack: Remove redundant initialization.
      TOMOYO: Remove unused mutex.
      TOMOYO: Remove redundant markers.
      TOMOYO: Simplify policy reader.
      TOMOYO: Remove unused parameter.
      TOMOYO: Remove unused field.
      TOMOYO: Add description of lists and structures.

Mimi Zohar (7):
      integrity: lsm audit rule matching fix
      integrity: use audit_log_string
      integrity: remove __setup auditing msgs
      integrity: path_check update
      integrity: move ima_counts_get
      integrity: nfsd imbalance bug fix
      integrity: ima audit dentry_open failure

David Howells (3):
      SELinux: Don't flush inherited SIGKILL during execve()
      CRED: Rename cred_exec_mutex to reflect that it's a guard against ptrace
      CRED: Guard the setprocattr security hook against ptrace

Etienne Basset (2):
      smack: implement logging V3
      smack: implement logging V3

Oleg Nesterov (2):
      selinux: selinux_bprm_committed_creds() should wake up ->real_parent, not ->parent.
      do_wait: do take security_task_wait() into account

Serge E. Hallyn (2):
      don't raise all privs on setuid-root file with fE set (v2)
      tomoyo: avoid get+put of task_struct

Christoph Lameter (1):
      security: use mmap_min_addr indepedently of security models

KaiGai Kohei (1):
      Permissive domain in userspace object manager

Kees Cook (1):
      modules: sysctl to block module loading

Paul Mundt (1):
      nommu: Provide mmap_min_addr definition.

Roel Kluin (1):
      smack: do not beyond ARRAY_SIZE of data

Stephen Rothwell (1):
      modules: Fix up build when CONFIG_MODULE_UNLOAD=n.

Stephen Smalley (1):
      selinux: remove obsolete read buffer limit from sel_read_bool

 Documentation/Smack.txt             |   20 +
 Documentation/kernel-parameters.txt |    6 
 Documentation/sysctl/kernel.txt     |   11 
 drivers/char/tpm/tpm_bios.c         |    3 
 fs/compat.c                         |    6 
 fs/exec.c                           |   15 -
 fs/hugetlbfs/inode.c                |    2 
 fs/namei.c                          |    6 
 fs/nfsd/vfs.c                       |   14 +
 fs/proc/base.c                      |    6 
 include/linux/ima.h                 |   11 
 include/linux/init_task.h           |    4 
 include/linux/lsm_audit.h           |  111 +++++++++
 include/linux/magic.h               |    1 
 include/linux/mm.h                  |    2 
 include/linux/sched.h               |    5 
 include/linux/security.h            |    2 
 ipc/shm.c                           |    5 
 kernel/cred.c                       |    4 
 kernel/exit.c                       |    1 
 kernel/module.c                     |   13 -
 kernel/ptrace.c                     |    9 
 kernel/signal.c                     |   11 
 kernel/sysctl.c                     |   14 +
 mm/Kconfig                          |   19 +
 mm/mmap.c                           |    3 
 mm/nommu.c                          |    3 
 mm/shmem.c                          |    4 
 security/Kconfig                    |   22 -
 security/Makefile                   |    3 
 security/commoncap.c                |   32 ++
 security/inode.c                    |    2 
 security/integrity/ima/ima_audit.c  |   32 --
 security/integrity/ima/ima_crypto.c |    4 
 security/integrity/ima/ima_fs.c     |    8 
 security/integrity/ima/ima_iint.c   |    2 
 security/integrity/ima/ima_init.c   |    4 
 security/integrity/ima/ima_main.c   |   92 ++++----
 security/integrity/ima/ima_policy.c |   50 +++-
 security/lsm_audit.c                |  386 ++++++++++++++++++++++++++++++++++
 security/root_plug.c                |   12 -
 security/security.c                 |    3 
 security/selinux/avc.c              |    2 
 security/selinux/hooks.c            |   24 --
 security/selinux/include/security.h |    7 
 security/selinux/nlmsgtab.c         |    2 
 security/selinux/selinuxfs.c        |    8 
 security/selinux/ss/services.c      |   30 --
 security/smack/smack.h              |  108 +++++++++
 security/smack/smack_access.c       |  143 +++++++++++-
 security/smack/smack_lsm.c          |  405 ++++++++++++++++++++++++++----------
 security/smack/smackfs.c            |   68 +++++-
 security/tomoyo/common.c            |  126 +++++++----
 security/tomoyo/common.h            |  142 ++++++++++--
 security/tomoyo/domain.c            |  330 ++++++++++++++++++-----------
 security/tomoyo/file.c              |  156 +++++++++++--
 security/tomoyo/realpath.c          |   23 +-
 security/tomoyo/tomoyo.c            |    4 
 security/tomoyo/tomoyo.h            |   13 -
 59 files changed, 1965 insertions(+), 589 deletions(-)

