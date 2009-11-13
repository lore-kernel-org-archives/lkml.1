Return-Path: <linux-kernel-owner+w=401wt.eu-S932363AbZKMT6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbZKMT6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:58:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932292AbZKMT5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:57:54 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:37308 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254AbZKMT5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:57:52 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, gregkh@suse.de, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/3] vgacon: Add support for setting the default cursor state
Date: Fri, 13 Nov 2009 14:57:02 -0500
Message-Id: <1258142222-16092-3-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1258142222-16092-2-git-send-email-mjg@redhat.com>
References: <1258142222-16092-1-git-send-email-mjg@redhat.com>
 <1258142222-16092-2-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass the vga cursor state to the vt layer, ensuring that we don't hide
the cursor when the bootloader has deliberately disabled it.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/video/console/vgacon.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 564643e..cc4bbbe 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -586,7 +586,10 @@ static void vgacon_init(struct vc_data *c, int init)
 	if (!vgacon_uni_pagedir[0] && p)
 		con_set_default_unimap(c);
 
-	hide_boot_cursor(screen_info.flags & VIDEO_FLAGS_NOCURSOR);
+	/* Only set the default if the user didn't deliberately override it */
+	if (global_cursor_default == -1)
+		global_cursor_default =
+			!(screen_info.flags & VIDEO_FLAGS_NOCURSOR);
 }
 
 static void vgacon_deinit(struct vc_data *c)
-- 
1.6.5.2

