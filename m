Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbZEOMLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbZEOMLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbZEOMLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:11:07 -0400
Received: from mail09.linbit.com ([212.69.161.110]:47002 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbZEOMLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:11:05 -0400
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
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 00/16] DRBD: a block device for HA clusters
Date: Fri, 15 May 2009 14:10:27 +0200
Message-Id: <1242389443-3470-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a repost of DRBD, to keep you updated about the ongoing
cleanups and improvements.

Patch set attached. Git tree available:
git pull git://git.drbd.org/linux-2.6-drbd.git drbd

We are looking for reviews!

Note for reviewers:

  Only the first two patches (major.h and lru_cache) are self contained.
  The other patches are just split at file boundaries. Sorry, DRBD
  was developed as out-of-tree modules just for too long.

Short Description

  DRBD is a shared-nothing, synchronously replicated block device. It
  is designed to serve as a building block for high availability
  clusters and in this context, is a "drop-in" replacement for shared
  storage. Simplistically, you could see it as a network RAID 1.

  More information can be found at http://www.drbd.org

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
