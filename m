Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbXDZGC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbXDZGC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbXDZGC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:02:27 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:50374 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbXDZGC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:02:26 -0400
Date: Thu, 26 Apr 2007 02:02:23 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 0/12] SELinux patches for 2.6.22
Message-ID: <Line.LNX.4.64.0704260200450.30059@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit de46c33745f5e2ad594c72f2cf5f490861b16ce1:
  Linus Torvalds (1):
        Linux 2.6.21

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-linus

James Carter (4):
      selinux: export initial SID contexts via selinuxfs
      selinux: explicitly number all selinuxfs inodes
      selinux: remove unused enumeration constant from selinuxfs
      selinux: change numbering of boolean directory inodes in selinuxfs

Paul Moore (5):
      NetLabel: cleanup and document CIPSO constants
      NetLabel: convert a BUG_ON in the CIPSO code to a runtime check
      SELinux: extract the NetLabel SELinux support from the security server
      SELinux: rename selinux_netlabel.h to netlabel.h
      SELinux: move security_skb_extlbl_sid() out of the security server

Stephen Smalley (3):
      MAINTAINERS: update selinux entry
      selinux: remove userland security class and permission definitions
      selinux: preserve boolean values across policy reloads

 MAINTAINERS                                        |    4 +-
 net/ipv4/cipso_ipv4.c                              |   41 ++-
 net/netlabel/netlabel_kapi.c                       |    3 -
 security/selinux/Makefile                          |    2 +
 security/selinux/avc.c                             |    2 +
 security/selinux/hooks.c                           |   38 ++-
 security/selinux/include/av_perm_to_string.h       |  102 ----
 security/selinux/include/av_permissions.h          |  179 -------
 security/selinux/include/class_to_string.h         |   34 +-
 security/selinux/include/flask.h                   |   16 -
 .../include/{selinux_netlabel.h => netlabel.h}     |   71 ++--
 security/selinux/include/security.h                |   29 +-
 security/selinux/netlabel.c                        |  363 ++++++++++++++
 security/selinux/selinuxfs.c                       |   85 +++-
 security/selinux/ss/services.c                     |  499 +++++---------------
 15 files changed, 695 insertions(+), 773 deletions(-)
 rename security/selinux/include/{selinux_netlabel.h => netlabel.h} (94%)
 create mode 100644 security/selinux/netlabel.c



-- 
James Morris
<jmorris@namei.org>
