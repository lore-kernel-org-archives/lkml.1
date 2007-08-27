Return-Path: <linux-kernel-owner+w=401wt.eu-S933221AbXH0Vdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221AbXH0Vdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbXH0V2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:28:17 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58820 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764868AbXH0V2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:28:13 -0400
Date: Mon, 27 Aug 2007 23:28:12 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] make the dummy touchkit_ps2_detect() static
Message-ID: <20070827212812.GU4121@stusta.de>
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

This patch has been sent on:
- 14 Aug 2007

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

