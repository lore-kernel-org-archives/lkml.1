Return-Path: <linux-kernel-owner+w=401wt.eu-S932453AbXJPSTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbXJPSTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934789AbXJPST2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:19:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934665AbXJPST0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:19:26 -0400
Date: Tue, 16 Oct 2007 14:19:11 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Antonino Daplas <adaplas@gmail.com>
Subject: reduce frequency of cursor blinking
Message-ID: <20071016181911.GA24428@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Antonino Daplas <adaplas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on CONFIG_HZ, we blink the cursor at 20,50,60 or 200Hz.
Even if it only blinks once per 1000Hz, there's no visible difference.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 73813c6..7d9bae5 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -433,7 +433,7 @@ static void cursor_timer_handler(unsigned long dev_addr)
 	struct fbcon_ops *ops = info->fbcon_par;
 
 	schedule_work(&info->queue);
-	mod_timer(&ops->cursor_timer, jiffies + HZ/5);
+	mod_timer(&ops->cursor_timer, jiffies + HZ);
 }
 
 static void fbcon_add_cursor_timer(struct fb_info *info)

-- 
http://www.codemonkey.org.uk
