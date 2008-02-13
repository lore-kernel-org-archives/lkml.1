Return-Path: <linux-kernel-owner+w=401wt.eu-S1762783AbYBMD5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762783AbYBMD5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 22:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYBMD5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 22:57:01 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44374 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbYBMD5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 22:57:00 -0500
Date: Wed, 13 Feb 2008 03:56:59 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alex Dubov <oakad@yahoo.com>
Subject: [PATCH] drivers/memstick/host/tifm_ms.c breakage
Message-ID: <20080213035659.GQ27894@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

readl(sock + ...) that should've been readl(sock->addr + ...)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index f55b71a..4fb2421 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -282,7 +282,7 @@ static int tifm_ms_issue_cmd(struct tifm_ms *host)
 
 			writel(TIFM_MS_SYS_LATCH
 			       | readl(sock->addr + SOCK_MS_SYSTEM),
-			       sock + SOCK_MS_SYSTEM);
+			       sock->addr + SOCK_MS_SYSTEM);
 			writel(0, sock->addr + SOCK_MS_DATA);
 			dev_dbg(&sock->dev, "writing %x\n", 0);
 
