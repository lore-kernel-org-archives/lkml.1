Return-Path: <linux-kernel-owner+w=401wt.eu-S934982AbXGXI4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934982AbXGXI4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765151AbXGXI4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:56:12 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:26275 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763150AbXGXI4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:56:11 -0400
Date: Tue, 24 Jul 2007 12:56:42 +0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>
Subject: [PATCH 2/8] dm: Fix workqueue leak for raid5
Message-ID: <20070724085642.GB16507@dnb.sw.ru>
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
 drivers/md/raid5.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0f30826..79dd2c7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4985,6 +4985,8 @@ static int run(mddev_t *mddev)
 abort:
 	if (conf) {
 		print_raid5_conf(conf);
+		if (conf->workqueue)
+			destroy_workqueue(conf->workqueue);
 		safe_put_page(conf->spare_page);
 		kfree(conf->disks);
 		kfree(conf->stripe_hashtbl);
-- 
1.5.2.2


