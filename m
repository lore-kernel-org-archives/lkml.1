Return-Path: <linux-kernel-owner+w=401wt.eu-S1759872AbZACKma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbZACKma (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 05:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbZACKmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 05:42:21 -0500
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:44274 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbZACKmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 05:42:21 -0500
From: Trent Piepho <xyzzy@speakeasy.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH] printk: Let %pR handle NULL pointers
Date: Sat,  3 Jan 2009 02:42:21 -0800
Message-Id: <1230979341-23029-1-git-send-email-xyzzy@speakeasy.org>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have %pR print "[NULL]" for the resource range when passed a NULL pointer.

Trying to print a NULL pointer with %pR crashes, though printing a NULL
pointer with %p works fine.  It isn't very helpful to put in a dev_dbg() to
print a resource and have the kernel crash because sometimes the resource
can be NULL.

Printing "[NULL]" is more useful than crashing when the resource isn't
supposed to be NULL and simplifies code in cases where one wants to print a
resource range than is allowed to be NULL.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
---
 lib/vsprintf.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3b77702..2879a1b 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -566,6 +566,9 @@ static char *resource_string(char *buf, char *end, struct resource *res, int fie
 	char *p = sym, *pend = sym + sizeof(sym);
 	int size = -1;
 
+	if (!res)
+		return string(buf, end, "[NULL]", field_width, precision, flags);
+
 	if (res->flags & IORESOURCE_IO)
 		size = IO_RSRC_PRINTK_SIZE;
 	else if (res->flags & IORESOURCE_MEM)
-- 
1.5.4.3

