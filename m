Return-Path: <linux-kernel-owner+w=401wt.eu-S1760181AbZDONM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181AbZDONM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 09:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759392AbZDONKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 09:10:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:34998 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759645AbZDONKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 09:10:45 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [GIT PATCH block#for-linus] block: various fixes
Date: Wed, 15 Apr 2009 22:10:22 +0900
Message-Id: <1239801027-9201-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 15 Apr 2009 13:10:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset contains the following five block related fix patches.

 0001-scatterlist-make-sure-sg_miter_next-doesn-t-retur.patch
 0002-block-fix-SG_IO-vector-request-data-length-handling.patch
 0003-block-fix-queue-bounce-limit-setting.patch
 0004-bio-fix-bio_kmalloc.patch
 0005-bio-use-bio_kmalloc-in-copy-map-functions.patch

0001-0003 are unchanged re-posting of the first three patches of
blk-map-related-fixes[1].  The fourth patch of the previous patchset
is dropped and 0004 reimplements bio_kmalloc() as per Jens'
suggestion.  0005 is new and uses bio_kmalloc() in the map functions.

This patchset is also available in the following git tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blk-fixes

and contains the following changes.

 block/blk-settings.c |   20 ++++----
 block/scsi_ioctl.c   |   13 +++++
 fs/bio.c             |  114 +++++++++++++++++++++++++--------------------------
 include/linux/bio.h  |    1 
 lib/scatterlist.c    |    9 ++--
 5 files changed, 88 insertions(+), 69 deletions(-)

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/815647
