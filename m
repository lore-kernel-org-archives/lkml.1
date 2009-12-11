Return-Path: <linux-kernel-owner+w=401wt.eu-S933200AbZLKAGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200AbZLKAGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761625AbZLKAGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:06:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760725AbZLKAGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:06:08 -0500
Date: Fri, 11 Dec 2009 00:05:48 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Mike Snitzer <snitzer@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Jonathan Brassow <jbrassow@redhat.com>, Julia Lawall <julia@diku.dk>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Mike Anderson <andmike@linux.vnet.ibm.com>,
       Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Roel Kluin <roel.kluin@gmail.com>
Subject: [git pull] device-mapper patches for 2.6.33-rc1
Message-ID: <20091211000548.GS6208@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Jonathan Brassow <jbrassow@redhat.com>,
	Julia Lawall <julia@diku.dk>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Li Zefan <lizf@cn.fujitsu.com>,
	Mike Anderson <andmike@linux.vnet.ibm.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Milan Broz <mbroz@redhat.com>, Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

to get device-mapper fixes and enhancements for inclusion in 2.6.33-rc1.

The main new feature is support for merging the changes held in a
snapshot back into the original device.  Barriers are now supported
by all the types of dm devices.

Alasdair G Kergon (3):
      dm: rename dm_get_table to dm_get_live_table
      dm: bind new table before destroying old
      dm: keep old table until after resume succeeded

Jon Brassow (5):
      dm snapshot: avoid else clause in persistent_read_metadata
      dm snapshot: consolidate insert exception functions
      dm snapshot: rename dm_snap_exception to dm_exception
      dm snapshot: rename exception_table to dm_exception_table
      dm snapshot: rename exception functions

Julia Lawall (1):
      dm exception store: free tmp_store on persistent flag error

Jun'ichi Nomura (1):
      dm: trace request based remapping

Kiyoshi Ueda (14):
      dm: abstract dm_in_flight function
      dm: use clone in map_request function
      dm: pass gfp_mask to alloc_rq_tio
      dm: abstract clone_rq
      dm: simplify request based suspend
      dm: use md pending for in flight IO counting
      dm: refactor request based completion functions
      dm: move dm_end_request
      dm: add request based barrier support
      dm mpath: flush workqueues before suspend completes
      dm: swap target postsuspend call and setting suspended flag
      dm: rename dm_suspended to dm_suspended_md
      dm: export suspended state to targets
      dm mpath: reject messages when device is suspended

Mike Anderson (4):
      dm: add dm_deleting_md function
      dm ioctl: forbid messages to devices being deleted
      dm mpath: add mutex to synchronize adding and flushing work
      dm mpath: prevent io from work queue while suspended

Mike Snitzer (9):
      dm snapshot: add allocated metadata to snapshot status
      dm snapshot: move cow ref from exception store to snap core
      dm snapshot: track suspended state in target
      dm ioctl: retrieve status from inactive table
      dm snapshot: allow live exception store handover between tables
      dm snapshot: create function for chunk_is_tracked wait
      dm snapshot: support barriers in snapshot merge target
      dm snapshot: merge consecutive chunks together
      dm snapshot: report merge failure in status

Mikulas Patocka (35):
      dm: avoid _hash_lock deadlock
      dm snapshot: only take lock for statustype info not table
      dm snapshot: cope with chunk size larger than origin
      dm io: use slab for struct io
      dm io: remove extra bi_io_vec region hack
      dm raid1: support flush
      dm raid1: split touched state into two
      dm log: add flush_header function
      dm log: introduce flush_failed variable
      dm log: add flush callback fn
      dm log: use flush callback fn
      dm raid1: implement mirror_flush
      dm raid1: report flush errors separately in status
      dm raid1: add framework to hold bios during suspend
      dm raid1: use hold framework in do_failures
      dm raid1: abstract get_valid_mirror function
      dm raid1: remove bio_endio from dm_rh_mark_nosync
      dm raid1: hold write bios when errors are handled
      dm raid1: hold all write bios when leg fails
      dm raid1: explicitly initialise bio_lists
      dm snapshot: simplify sector_to_chunk expression
      dm snapshot: abstract minimum_chunk_size fn
      dm kcopyd: accept zero size jobs
      dm io: handle empty barriers
      dm snapshot: make bio optional in __origin_write
      dm exception store: add merge specific methods
      dm snapshot: add merge target
      dm snapshot: rework writing to origin
      dm snapshot: avoid allocating exceptions in merge
      dm snapshot: permit only one merge at once
      dm snapshot: add merging
      dm snapshot: queue writes to chunks being merged
      dm snapshot: delay merging a chunk until writes to it complete
      dm snapshot: trigger exceptions in remaining snapshots during merge
      dm snapshot: use merge origin if snapshot invalid

Milan Broz (7):
      dm: sysfs add empty release function to avoid debug warning
      dm crypt: make wipe message also wipe tfm key
      dm crypt: move private iv fields to structs
      dm crypt: restructure essiv error path
      dm crypt: separate essiv allocation from initialisation
      dm crypt: make wipe message also wipe essiv key
      dm crypt: add plain64 iv

Roel Kluin (1):
      dm ioctl: prefer strlcpy over strncpy

 Documentation/device-mapper/snapshot.txt |   60 ++-
 drivers/md/dm-crypt.c                    |  207 ++++--
 drivers/md/dm-exception-store.c          |   33 +-
 drivers/md/dm-exception-store.h          |   62 ++-
 drivers/md/dm-io.c                       |  120 ++-
 drivers/md/dm-ioctl.c                    |  123 +++-
 drivers/md/dm-kcopyd.c                   |    5 +-
 drivers/md/dm-log.c                      |   77 ++-
 drivers/md/dm-mpath.c                    |   95 ++-
 drivers/md/dm-raid1.c                    |  219 ++++--
 drivers/md/dm-region-hash.c              |   31 +-
 drivers/md/dm-snap-persistent.c          |  195 ++++-
 drivers/md/dm-snap-transient.c           |   24 +-
 drivers/md/dm-snap.c                     | 1279 ++++++++++++++++++++++++------
 drivers/md/dm-sysfs.c                    |   10 +-
 drivers/md/dm-table.c                    |    3 +
 drivers/md/dm-uevent.c                   |    9 +-
 drivers/md/dm.c                          |  643 +++++++++-------
 drivers/md/dm.h                          |   13 +
 include/linux/device-mapper.h            |    8 +-
 include/linux/dm-dirty-log.h             |    6 +-
 include/linux/dm-ioctl.h                 |   13 +-
 include/linux/dm-region-hash.h           |    3 +-
 23 files changed, 2349 insertions(+), 889 deletions(-)

Alasdair.
