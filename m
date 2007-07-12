Return-Path: <linux-kernel-owner+w=401wt.eu-S1765577AbXGLDUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765577AbXGLDUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 23:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbXGLDUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 23:20:04 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:59579 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363AbXGLDUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 23:20:03 -0400
Date: Wed, 11 Jul 2007 23:20:00 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: [GIT] SELinux changes for 2.6.23 (updated)
Message-ID: <Line.LNX.4.64.0707112315480.30564@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated set of 2.6.23 SELinux changes, rebased & tested against 
current git.  The vmsplice patch has been dropped from this and will be 
resubmitted via Jens.  Also added an ack from Chris Wright for the mmap 
null dereference hooks (which I'd forgotten to add to my tree some time 
ago).

Please pull.


The following changes since commit 4eb6bf6bfb580afaf1e1a1d30cba17a078530cf4:
  Alan Cox (1):
        lots-of-architectures: enable arbitary speed tty support

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

Paul Moore (1):
      SELinux: use SECINITSID_NETMSG instead of SECINITSID_UNLABELED for NetLabel

Stephen Smalley (1):
      SELinux: allow preemption between transition permission checks

Tobias Oed (1):
      SELinux: Use %lu for inode->i_no when printing avc

 Documentation/sysctl/vm.txt                  |   15 ++
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
 20 files changed, 504 insertions(+), 86 deletions(-)
