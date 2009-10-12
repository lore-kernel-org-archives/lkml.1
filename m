Return-Path: <linux-kernel-owner+w=401wt.eu-S933270AbZJLVj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270AbZJLVj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933257AbZJLVj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:39:28 -0400
Received: from server1.wserver.cz ([82.113.45.157]:36457 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933212AbZJLVj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:39:28 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: rjw@sisk.pl
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] PM / Hibernate: add \n to load_image fail path
Date: Mon, 12 Oct 2009 23:38:50 +0200
Message-Id: <1255383530-6778-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <4AD39FBA.6000509@gmail.com>
References: <4AD39FBA.6000509@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finish a line by \n when load_image fails in the middle of loading.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 kernel/power/swap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 893f522..4bb5c3b 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -537,7 +537,8 @@ static int load_image(struct swap_map_handle *handle,
 		snapshot_write_finalize(snapshot);
 		if (!snapshot_image_loaded(snapshot))
 			error = -ENODATA;
-	}
+	} else
+		printk("\n");
 	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
 	return error;
 }
-- 
1.6.4.2

