Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab0CCAxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:53:38 -0500
Received: from cobra.newdream.net ([66.33.216.30]:54177 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab0CCAqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:46:45 -0500
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 00/26] ceph distributed file system client
Date: Tue,  2 Mar 2010 16:46:31 -0800
Message-Id: <1267577217-31923-1-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is the latest patchset for the Ceph distributed file system client.  
I've broken it down into individual files for ease of review.  
Alternatively, the ceph-client.git tree includes a full history (from 
mid-October).  A shortlog for changes since the last time I sent this 
out (during the 2.6.33 merge window) at the end of this email.

We've been hammering on this steadily for the past few weeks and are 
pretty happy with the stability at this point.  We would definitely 
benefit from the broader testing that would come from inclusion in 
2.6.34.  If there are no major complaints, I will send this to Linus 
again shortly.

Questions, comments, review, etc. are all welcome.  :)

Thanks-
sage

Git tree:
	git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

Server-side git:
	git://ceph.newdream.net/ceph.git


---
 Documentation/filesystems/ceph.txt   |  139 ++
 Documentation/ioctl/ioctl-number.txt |    1 +
 MAINTAINERS                          |    9 +
 fs/Kconfig                           |    1 +
 fs/Makefile                          |    1 +
 fs/ceph/Kconfig                      |   27 +
 fs/ceph/Makefile                     |   39 +
 fs/ceph/README                       |   20 +
 fs/ceph/addr.c                       | 1188 +++++++++++++
 fs/ceph/armor.c                      |   99 ++
 fs/ceph/auth.c                       |  257 +++
 fs/ceph/auth.h                       |   84 +
 fs/ceph/auth_none.c                  |  121 ++
 fs/ceph/auth_none.h                  |   28 +
 fs/ceph/auth_x.c                     |  656 ++++++++
 fs/ceph/auth_x.h                     |   49 +
 fs/ceph/auth_x_protocol.h            |   90 +
 fs/ceph/buffer.c                     |   78 +
 fs/ceph/buffer.h                     |   39 +
 fs/ceph/caps.c                       | 2925 ++++++++++++++++++++++++++++++++
 fs/ceph/ceph_debug.h                 |   37 +
 fs/ceph/ceph_frag.c                  |   21 +
 fs/ceph/ceph_frag.h                  |  109 ++
 fs/ceph/ceph_fs.c                    |   74 +
 fs/ceph/ceph_fs.h                    |  651 ++++++++
 fs/ceph/ceph_hash.c                  |  118 ++
 fs/ceph/ceph_hash.h                  |   13 +
 fs/ceph/ceph_strings.c               |  176 ++
 fs/ceph/crush/crush.c                |  151 ++
 fs/ceph/crush/crush.h                |  180 ++
 fs/ceph/crush/hash.c                 |  149 ++
 fs/ceph/crush/hash.h                 |   17 +
 fs/ceph/crush/mapper.c               |  596 +++++++
 fs/ceph/crush/mapper.h               |   20 +
 fs/ceph/crypto.c                     |  408 +++++
 fs/ceph/crypto.h                     |   48 +
 fs/ceph/debugfs.c                    |  483 ++++++
 fs/ceph/decode.h                     |  194 +++
 fs/ceph/dir.c                        | 1220 ++++++++++++++
 fs/ceph/export.c                     |  223 +++
 fs/ceph/file.c                       |  937 +++++++++++
 fs/ceph/inode.c                      | 1750 ++++++++++++++++++++
 fs/ceph/ioctl.c                      |  160 ++
 fs/ceph/ioctl.h                      |   40 +
 fs/ceph/mds_client.c                 | 3021 ++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.h                 |  335 ++++
 fs/ceph/mdsmap.c                     |  174 ++
 fs/ceph/mdsmap.h                     |   54 +
 fs/ceph/messenger.c                  | 2240 +++++++++++++++++++++++++
 fs/ceph/messenger.h                  |  254 +++
 fs/ceph/mon_client.c                 |  834 ++++++++++
 fs/ceph/mon_client.h                 |  119 ++
 fs/ceph/msgpool.c                    |  186 +++
 fs/ceph/msgpool.h                    |   27 +
 fs/ceph/msgr.h                       |  158 ++
 fs/ceph/osd_client.c                 | 1537 +++++++++++++++++
 fs/ceph/osd_client.h                 |  166 ++
 fs/ceph/osdmap.c                     | 1019 ++++++++++++
 fs/ceph/osdmap.h                     |  125 ++
 fs/ceph/pagelist.c                   |   54 +
 fs/ceph/pagelist.h                   |   54 +
 fs/ceph/rados.h                      |  374 +++++
 fs/ceph/snap.c                       |  904 ++++++++++
 fs/ceph/super.c                      | 1030 ++++++++++++
 fs/ceph/super.h                      |  900 ++++++++++
 fs/ceph/types.h                      |   29 +
 fs/ceph/xattr.c                      |  844 ++++++++++
 67 files changed, 28064 insertions(+), 0 deletions(-)


