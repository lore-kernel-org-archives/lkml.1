Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYIPXZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYIPXZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 19:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbYIPXZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 19:25:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44845 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYIPXZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 19:25:33 -0400
Subject: [PATCH] Fix autoloading of MacBook Pro backlight driver.
From: David Woodhouse <dwmw2@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>, Julien Blache <jb@jblache.org>,
       Matthew Garrett <mjg@redhat.com>, Richard Purdie <rpurdie@rpsys.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1221607406.20234.82.camel@macbook.infradead.org>
References: <1221607406.20234.82.camel@macbook.infradead.org>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 16:25:22 -0700
Message-Id: <1221607522.20234.84.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new MODULE_DEVICE_TABLE(dmi, ...) facility. There's no need for
every driver to screw it up for themselves, when the alias can be
generated automatically.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 385cba4..06964af 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -111,6 +111,4 @@ module_exit(mbp_exit);
 MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
 MODULE_DESCRIPTION("Nvidia-based Macbook Pro Backlight Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("svnAppleInc.:pnMacBookPro3,1");
-MODULE_ALIAS("svnAppleInc.:pnMacBookPro3,2");
-MODULE_ALIAS("svnAppleInc.:pnMacBookPro4,1");
+MODULE_DEVICE_TABLE(dmi, mbp_device_table);

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

