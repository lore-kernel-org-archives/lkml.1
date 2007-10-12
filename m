Return-Path: <linux-kernel-owner+w=401wt.eu-S1763118AbXJLR1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763118AbXJLR1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763224AbXJLRYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:24:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763056AbXJLRYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:24:04 -0400
Date: Fri, 12 Oct 2007 18:23:59 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.24 PATCH 25/25] dm raid1: add mirror_set to struct mirror
Message-ID: <20071012172359.GK24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
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

Store a pointer to the owning mirror_set structure within each mirror
structure for a subsequent patch to use.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-raid1.c |    2 ++
 1 files changed, 2 insertions(+)

Index: linux-2.6.23/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-raid1.c	2007-10-12 15:03:32.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-raid1.c	2007-10-12 15:03:33.000000000 +0100
@@ -114,6 +114,7 @@ struct region {
  * Mirror set structures.
  *---------------------------------------------------------------*/
 struct mirror {
+	struct mirror_set *ms;
 	atomic_t error_count;
 	struct dm_dev *dev;
 	sector_t offset;
@@ -1017,6 +1018,7 @@ static int get_mirror(struct mirror_set 
 		return -ENXIO;
 	}
 
+	ms->mirror[mirror].ms = ms;
 	ms->mirror[mirror].offset = offset;
 
 	return 0;