Below is a shortlog of changes since v0.18, the last patchset sent out 
to LKML/fsdevel for review.  The main items are support for client and 
server authentication (auth_x), some support for easing future protocol 
changes, and a variety of bug fixes.  The full history is available at

	http://ceph.newdream.net/git/?p=ceph-client.git;a=shortlog;h=unstable

 fs/ceph/Kconfig           |    1 +
 fs/ceph/Makefile          |    4 +-
 fs/ceph/addr.c            |  153 ++++++++---
 fs/ceph/armor.c           |   99 +++++++
 fs/ceph/auth.c            |   70 ++++--
 fs/ceph/auth.h            |    7 +
 fs/ceph/auth_none.c       |    1 +
 fs/ceph/auth_x.c          |  656 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/auth_x.h          |   49 ++++
 fs/ceph/auth_x_protocol.h |   90 ++++++
 fs/ceph/buffer.c          |   54 ++++-
 fs/ceph/buffer.h          |   30 +--
 fs/ceph/caps.c            |  310 +++++++++++++---------
 fs/ceph/ceph_fs.h         |   23 +-
 fs/ceph/crypto.c          |  408 ++++++++++++++++++++++++++++
 fs/ceph/crypto.h          |   48 ++++
 fs/ceph/debugfs.c         |   93 +++++--
 fs/ceph/decode.h          |   35 +++
 fs/ceph/dir.c             |   14 +-
 fs/ceph/file.c            |   95 +++++---
 fs/ceph/inode.c           |  188 +++++++++++---
 fs/ceph/mds_client.c      |  607 ++++++++++++++++++++++-------------------
 fs/ceph/mds_client.h      |   20 +-
 fs/ceph/mdsmap.c          |    4 +
 fs/ceph/messenger.c       |  507 ++++++++++++++++++++++-------------
 fs/ceph/messenger.h       |   37 ++--
 fs/ceph/mon_client.c      |  173 +++++++++---
 fs/ceph/mon_client.h      |    8 +-
 fs/ceph/msgpool.c         |    9 +-
 fs/ceph/msgr.h            |   23 +--
 fs/ceph/osd_client.c      |  525 ++++++++++++++++++++++++------------
 fs/ceph/osd_client.h      |   30 ++-
 fs/ceph/osdmap.c          |  223 +++++++++++----
 fs/ceph/osdmap.h          |    7 +-
 fs/ceph/pagelist.c        |   54 ++++
 fs/ceph/pagelist.h        |   54 ++++
 fs/ceph/rados.h           |   16 +-
 fs/ceph/snap.c            |   69 +++--
 fs/ceph/super.c           |   76 +++++-
 fs/ceph/super.h           |   47 ++--
 fs/ceph/xattr.c           |    8 +-
 41 files changed, 3731 insertions(+), 1194 deletions(-)

Alexander Beregalov (1):
      ceph: move dereference after NULL test

Julia Lawall (1):
      ceph: remove duplicate variable initialization

