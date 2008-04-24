Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbYDXE2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbYDXE2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 00:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbYDXE2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 00:28:40 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:44655 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYDXE2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 00:28:40 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2008 00:28:40 EDT
Date: Thu, 24 Apr 2008 14:28:39 +1000
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Silence 'defined but not used' warning in drivers/ieee1394/raw1394.c
Message-ID: <20080424042839.GQ20457@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the kernel will issue the following warning:

drivers/ieee1394/raw1394.c:2938: warning: 'raw1394_id_table' defined but not used

Add #ifdef MODULE guards arround the declaration.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
 drivers/ieee1394/raw1394.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/ieee1394/raw1394.c b/drivers/ieee1394/raw1394.c
index 04e96ba..7322fab 100644
--- a/drivers/ieee1394/raw1394.c
+++ b/drivers/ieee1394/raw1394.c
@@ -2931,6 +2931,7 @@ static int raw1394_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+#ifdef MODULE
 /*** HOTPLUG STUFF **********************************************************/
 /*
  * Export information about protocols/devices supported by this driver.
@@ -2956,6 +2957,7 @@ static struct ieee1394_device_id raw1394_id_table[] = {
 };
 
 MODULE_DEVICE_TABLE(ieee1394, raw1394_id_table);
+#endif /* MODULE */
 
 static struct hpsb_protocol_driver raw1394_driver = {
 	.name = "raw1394",
-- 
1.5.5.1


Yours Tony

  linux.conf.au    http://www.marchsouth.org/
  Jan 19 - 24 2009 The Australian Linux Technical Conference!

