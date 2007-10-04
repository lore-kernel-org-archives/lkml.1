Return-Path: <linux-kernel-owner+w=401wt.eu-S1762098AbXJDJfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098AbXJDJfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759747AbXJDJSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759665AbXJDJSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:41 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 48/51] [GFS2] Don't try to remove buffers that don't exist
Date: Thu,  4 Oct 2007 09:49:41 +0100
Message-Id: <1191487877383-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878753861-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
 <11914878141625-git-send-email-swhiteho@redhat.com>
 <1191487815172-git-send-email-swhiteho@redhat.com>
 <11914878173677-git-send-email-swhiteho@redhat.com>
 <11914878191964-git-send-email-swhiteho@redhat.com>
 <11914878214113-git-send-email-swhiteho@redhat.com>
 <11914878231394-git-send-email-swhiteho@redhat.com>
 <11914878252873-git-send-email-swhiteho@redhat.com>
 <11914878271468-git-send-email-swhiteho@redhat.com>
 <11914878283252-git-send-email-swhiteho@redhat.com>
 <11914878304004-git-send-email-swhiteho@redhat.com>
 <11914878323899-git-send-email-swhiteho@redhat.com>
 <11914878342921-git-send-email-swhiteho@redhat.com>
 <11914878361239-git-send-email-swhiteho@redhat.com>
 <11914878383633-git-send-email-swhiteho@redhat.com>
 <11914878401428-git-send-email-swhiteho@redhat.com>
 <11914878422398-git-send-email-swhiteho@redhat.com>
 <1191487844772-git-send-email-swhiteho@redhat.com>
 <1191487846406-git-send-email-swhiteho@redhat.com>
 <11914878472056-git-send-email-swhiteho@redhat.com>
 <11914878492645-git-send-email-swhiteho@redhat.com>
 <11914878513555-git-send-email-swhiteho@redhat.com>
 <11914878521254-git-send-email-swhiteho@redhat.com>
 <119148785427-git-send-email-swhiteho@redhat.com>
 <11914878551328-git-send-email-swhiteho@redhat.com>
 <11914878571888-git-send-email-swhiteho@redhat.com>
 <11914878592314-git-send-email-swhiteho@redhat.com>
 <1191487861683-git-send-email-swhiteho@redhat.com>
 <11914878632211-git-send-email-swhiteho@redhat.com>
 <1191487864951-git-send-email-swhiteho@redhat.com>
 <11914878661743-git-send-email-swhiteho@redhat.com>
 <11914878683674-git-send-email-swhiteho@redhat.com>
 <1191487870444-git-send-email-swhiteho@redhat.com>
 <1191487872941-git-send-email-swhiteho@redhat.com>
 <119148787317-git-send-email-swhiteho@redhat.com>
 <11914878753861-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 4002f41..873a511 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -747,7 +747,7 @@ int gfs2_releasepage(struct page *page, gfp_t gfp_mask)
 	struct gfs2_bufdata *bd;
 
 	if (!page_has_buffers(page))
-		goto out;
+		return 0;
 
 	gfs2_log_lock(sdp);
 	head = bh = page_buffers(page);
@@ -787,7 +787,6 @@ int gfs2_releasepage(struct page *page, gfp_t gfp_mask)
 		bh = bh->b_this_page;
 	} while (bh != head);
 
-out:
 	return try_to_free_buffers(page);
 cannot_release:
 	gfs2_log_unlock(sdp);
-- 
1.5.1.2

