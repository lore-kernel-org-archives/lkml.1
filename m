Return-Path: <linux-kernel-owner+w=401wt.eu-S1761716AbXGKVAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761716AbXGKVAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933475AbXGKU7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:59:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933058AbXGKU7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:59:04 -0400
Date: Wed, 11 Jul 2007 21:58:29 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Milan Broz <mbroz@redhat.com>
Subject: [2.6.23 PATCH 06/18] dm raid1: fix status
Message-ID: <20070711205829.GX24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Milan Broz <mbroz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milan Broz <mbroz@redhat.com>

Fix mirror status line broken in dm-log-report-fault-status.patch:
  - space missing between two words
  - placeholder ("0") required for compatibility with a subsequent patch
  - incorrect offset parameter

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-raid1.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/md/dm-raid1.c
===================================================================
--- linux.orig/drivers/md/dm-raid1.c	2007-07-11 21:37:40.000000000 +0100
+++ linux/drivers/md/dm-raid1.c	2007-07-11 21:37:42.000000000 +0100
@@ -1288,12 +1288,12 @@ static int mirror_status(struct dm_targe
 		for (m = 0; m < ms->nr_mirrors; m++)
 			DMEMIT("%s ", ms->mirror[m].dev->name);
 
-		DMEMIT("%llu/%llu",
+		DMEMIT("%llu/%llu 0 ",
 			(unsigned long long)ms->rh.log->type->
 				get_sync_count(ms->rh.log),
 			(unsigned long long)ms->nr_regions);
 
-		sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
+		sz += ms->rh.log->type->status(ms->rh.log, type, result+sz, maxlen-sz);
 
 		break;
 
