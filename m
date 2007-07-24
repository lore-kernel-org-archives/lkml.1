Return-Path: <linux-kernel-owner+w=401wt.eu-S935479AbXGXI7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935479AbXGXI7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935351AbXGXI7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:59:18 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:11828 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935339AbXGXI7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:59:16 -0400
Date: Tue, 24 Jul 2007 12:59:47 +0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>
Subject: [PATCH 8/8] dm: dm-target.c Convert  kmalloc + memset  to kzalloc
Message-ID: <20070724085947.GH16507@dnb.sw.ru>
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
 drivers/md/dm-target.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 477a041..835cf95 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -88,12 +88,10 @@ void dm_put_target_type(struct target_type *t)
 
 static struct tt_internal *alloc_target(struct target_type *t)
 {
-	struct tt_internal *ti = kmalloc(sizeof(*ti), GFP_KERNEL);
+	struct tt_internal *ti = kzalloc(sizeof(*ti), GFP_KERNEL);
 
-	if (ti) {
-		memset(ti, 0, sizeof(*ti));
+	if (ti)
 		ti->tt = *t;
-	}
 
 	return ti;
 }
-- 
1.5.2.2


