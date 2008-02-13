Return-Path: <linux-kernel-owner+w=401wt.eu-S1763591AbYBMEDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763591AbYBMEDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 23:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbYBMED1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 23:03:27 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59996 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbYBMED0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 23:03:26 -0500
Date: Wed, 13 Feb 2008 04:03:25 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: [PATCH] wmi: (!x & y) strikes again
Message-ID: <20080213040325.GS27894@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
d2d6f5b9eb315a53043a722d952bb21ed5ca1229
diff --git a/drivers/acpi/wmi.c b/drivers/acpi/wmi.c
index 457ed3d..efacc9f 100644
--- a/drivers/acpi/wmi.c
+++ b/drivers/acpi/wmi.c
@@ -247,7 +247,7 @@ u32 method_id, const struct acpi_buffer *in, struct acpi_buffer *out)
 	block = &wblock->gblock;
 	handle = wblock->handle;
 
-	if (!block->flags & ACPI_WMI_METHOD)
+	if (!(block->flags & ACPI_WMI_METHOD))
 		return AE_BAD_DATA;
 
 	if (block->instance_count < instance)
