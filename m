Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZESJfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZESJfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZESJfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:35:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:55120 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbZESJfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:35:38 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-ide@vger.kernel.org, jens.axboe@oracle.com, bharrosh@panasas.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       bzolnier@gmail.com, petkovbb@googlemail.com, zaitcev@redhat.com,
       sshtylyov@ru.mvista.com, Eric.Moore@lsi.com, djwong@us.ibm.com
Subject: [PATCHSET block#for-2.6.31] block: fix fallouts from recent cleanups, take#2
Date: Tue, 19 May 2009 18:33:03 +0900
Message-Id: <1242725586-13142-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 19 May 2009 09:33:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the second take of fix-fallouts patchset.  The first one[L]
was posted without header message.  Changes from the last take are

* ub change updated per Pete Zitcev's comment

* resid_len init bug spotted by Boaz Harrosh fixed

This patchset contains the following three patches.

  0001-ub-use-__blk_end_request_all.patch
  0002-block-set-rq-resid_len-to-blk_rq_bytes-on-issue.patch
  0003-bio-always-copy-back-data-for-copied-kernel-request.patch

0001 updates ub to use __blk_end_request_all() and 0002 restores the
original residue count behavior.  0003 makes sure kernel pc buffer is
bounced back even on request failure as user pc ones do.  This
inconsistency was discovered during discussion over residue count
semantics.

This patchset contains the following changes.

 block/blk-core.c                         |    5 +++--
 drivers/block/ub.c                       |   30 +++++++++++-------------------
 drivers/ide/ide-cd.c                     |    4 ++--
 drivers/ide/ide-tape.c                   |    2 +-
 drivers/message/fusion/mptsas.c          |    3 ++-
 drivers/scsi/libsas/sas_expander.c       |    4 ++++
 drivers/scsi/libsas/sas_host_smp.c       |    3 ---
 drivers/scsi/mpt2sas/mpt2sas_transport.c |    4 ++--
 fs/bio.c                                 |    2 +-
 9 files changed, 26 insertions(+), 31 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.ide/40728
