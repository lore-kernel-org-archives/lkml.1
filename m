Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab0CEXcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 18:32:12 -0500
Received: from cobra.newdream.net ([66.33.216.30]:34960 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab0CEXcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 18:32:09 -0500
Date: Fri, 5 Mar 2010 15:32:33 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] Ceph distributed file system client for 2.6.34-rc1
Message-ID: <Pine.LNX.4.64.1003051434240.10078@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling the Ceph distributed file system client from

 git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

which includes a patch with the recent write_inode API change, but does 
not merge Al's write_inode branch, as that currently conflicts with your 
tree in a few places.  (OTOH, my branch has a trivial conflict in 
Documentation/ioctl/ioctl-numbers.txt.)

Red Hat has bugs open asking for Ceph, and has included the userspace in 
F13, but they are antsy about pulling in the kernel client before it goes 
upstream.  Another half dozen people have piped up on LKML or the ceph 
list asking to see it pushed upstream.

A larger number of people are evaluating and testing the system.  A few 
sites have reasonably sized clusters set up (>16 nodes), the rest have 
tried the system on a small number of nodes.  At this point you still 
won't find a particularly large user base, or as much demand as say btrfs 
simply because Ceph is useful for a much smaller audience--those with lots 
of storage boxes they'd like to aggregate into a single file system--and 
because those people tend to be pretty careful with their data.

Although stability has improved greatly is the last few months, Ceph is 
still relatively new and experimental for a something as conservative as 
storage, and only time and testing will change that.  Getting the code 
upstream sooner rather than later will accelerate that process by reducing 
barriers to testing, expanding the pool of systems with a usable client, 
and making it easier for distros to include it.

Thanks-
sage


Alexander Beregalov (1):
      ceph: move dereference after NULL test

Julia Lawall (3):
      fs/ceph: introduce missing kfree
      fs/ceph: Move a dereference below a NULL test
      ceph: remove duplicate variable initialization

Noah Watkins (3):
      ceph: replace list_entry with container_of
      ceph: remove redundant use of le32_to_cpu
      ceph: fix intra strip unit length calculation

Sage Weil (173):
      ceph: documentation
      ceph: on-wire types
      ceph: client types
      ceph: ref counted buffer
      ceph: super.c
      ceph: inode operations
      ceph: directory operations
      ceph: file operations
      ceph: address space operations
      ceph: MDS client
      ceph: OSD client
      ceph: CRUSH mapping algorithm
      ceph: monitor client
      ceph: capability management
      ceph: snapshot management
      ceph: messenger library
      ceph: message pools
      ceph: nfs re-export support
      ceph: ioctls
      ceph: debugfs
      ceph: Kconfig, Makefile
      ceph: document shared files in README
      ceph: show meaningful version on module load
      ceph: include preferred_osd in file layout virtual xattr
      ceph: gracefully avoid empty crush buckets
      ceph: fix mdsmap decoding when multiple mds's are present
      ceph: renew mon subscription before it expires
      ceph: fix osd request submission race
      ceph: revoke osd request message on request completion
      ceph: fail gracefully on corrupt osdmap (bad pg_temp mapping)
      ceph: reset osd session on fault, not peer_reset
      ceph: cancel osd requests before resending them
      ceph: update to mon client protocol v15
      ceph: add file layout validation
      ceph: ignore trailing data in monamp
      ceph: remove unused CEPH_MSG_{OSD,MDS}_GETMAP
      ceph: add version field to message header
      ceph: convert encode/decode macros to inlines
      ceph: initialize sb->s_bdi, bdi_unregister after kill_anon_super
      ceph: move generic flushing code into helper
      ceph: flush dirty caps via the cap_dirty list
      ceph: correct subscribe_ack msgpool payload size
      ceph: warn on allocation from msgpool with larger front_len
      ceph: move dirty caps code around
      ceph: enable readahead
      ceph: include preferred osd in placement seed
      ceph: v0.17 of client
      ceph: move directory size logic to ceph_getattr
      ceph: remove small mon addr limit; use CEPH_MAX_MON where appropriate
      ceph: reduce parse_mount_args stack usage
      ceph: silence uninitialized variable warning
      ceph: fix, clean up string mount arg parsing
      ceph: allocate and parse mount args before client instance
      ceph: correct comment to match striping calculation
      ceph: fix object striping calculation for non-default striping schemes
      ceph: fix uninitialized err variable
      crush: always return a value from crush_bucket_choose
      ceph: init/destroy bdi in client create/destroy helpers
      ceph: use fixed endian encoding for ceph_entity_addr
      ceph: fix endian conversions for ceph_pg
      ceph: fix sparse endian warning
      ceph: convert port endianness
      ceph: clean up 'osd%d down' console msg
      ceph: make CRUSH hash functions non-inline
      ceph: use strong hash function for mapping objects to pgs
      ceph: make object hash a pg_pool property
      ceph: make CRUSH hash function a bucket property
      ceph: do not confuse stale and dead (unreconnected) caps
      ceph: separate banner and connect during handshake into distinct stages
      ceph: remove recon_gen logic
      ceph: exclude snapdir from readdir results
      ceph: initialize i_size/i_rbytes on snapdir
      ceph: pr_info when mds reconnect completes
      ceph: build cleanly without CONFIG_DEBUG_FS
      ceph: fix page invalidation deadlock
      ceph: remove bad calls to ceph_con_shutdown
      ceph: remove unnecessary ceph_con_shutdown
      ceph: handle errors during osd client init
      ceph: negotiate authentication protocol; implement AUTH_NONE protocol
      ceph: move mempool creation to ceph_create_client
      ceph: small cleanup in hash function
      ceph: fix debugfs entry, simplify fsid checks
      ceph: decode updated mdsmap format
      ceph: reset requested max_size after mds reconnect
      ceph: reset msgr backoff during open, not after successful handshake
      ceph: remove dead code
      ceph: remove useless IS_ERR checks
      ceph: plug leak of request_mutex
      ceph: whitespace cleanup
      ceph: hide /.ceph from readdir results
      ceph: allow preferred osd to be get/set via layout ioctl
      ceph: update MAINTAINERS entry with correct git URL
      ceph: mark v0.18 release
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

Yehuda Sadeh (24):
      ceph: mount fails immediately on error
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
 fs/ceph/ceph_fs.h                    |  650 ++++++++
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
 67 files changed, 28063 insertions(+), 0 deletions(-)
