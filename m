Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbZBBMYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbZBBMYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 07:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZBBMYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 07:24:40 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47719 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbZBBMYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 07:24:39 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 2 Feb 2009 13:24:34 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] async: use list_move_tail
To: Arjan van de Ven <arjan@linux.intel.com>
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.5292a11a4eb9fe66@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 kernel/async.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index dd14fc5..c3baaa8 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -133,8 +133,7 @@ static void run_one_entry(void)
 	entry = list_first_entry(&async_pending, struct async_entry, list);
 
 	/* 2) move it to the running queue */
-	list_del(&entry->list);
-	list_add_tail(&entry->list, entry->running);
+	list_move_tail(&entry->list, entry->running);
 	spin_unlock_irqrestore(&async_lock, flags);
 
 	/* 3) run it (and print duration)*/
-- 
1.6.0.6


-- 
Stefan Richter
-=====-==--= --=- ---=-
http://arcgraph.de/sr/

