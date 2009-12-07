Return-Path: <linux-kernel-owner+w=401wt.eu-S965171AbZLGXZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965171AbZLGXZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 18:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935067AbZLGXZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 18:25:16 -0500
Received: from cobra.newdream.net ([66.33.216.30]:54222 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758339AbZLGXZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 18:25:14 -0500
Date: Mon, 7 Dec 2009 15:25:21 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] Ceph distributed file system client for 2.6.33
Message-ID: <Pine.LNX.4.64.0912071511470.32397@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git master

to receive the Ceph distributed file system client.  The fs has made a 
half dozen rounds on linux-fsdevel, and has been in linux-next for the 
last month or so.  Although review has been sparse, Andrew said the code 
looks reasonable for 2.6.33.

The git tree includes the full patchset posted in October and incremental 
changes since then.  I've tried to cram in all the anticipated protocol 
changes, but the file system is still strictly EXPERIMENTAL and is marked 
as such.  Merging now will attract new eyes and make it easier to test and 
evaluate the system (both the client and server side).

Basic features include:

 * High availability and reliability.  No single points of failure.
 * Strong data and metadata consistency between clients
 * N-way replication of all data across storage nodes
 * Seamless scaling from 1 to potentially many thousands of nodes
 * Fast recovery from node failures
 * Automatic rebalancing of data on node addition/removal
 * Easy deployment: most FS components are userspace daemons

More info on Ceph at

	http://ceph.newdream.net/

Thanks-
sage


Julia Lawall (2):
      fs/ceph: introduce missing kfree
      fs/ceph: Move a dereference below a NULL test

Noah Watkins (3):
      ceph: replace list_entry with container_of
      ceph: remove redundant use of le32_to_cpu
      ceph: fix intra strip unit length calculation

Sage Weil (93):
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

Yehuda Sadeh (1):
      ceph: mount fails immediately on error

----
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
