Return-Path: <linux-kernel-owner+w=401wt.eu-S933123AbZFOSDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123AbZFOSDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765188AbZFOSAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:00:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:46692 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765059AbZFOR76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:59:58 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, npiggin@suse.de,
       Jan Kara <jack@suse.cz>
Subject: [PATCH 09/11] vfs: Export wakeup_pdflush
Date: Mon, 15 Jun 2009 19:59:56 +0200
Message-Id: <1245088797-29533-10-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245088797-29533-1-git-send-email-jack@suse.cz>
References: <1245088797-29533-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we are running out of free space on a filesystem, we want to flush dirty
pages in the filesystem so that blocks reserved via delayed allocation get
written and unnecessary block reservation is released. Export wakeup_pdflush()
so that filesystem can start such writeback.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/page-writeback.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index bb553c3..43af1cf 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -730,6 +730,7 @@ int wakeup_pdflush(long nr_pages)
 				global_page_state(NR_UNSTABLE_NFS);
 	return pdflush_operation(background_writeout, nr_pages);
 }
+EXPORT_SYMBOL(wakeup_pdflush);
 
 static void wb_timer_fn(unsigned long unused);
 static void laptop_timer_fn(unsigned long unused);
-- 
1.6.0.2

