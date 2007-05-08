Return-Path: <linux-kernel-owner+w=401wt.eu-S968126AbXEHTux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968126AbXEHTux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968074AbXEHTu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:50:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967084AbXEHTuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:50:21 -0400
Date: Tue, 8 May 2007 20:49:17 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.22 PATCH 25/26] dm raid1: switch rh_in_sync to blocking in do_reads
Message-ID: <20070508194917.GF24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Jonathan Brassow <jbrassow@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Brassow <jbrassow@redhat.com>

The call to rh_in_sync() in do_reads() should be allowed to block.  It
is in the mirror worker thread which already permits blocking
operations.  This will be needed to support clustered mirroring which
will perform network operations.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-raid1.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-raid1.c	2007-05-01 19:20:17.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-raid1.c	2007-05-01 19:20:19.000000000 +0100
@@ -741,7 +741,7 @@ static void do_reads(struct mirror_set *
 		/*
 		 * We can only read balance if the region is in sync.
 		 */
-		if (rh_in_sync(&ms->rh, region, 0))
+		if (rh_in_sync(&ms->rh, region, 1))
 			m = choose_mirror(ms, bio->bi_sector);
 		else
 			m = ms->default_mirror;
