Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbZAFXjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbZAFXjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZAFXje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:39:34 -0500
Received: from tundra.namei.org ([65.99.196.166]:1523 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbZAFXjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:39:33 -0500
Date: Wed, 7 Jan 2009 10:39:23 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [GIT] More security updates for 2.6.29
Message-ID: <alpine.LRH.1.10.0901071034200.30422@tundra.namei.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the following updates for the security subsystem.  Noteworthy 
is the fix for a regression introducted by the creds API (found by hch), 
and updates from Paul Moore's labeled networking tree.

The following changes since commit 238c6d54830c624f34ac9cf123ac04aebfca5013:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../agk/linux-2.6-dm

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Casey Schaufler (1):
      smack: Add support for unlabeled network hosts and networks

David Howells (2):
      CRED: Fix regression in cap_capable() as shown up by sys_faccessat() [ver #2]
      CRED: Fix regression in cap_capable() as shown up by sys_faccessat() [ver #3]

Eric Paris (1):
      SELinux: shrink sizeof av_inhert selinux_class_perm and context

James Morris (4):
      keys: fix sparse warning by adding __user annotation to cast
      Merge branch 'master' of git://git.infradead.org/users/pcmoore/lblnet-2.6_next into next
      Revert "CRED: Fix regression in cap_capable() as shown up by sys_faccessat() [ver #2]"
      Merge branch 'next' into for-linus

Paul Moore (2):
      netlabel: Update kernel configuration API
      selinux: Deprecate and schedule the removal of the the compat_net functionality

 Documentation/feature-removal-schedule.txt |   12 +
 include/linux/capability.h                 |   17 ++-
 include/linux/security.h                   |   41 +++-
 include/net/cipso_ipv4.h                   |    6 +-
 include/net/netlabel.h                     |   86 ++++++-
 kernel/capability.c                        |    2 +-
 net/ipv4/cipso_ipv4.c                      |   88 +++++--
 net/netlabel/netlabel_cipso_v4.c           |   61 ++----
 net/netlabel/netlabel_domainhash.c         |   67 +++++
 net/netlabel/netlabel_domainhash.h         |    4 +
 net/netlabel/netlabel_kapi.c               |  347 +++++++++++++++++++++-----
 net/netlabel/netlabel_unlabeled.c          |   26 +-
 net/netlabel/netlabel_unlabeled.h          |   15 ++
 security/commoncap.c                       |   29 +--
 security/keys/keyctl.c                     |    2 +-
 security/security.c                        |   26 ++-
 security/selinux/Kconfig                   |   27 --
 security/selinux/avc.c                     |   16 +-
 security/selinux/hooks.c                   |   22 +-
 security/selinux/include/avc_ss.h          |    4 +-
 security/selinux/selinuxfs.c               |   16 +-
 security/selinux/ss/context.h              |    2 +-
 security/smack/smack.h                     |   31 +++-
 security/smack/smack_access.c              |   28 ++-
 security/smack/smack_lsm.c                 |  310 +++++++++++++++++++----
 security/smack/smackfs.c                   |  369 ++++++++++++++++++----------
 26 files changed, 1230 insertions(+), 424 deletions(-)
