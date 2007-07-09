Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbXGICzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbXGICzN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 22:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbXGICzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 22:55:01 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:47283 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757059AbXGICzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 22:55:00 -0400
Date: Sun, 8 Jul 2007 22:54:56 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/11] SELinux patches for 2.6.23
Message-ID: <Line.LNX.4.64.0707082253040.12256@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7dcca30a32aadb0520417521b0c44f42d09fe05c:
  Linus Torvalds (1):
        Linux 2.6.22

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-linus

Adrian Bunk (1):
      security: unexport mmap_min_addr

Christopher J. PeBenito (4):
      selinux: add support for querying object classes and permissions from the running policy
      selinux: rename sel_remove_bools() for more general usage.
      selinux: change sel_make_dir() to specify inode counter.
      selinux: add selinuxfs structure for object class discovery

Eric Paris (2):
      selinux: introduce schedule points in policydb_destroy()
      security: Protection for exploiting null dereference using mmap

James Morris (1):
      security: revalidate rw permissions for sys_splice and sys_vmsplice

Paul Moore (1):
      SELinux: use SECINITSID_NETMSG instead of SECINITSID_UNLABELED for NetLabel

Stephen Smalley (1):
      SELinux: allow preemption between transition permission checks

Tobias Oed (1):
      SELinux: Use %lu for inode->i_no when printing avc

 Documentation/sysctl/vm.txt                  |   15 ++
 fs/splice.c                                  |   14 ++
 include/linux/security.h                     |   17 ++-
 kernel/sysctl.c                              |   10 +
 mm/mmap.c                                    |    4 +-
 mm/mremap.c                                  |   13 +-
 mm/nommu.c                                   |    2 +-
 security/dummy.c                             |    6 +-
 security/security.c                          |    1 +
 security/selinux/avc.c                       |   12 +-
 security/selinux/hooks.c                     |   42 +++--
 security/selinux/include/av_perm_to_string.h |    1 +
 security/selinux/include/av_permissions.h    |    1 +
 security/selinux/include/avc.h               |    6 +-
 security/selinux/include/class_to_string.h   |    1 +
 security/selinux/include/flask.h             |    1 +
 security/selinux/include/security.h          |    4 +
 security/selinux/netlabel.c                  |   34 ++--
 security/selinux/selinuxfs.c                 |  269 +++++++++++++++++++++++++-
 security/selinux/ss/policydb.c               |    7 +
 security/selinux/ss/services.c               |  144 ++++++++++++--
 21 files changed, 518 insertions(+), 86 deletions(-)



-- 
James Morris
<jmorris@namei.org>
