Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbZJJMBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbZJJMBE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 08:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbZJJMBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 08:01:03 -0400
Received: from server1.wserver.cz ([82.113.45.157]:47270 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbZJJMBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 08:01:01 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: rjw@sisk.pl
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] PM / Hibernate: swap, use KERN_CONT
Date: Sat, 10 Oct 2009 14:00:24 +0200
Message-Id: <1255176024-12420-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use KERN_CONT in save_image for printks. So that anybody won't
try to add a loglevel.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 kernel/power/swap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 47586d9..4c0f80b 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -437,7 +437,7 @@ static int save_image(struct swap_map_handle *handle,
 		if (ret)
 			break;
 		if (!(nr_pages % m))
-			printk("\b\b\b\b%3d%%", nr_pages / m);
+			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
 		nr_pages++;
 	}
 	err2 = wait_on_bio_chain(&bio);
@@ -445,9 +445,9 @@ static int save_image(struct swap_map_handle *handle,
 	if (!ret)
 		ret = err2;
 	if (!ret)
-		printk("\b\b\b\bdone\n");
+		printk(KERN_CONT "\b\b\b\bdone\n");
 	else
-		printk("\n");
+		printk(KERN_CONT "\n");
 	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
 	return ret;
 }
-- 
1.6.4.2