Sage Weil (80):
      ceph: use kref for ceph_buffer
      ceph: simplify ceph_buffer interface
      ceph: use kref for struct ceph_mds_request
      ceph: use kref for ceph_osd_request
      ceph: use kref for ceph_msg
      ceph: do not feed bad device ids to crush
      ceph: fix leak of monc mutex
      ceph: carry explicit msg reference for currently sending message
      ceph: plug msg leak in con_fault
      ceph: detect lossy state of connection
      ceph: don't save sent messages on lossy connections
      ceph: hex dump corrupt server data to KERN_DEBUG
      ceph: plug leak of incoming message during connection fault/close
      ceph: make mds ops interruptible
      ceph: include link to bdi in debugfs
      ceph: ensure rename target dentry fails revalidation
      ceph: do not drop lease during revalidate
      ceph: fix error paths for corrupt osdmap messages
      ceph: fix incremental osdmap pg_temp decoding bug
      ceph: do not touch_caps while iterating over caps list
      ceph: only unregister registered bdi
      ceph: unregister canceled/timed out osd requests
      ceph: use connection mutex to protect read and write stages
      ceph: control access to page vector for incoming data
      ceph: more informative msgpool errors
      ceph: include transaction id in ceph_msg_header (protocol change)
      ceph: add feature bits to connection handshake (protocol change)
      ceph: support ceph_pagelist for message payload
      ceph: use ceph_pagelist for mds reconnect message; change encoding (protocol change)
      ceph: remove unused erank field
      ceph: display pgid in debugfs osd request dump
      ceph: mark MDS CREATE as a write op
      ceph: properly handle aborted mds requests
      ceph: precede encoded ceph_pg_pool struct with version
      ceph: include type in ceph_entity_addr, filepath
      ceph: release all pages after successful osd write response
      ceph: buffer decoding helpers
      ceph: aes crypto and base64 encode/decode helpers
      ceph: allow renewal of auth credentials
      ceph: add struct version to auth encoding
      ceph: add support for auth_x authentication protocol
      ceph: add uid field to ceph_pg_pool
      ceph: cap revocation fixes
      ceph: do not retain caps that are being revoked
      ceph: fix sync read eof check deadlock
      ceph: cleanup async writeback, truncation, invalidate helpers
      ceph: invalidate pages even if truncate is pending
      ceph: remove bogus invalidate_mapping_pages
      ceph: fix msgr to keep sent messages until acked
      ceph: reset osd connections after fault
      ceph: allow connection to be reopened by fault callback
      ceph: cancel delayed work when closing connection
      ceph: use rbtree for mds requests
      ceph: use rbtree for snap_realms
      ceph: use rbtree for mon statfs requests
      ceph: fix authentication races, auth_none oops
      ceph: clean up readdir caps reservation
      ceph: fix iterate_caps removal race
      ceph: fix memory leak when destroying osdmap with pg_temp mappings
      ceph: use rbtree for pg pools; decode new osdmap format
      ceph: v0.19 release
      ceph: fix typo in ceph_queue_writeback debug output
      ceph: fix check for invalidate_mapping_pages success
      ceph: fix up unexpected message handling
      ceph: fix comments, locking in destroy_inode
      ceph: drop messages on unregistered mds sessions; cleanup
      ceph: fix client_request_forward decoding
      ceph: invalidate_authorizer without con->mutex held
      ceph: fix connection fault STANDBY check
      ceph: remove fragile __map_osds optimization
      ceph: remove bogus mds forward warning
      ceph: reset bits on connection close
      ceph: use single osd op reply msg
      ceph: fix snaptrace decoding on cap migration between mds
      ceph: reset front len on return to msgpool; BUG on mismatched front iov
      ceph: set osd request message front length correctly
      ceph: return EBADF if waiting for caps on closed file
      ceph: fix osdmap decoding when pools include (removed) snaps
      ceph: include migrating caps in issued set
      ceph: fix flush_dirty_caps race with caps migration

Yehuda Sadeh (23):
      ceph: fix msgpool reservation leak
      ceph: remove unaccessible code
      ceph: writepage grabs and releases inode
      ceph: writeback congestion control
      ceph: fix copy_user_to_page_vector()
      ceph: change dentry offset and position after splice_dentry
      ceph: allocate middle of message before stating to read
      ceph: refactor messages data section allocation
      ceph: alloc message data pages and check if tid exists
      ceph: keep reserved replies on the request structure
      ceph: remove unreachable code
      ceph: always send truncation info with read and write osd ops
      ceph: remove unused variable
      ceph: put unused osd connections on lru
      ceph: fix short synchronous reads
      ceph: refactor ceph_write_begin, fix ceph_page_mkwrite
      ceph: fix truncation when not holding caps
      ceph: sync read/write considers page cache
      ceph: remove page upon writeback completion if lost cache cap
      ceph: don't truncate dirty pages in invalidate work thread
      ceph: cleanup redundant code in handle_cap_grant
      ceph: don't clobber write return value when using O_SYNC
      ceph: reset osd after relevant messages timed out

