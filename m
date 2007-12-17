Return-Path: <linux-kernel-owner+w=401wt.eu-S935434AbXLQChL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935434AbXLQChL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 21:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935416AbXLQCgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 21:36:09 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:39643 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934549AbXLQCgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 21:36:07 -0500
Date: Mon, 17 Dec 2007 03:36:05 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071217023605.24944.67698.sendpatchset@thinktank.campus.ltu.se>
In-Reply-To: <20071217023555.24944.62155.sendpatchset@thinktank.campus.ltu.se>
References: <20071217023555.24944.62155.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH 3/3] ipc: Convert handmade 'min' to min().
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert handmade 'min' to min().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Dependent on 'msg->m_ts' being changed from int to size_t.


diff --git a/ipc/msg.c b/ipc/msg.c
index fdf3db5..74d0709 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -920,7 +920,7 @@ out_unlock:
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
-	msgsz = (msgsz > msg->m_ts) ? msg->m_ts : msgsz;
+	msgsz = min(msgsz, msg->m_ts);
 	*pmtype = msg->m_type;
 	if (store_msg(mtext, msg, msgsz))
 		msgsz = -EFAULT;
