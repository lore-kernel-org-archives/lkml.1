Return-Path: <linux-kernel-owner+w=401wt.eu-S935349AbXGXI6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935349AbXGXI6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935271AbXGXI63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:58:29 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:12946 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935072AbXGXI60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:58:26 -0400
Date: Tue, 24 Jul 2007 12:58:57 +0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>
Subject: [PATCH 6/8] dm: dm-emc.c Convert  kmalloc + memset  to kzalloc
Message-ID: <20070724085857.GF16507@dnb.sw.ru>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	device-mapper development <dm-devel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724085106.GD20538@dnb.sw.ru>
Organization: SWsoft
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/md/dm-emc.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-emc.c b/drivers/md/dm-emc.c
index 265c467..f04e950 100644
--- a/drivers/md/dm-emc.c
+++ b/drivers/md/dm-emc.c
@@ -224,12 +224,10 @@ fail_path:
 
 static struct emc_handler *alloc_emc_handler(void)
 {
-	struct emc_handler *h = kmalloc(sizeof(*h), GFP_KERNEL);
+	struct emc_handler *h = kzalloc(sizeof(*h), GFP_KERNEL);
 
-	if (h) {
-		memset(h, 0, sizeof(*h));
+	if (h)
 		spin_lock_init(&h->lock);
-	}
 
 	return h;
 }
-- 
1.5.2.2


