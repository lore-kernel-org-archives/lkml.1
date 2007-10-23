Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbXJWBQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbXJWBQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 21:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbXJWBQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 21:16:44 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:49487 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbXJWBQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 21:16:43 -0400
Message-ID: <471D4B79.2070500@tiscali.nl>
Date: Tue, 23 Oct 2007 03:16:41 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Unlock before return in p9_mux_poll_start
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 9f822afc65cc094c905901f9d92bf25042f9ed22
Author: Roel Kluin <12o3l@tiscali.nl>
Date:   Tue Oct 23 03:15:55 2007 +0200

    Unlock before return in p9_mux_poll_start
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

diff --git a/net/9p/mux.c b/net/9p/mux.c
index f140147..c9f0805 100644
--- a/net/9p/mux.c
+++ b/net/9p/mux.c
@@ -222,8 +222,10 @@ static int p9_mux_poll_start(struct p9_conn *m)
 	}
 
 	if (i >= ARRAY_SIZE(p9_mux_poll_tasks)) {
-		if (vptlast == NULL)
+		if (vptlast == NULL) {
+			mutex_unlock(&p9_mux_task_lock);
 			return -ENOMEM;
+		}
 
 		P9_DPRINTK(P9_DEBUG_MUX, "put in proc %d\n", i);
 		list_add(&m->mux_list, &vptlast->mux_list);

