Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbZGFPju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbZGFPju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 11:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbZGFPje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 11:39:34 -0400
Received: from mail09.linbit.com ([212.69.161.110]:42205 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZGFPjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 11:39:33 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, drbd-dev@lists.linbit.com,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 00/16] drbd: a block device for HA clusters
Date: Mon,  6 Jul 2009 17:39:19 +0200
Message-Id: <1246894775-10855-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As the first bit of the DBRD patch already got upstream (see commit
10fc89d01a) it is time to get more of DRBD towards mainline.

Here is a post of drbd-8.3.2 for inclusion into linux-mm (or linux-next).

Patch set attached. Git tree available:
git pull git://git.drbd.org/linux-2.6-drbd.git drbd

In case you want to review the code, here is a note for you:

  Only the first patch (lru_cache) is self contained. The other patches are
  just split at file boundaries. Sorry, DRBD was developed as out-of-tree
  modules just for too long.

Short Description

  DRBD is a shared-nothing, replicated block device. It is designed to
  serve as a building block for high availability clusters and

  in this context, is a "drop-in" replacement for shared storage.
  Simplistically, you could see it as a network RAID 1.

  More information can be found at http://www.drbd.org

Changes since 2009-06-26

  * Cleanup: Added an entry to the MAINTAINERS file
  * DRBD:    Now at drbd-8.3.2:
  * DRBD:    Fixed a hard to trigger race condition. (kmap_atomic(..., KM_IRQ1) interruptible)

Changes since 2009-05-15

  * Cleanup: Moved lru_cache.c to /lib
  * Cleanup: all STATIC -> static
  * Cleanup: Removed drbd_config.h ; New Kconfig option: CONFIG_DRBD_FAULT_INJECTION
  * Cleanup: Removed drbd_buildtag.c
  * DRBD:    Following DRBD-upstream, now at 8.3.2-rc2. Relevant changes:
  * DRBD:    lru_cache: use pointer arrays and kmem_cache
  * DRBD:    Fixed for building on big endian architectures
  * DRBD:    Fixed nl stuff to work on architectures that does not do unaligned memory accesses
  * DRBD:    Deal with hash functions already ported to SHASH
  * DRBD:    GFP_KERNEL -> GFP_NOIO in various places

Changes since 2009-04-30

  * Cleanup: Removed typecasts, more documentation in lru_cache. Moved to /lib
  * Cleanup: replaced __attribute__((packed)) with __packed
  * Cleanup: remove quite a few 'inline's from .c files
  * Cleanup: renaming a few constants: _SECT -> _SECTOR_SIZE, _SIZE_B -> _SHIFT ...
  * Cleanup: rename inc_local -> get_ldev; inc_net -> get_net_conf; and corresponding dec_* -> put_*
  * Cleanup: rename mdev->bc to mdev->ldev (to match the recent change to get_ldev/put_ldev)
  * Cleanup: Made function comments kernel-doc compliant
  * Cleanup: vmalloc() only as a fall back for kmalloc()
  * DRBD:    Allow detach of a SyncTarget node. (Bugz 221)
  * DRBD:    Call drbd_rs_cancel_all() and reset rs_pending when aborting resync due to detach. (Bugz 223)
  * DRBD:    make drbd thread t_lock irqsave - lockdep complained, and lockdep is right (theoretically)

Changes since 2009-04-10

  * Cleanup: Removed all CamelCase
  * Cleanup: Replaced DRBD's own tracing stuff with regular tracepoints
  * Cleanup: Removed ERR/INFO/ALERT ... macros, using dev_err/dev_info/... now
  * Cleanup: Minor stuff, as suggested in feedback on LKML
  * DRBD:    Bitmap compression feature was finalised
  * DRBD:    new disable_sendpage parameter

Changes since the post on 2009-03-30, all triggered by reviews

  * Improvements to Makefile and Kconfig
  * Simplified definitions of bm_flags' bitnumbers
  * Removed debugging aid

Changes since the post on 2009-03-23, from drbd-mainline

  * Updated to the final drbd-8.3.1 code
  * Optionally run-length encode bitmap transfers

Changes since the post on 2009-03-23, triggered by reviews

  * Using the latest proc_create() now
  * Moved the allocation of md_io_tmpp to attach/detach out of drbd_md_sync_page_io()
  * Removing the mode selection comments for emacs
  * Removed DRBD_ratelimit()

cheers,
  Phil
