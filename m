Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbXKXWCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbXKXWCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 17:02:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbXKXWB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 17:01:57 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:50959 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbXKXWB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 17:01:56 -0500
Date: Sat, 24 Nov 2007 23:01:49 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071124215015.20181.76052.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] kernel: Compliment va_copy with va_end()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Compliment va_copy() with va_end().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested on i386 with allyesconfig & allmodconfig.


diff --git a/kernel/audit.c b/kernel/audit.c
index f93c271..836626c 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1245,6 +1245,7 @@ static void audit_log_vformat(struct audit_buffer *ab, const char *fmt,
 			goto out;
 		len = vsnprintf(skb_tail_pointer(skb), avail, fmt, args2);
 	}
+	va_end(args2);
 	if (len > 0)
 		skb_put(skb, len);
 out:
