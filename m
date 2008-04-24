Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273AbYDXHDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbYDXHDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 03:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYDXHDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 03:03:14 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58219 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYDXHDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 03:03:13 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 24 Apr 2008 09:02:04 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] ieee1394: silence defined but not used warning in
 non-modular builds
To: Tony Breeds <tony@bakeyournoodle.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel@lists.sourceforge.net
In-Reply-To: <20080424042839.GQ20457@bakeyournoodle.com>
Message-ID: <tkrat.417b268d913e3389@s5r6.in-berlin.de>
References: <20080424042839.GQ20457@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Breeds <tony@bakeyournoodle.com>

Currently the kernel will issue the following warning:
drivers/ieee1394/raw1394.c:2938: warning: 'raw1394_id_table' defined but not used
Add #ifdef MODULE guards arround the declaration.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

Ditto with dv1394_id_table and video1394_id_table.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/dv1394.c    |    2 ++
 drivers/ieee1394/raw1394.c   |    2 ++
 drivers/ieee1394/video1394.c |    2 ++
 3 files changed, 6 insertions(+)

Index: linux/drivers/ieee1394/dv1394.c
===================================================================
--- linux.orig/drivers/ieee1394/dv1394.c
+++ linux/drivers/ieee1394/dv1394.c
@@ -2167,6 +2167,7 @@ static const struct file_operations dv13
 /*
  * Export information about protocols/devices supported by this driver.
  */
+#ifdef MODULE
 static struct ieee1394_device_id dv1394_id_table[] = {
 	{
 		.match_flags	= IEEE1394_MATCH_SPECIFIER_ID | IEEE1394_MATCH_VERSION,
@@ -2177,6 +2178,7 @@ static struct ieee1394_device_id dv1394_
 };
 
 MODULE_DEVICE_TABLE(ieee1394, dv1394_id_table);
+#endif /* MODULE */
 
 static struct hpsb_protocol_driver dv1394_driver = {
 	.name = "dv1394",
Index: linux/drivers/ieee1394/raw1394.c
===================================================================
--- linux.orig/drivers/ieee1394/raw1394.c
+++ linux/drivers/ieee1394/raw1394.c
@@ -2940,6 +2940,7 @@ static int raw1394_release(struct inode 
 /*
  * Export information about protocols/devices supported by this driver.
  */
+#ifdef MODULE
 static struct ieee1394_device_id raw1394_id_table[] = {
 	{
 	 .match_flags = IEEE1394_MATCH_SPECIFIER_ID | IEEE1394_MATCH_VERSION,
@@ -2961,6 +2962,7 @@ static struct ieee1394_device_id raw1394
 };
 
 MODULE_DEVICE_TABLE(ieee1394, raw1394_id_table);
+#endif /* MODULE */
 
 static struct hpsb_protocol_driver raw1394_driver = {
 	.name = "raw1394",
Index: linux/drivers/ieee1394/video1394.c
===================================================================
--- linux.orig/drivers/ieee1394/video1394.c
+++ linux/drivers/ieee1394/video1394.c
@@ -1293,6 +1293,7 @@ static const struct file_operations vide
 /*
  * Export information about protocols/devices supported by this driver.
  */
+#ifdef MODULE
 static struct ieee1394_device_id video1394_id_table[] = {
 	{
 		.match_flags	= IEEE1394_MATCH_SPECIFIER_ID | IEEE1394_MATCH_VERSION,
@@ -1313,6 +1314,7 @@ static struct ieee1394_device_id video13
 };
 
 MODULE_DEVICE_TABLE(ieee1394, video1394_id_table);
+#endif /* MODULE */
 
 static struct hpsb_protocol_driver video1394_driver = {
 	.name = VIDEO1394_DRIVER_NAME,

-- 
Stefan Richter
-=====-==--- -=-- ==---
http://arcgraph.de/sr/

