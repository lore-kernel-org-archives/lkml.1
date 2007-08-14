Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbXHNVab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbXHNVab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXHNVXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:23:08 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38420 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755214AbXHNVXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:23:01 -0400
Date: Tue, 14 Aug 2007 23:22:52 +0200
From: Adrian Bunk <bunk@kernel.org>
To: dmitry.torokhov@gmail.com
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make the dummy touchkit_ps2_detect() static
Message-ID: <20070814212252.GF18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The dummy touchkit_ps2_detect() for the CONFIG_MOUSE_PS2_TOUCHKIT=n case 
shouldn't be a global function.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
64d15c53e66b200d832a6009aa24c344883bcbcf 
diff --git a/drivers/input/mouse/touchkit_ps2.h b/drivers/input/mouse/touchkit_ps2.h
index 61e9dfd..8a0dd35 100644
--- a/drivers/input/mouse/touchkit_ps2.h
+++ b/drivers/input/mouse/touchkit_ps2.h
@@ -15,7 +15,8 @@
 #ifdef CONFIG_MOUSE_PS2_TOUCHKIT
 int touchkit_ps2_detect(struct psmouse *psmouse, int set_properties);
 #else
-inline int touchkit_ps2_detect(struct psmouse *psmouse, int set_properties)
+static inline int touchkit_ps2_detect(struct psmouse *psmouse,
+				      int set_properties)
 {
 	return -ENOSYS;
 }

