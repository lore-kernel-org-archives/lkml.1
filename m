Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbZLTRLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbZLTRLb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 12:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbZLTRLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 12:11:30 -0500
Received: from mail.gmx.net ([213.165.64.20]:37952 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750950AbZLTRLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 12:11:30 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+xUN0R6pSxqB1D6nEAJeC1jPiQGmkWDUWti1tBq0
	WE8HWCZTG3Jw6N
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/5] viafb: deprecate private ioctls
Date: Sun, 20 Dec 2009 17:16:45 +0000
Message-Id: <1261329409-3518-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: deprecate private ioctls

This patch prints a warning when viafb ioctls are called. Those
should not be used as their exact meaning is sometimes unknown and
they in parts duplicate functionality present in the framebuffer
interface.
There is no known user of these ioctls.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/viafbdev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index d8df17a..ce07b5e 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -477,6 +477,7 @@ static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
 	u32 gpu32;
 
 	DEBUG_MSG(KERN_INFO "viafb_ioctl: 0x%X !!\n", cmd);
+	printk(KERN_WARNING "viafb_ioctl: Please avoid this interface as it is unstable and might change or vanish at any time!\n");
 	memset(&u, 0, sizeof(u));
 
 	switch (cmd) {
-- 
1.6.3.2

