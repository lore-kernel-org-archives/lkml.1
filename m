Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZAETTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZAETTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZAETTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:19:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38308 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbZAETTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:19:06 -0500
Date: Mon, 5 Jan 2009 19:18:24 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jonathan Brassow <jbrassow@redhat.com>,
       Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Andi Kleen <ak@suse.de>, Cheng Renquan <crquan@gmail.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Takahiro Yasui <tyasui@redhat.com>
Subject: [git pull] device-mapper patches for 2.6.29
Message-ID: <20090105191824.GP5098@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Jonathan Brassow <jbrassow@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Milan Broz <mbroz@redhat.com>, Andi Kleen <ak@suse.de>,
	Cheng Renquan <crquan@gmail.com>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
	Takahiro Yasui <tyasui@redhat.com>
References: <20081010125159.GK5098@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010125159.GK5098@agk.fab.redhat.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git

to get the following device-mapper patches for 2.6.29:
 
Alasdair G Kergon (2):
      dm mpath: move trigger_event to system workqueue
      dm snapshot: split out exception store implementations

Andi Kleen (1):
      dm: support barriers on simple devices

Cheng Renquan (2):
      dm target: use module refcount directly
      dm target: remove struct tt_internal

Jonathan Brassow (4):
      dm raid1: fix error count
      dm snapshot: separate out exception store interface
      dm snapshot: rename struct exception_store
      dm snapshot: extend exception store functions

Kiyoshi Ueda (2):
      dm request: add caches
      dm request: extend target interface

Mikulas Patocka (4):
      dm table: drop reference at unbind
      dm snapshot: change yield to msleep
      dm: consolidate target deregistration error handling
      dm table: rework reference counting

Milan Broz (4):
      dm log: move region_size validation
      dm log: ensure log bitmap fits on log device
      dm ioctl: allow dm_copy_name_and_uuid to return only one field
      dm: add name and uuid to sysfs

Takahiro Yasui (2):
      dm log: fix dm_io_client leak on error paths
      dm log: avoid reinitialising io_req on every operation

 drivers/md/Makefile             |    5 +-
 drivers/md/dm-crypt.c           |    6 +-
 drivers/md/dm-delay.c           |    6 +-
 drivers/md/dm-exception-store.c |  749 +--------------------------------------
 drivers/md/dm-exception-store.h |  148 ++++++++
 drivers/md/dm-ioctl.c           |   16 +-
 drivers/md/dm-linear.c          |    6 +-
 drivers/md/dm-log.c             |   40 ++-
 drivers/md/dm-mpath.c           |   14 +-
 drivers/md/dm-raid1.c           |   24 +-
 drivers/md/dm-snap-persistent.c |  704 ++++++++++++++++++++++++++++++++++++
 drivers/md/dm-snap-transient.c  |   98 +++++
 drivers/md/dm-snap.c            |   48 ++-
 drivers/md/dm-snap.h            |  129 +-------
 drivers/md/dm-stripe.c          |    4 +-
 drivers/md/dm-sysfs.c           |   99 +++++
 drivers/md/dm-table.c           |   47 +++-
 drivers/md/dm-target.c          |  111 ++----
 drivers/md/dm-zero.c            |    5 +-
 drivers/md/dm.c                 |  101 ++++--
 drivers/md/dm.h                 |   12 +-
 include/linux/device-mapper.h   |   31 ++-
 22 files changed, 1352 insertions(+), 1051 deletions(-)
 create mode 100644 drivers/md/dm-exception-store.h
 create mode 100644 drivers/md/dm-snap-persistent.c
 create mode 100644 drivers/md/dm-snap-transient.c
 create mode 100644 drivers/md/dm-sysfs.c

Alasdair
-- 
agk@redhat.com
