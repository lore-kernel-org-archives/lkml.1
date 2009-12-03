Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbZLCXgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbZLCXgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 18:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbZLCXgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 18:36:16 -0500
Received: from cobra.newdream.net ([66.33.216.30]:36075 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZLCXgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 18:36:15 -0500
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 00/24] ceph distributed file system client
Date: Thu,  3 Dec 2009 15:41:07 -0800
Message-Id: <1259883691-1042-1-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm reposting a consolidated patchset for the ceph client for one last
round of review before asking Linus to merge it.  Although most of the
changes since last time are bug fixes, protocol changes, and cleanups,
there are a few significant items:

 - generic authentication framework, with pluggable authentication
   protocols.  currently only an 'auth_none' protocol is implemented,
   which implements the interface but performs no actual authentication.
 - simpler monitor interaction
 - many other protocol changes (with an eye toward facilitating any future
   changes).

Cleanup:
 - cleaned up more inlines
 - reordered super setup/teardown
 - builds without CONFIG_DEBUGFS
 - more consistent console messages
 - improved debugfs layout

Notable bug fixes:
 - big endian fixes (tested on ppc)
 - fixed layout calcuation for unusual striping schemes
 - fix deadlock with page invalidation
 - lots and lots of small stuff

The git tree with the full history (starting with the last posted version) is
at

	git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git unstable

This has been in linux-next for a few weeks now.  

If there are no last minute issues, I plan on sending this to Linus
soon.

Thanks!
sage

---
 Documentation/filesystems/ceph.txt   |  139 ++
 Documentation/ioctl/ioctl-number.txt |    1 +
 MAINTAINERS                          |    9 +
 fs/Kconfig                           |    1 +
 fs/Makefile                          |    1 +
 fs/ceph/Kconfig                      |   26 +
 fs/ceph/Makefile                     |   37 +
 fs/ceph/README                       |   20 +
 fs/ceph/addr.c                       | 1115 +++++++++++++
 fs/ceph/auth.c                       |  225 +++
 fs/ceph/auth.h                       |   77 +
 fs/ceph/auth_none.c                  |  120 ++
 fs/ceph/auth_none.h                  |   28 +
 fs/ceph/buffer.c                     |   34 +
 fs/ceph/buffer.h                     |   55 +
 fs/ceph/caps.c                       | 2863 ++++++++++++++++++++++++++++++++
 fs/ceph/ceph_debug.h                 |   37 +
 fs/ceph/ceph_frag.c                  |   21 +
 fs/ceph/ceph_frag.h                  |  109 ++
 fs/ceph/ceph_fs.c                    |   74 +
 fs/ceph/ceph_fs.h                    |  648 ++++++++
 fs/ceph/ceph_hash.c                  |  118 ++
 fs/ceph/ceph_hash.h                  |   13 +
 fs/ceph/ceph_strings.c               |  176 ++
 fs/ceph/crush/crush.c                |  151 ++
 fs/ceph/crush/crush.h                |  180 ++
 fs/ceph/crush/hash.c                 |  149 ++
 fs/ceph/crush/hash.h                 |   17 +
 fs/ceph/crush/mapper.c               |  596 +++++++
 fs/ceph/crush/mapper.h               |   20 +
 fs/ceph/debugfs.c                    |  450 +++++
 fs/ceph/decode.h                     |  159 ++
 fs/ceph/dir.c                        | 1222 ++++++++++++++
 fs/ceph/export.c                     |  223 +++
 fs/ceph/file.c                       |  904 +++++++++++
 fs/ceph/inode.c                      | 1624 +++++++++++++++++++
 fs/ceph/ioctl.c                      |  160 ++
 fs/ceph/ioctl.h                      |   40 +
 fs/ceph/mds_client.c                 | 2976 ++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.h                 |  327 ++++
 fs/ceph/mdsmap.c                     |  170 ++
 fs/ceph/mdsmap.h                     |   54 +
 fs/ceph/messenger.c                  | 2103 ++++++++++++++++++++++++
 fs/ceph/messenger.h                  |  253 +++
 fs/ceph/mon_client.c                 |  751 +++++++++
 fs/ceph/mon_client.h                 |  115 ++
 fs/ceph/msgpool.c                    |  181 ++
 fs/ceph/msgpool.h                    |   27 +
 fs/ceph/msgr.h                       |  167 ++
 fs/ceph/osd_client.c                 | 1364 ++++++++++++++++
 fs/ceph/osd_client.h                 |  150 ++
 fs/ceph/osdmap.c                     |  916 +++++++++++
 fs/ceph/osdmap.h                     |  124 ++
 fs/ceph/rados.h                      |  370 +++++
 fs/ceph/snap.c                       |  887 ++++++++++
 fs/ceph/super.c                      |  984 +++++++++++
 fs/ceph/super.h                      |  895 ++++++++++
 fs/ceph/types.h                      |   29 +
 fs/ceph/xattr.c                      |  842 ++++++++++
 59 files changed, 25527 insertions(+), 0 deletions(-)
