Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbXFCOvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbXFCOvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbXFCOoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:44:37 -0400
Received: from web50111.mail.re2.yahoo.com ([206.190.39.137]:31251 "HELO
	web50111.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758162AbXFCOog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:44:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=EAG0dljytPZE+XG/IwmxJoibDAl7Xxg1sZDMYrFZqeQgujJK9O+caRI7TIu9XII7qflyKLj+PvumeNZ4qM8+/7upYoqwmCT9wVqtFJzcVPKOGtMVqAL38jtvq41FOKTzsYlW18ALrf/dXUwKPYoA6N7Yes2/9IZPxANhYituemU=;
X-YMail-OSG: xDBqBN0VM1lrs.ARFHeVA0_RaUYgfV2uU0qIhweQtTMt6A0rsU0gOWNM2KVSEo84herIeg--
Date: Sun, 3 Jun 2007 07:44:35 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 34/36] drivers edac mod edac_device output strings
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <557553.87568.qm@web50111.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

The error handling output strings needed to be refactored for better
displaying of the error informaton.

Also needed to added offset_value for output as well

Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>
---

 edac_device.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc3-mm1/drivers/edac/edac_device.c
===================================================================
--- linux-2.6.22-rc3-mm1.orig/drivers/edac/edac_device.c
+++ linux-2.6.22-rc3-mm1/drivers/edac/edac_device.c
@@ -158,7 +158,7 @@ struct edac_device_ctl_info *edac_device
 			attrib_p = &dev_attrib[block * nr_attribs];
 			blk->attribs = attrib_p;
 			snprintf(blk->name, sizeof(blk->name),
-				 "%s%d", edac_block_name, block + 1);
+				 "%s%d", edac_block_name, block+offset_value);
 			blk->name[sizeof(blk->name) - 1] = '\0';
 
 			debugf1("%s() instance=%d block=%d name=%s\n",
@@ -580,7 +580,7 @@ void edac_device_handle_ce(struct edac_d
 
 	if (edac_device_get_log_ce(edac_dev))
 		edac_device_printk(edac_dev, KERN_WARNING,
-				   "CE ctl: %s, instance: %s, block: %s: %s\n",
+				   "CE: %s instance: %s block: %s '%s'\n",
 				   edac_dev->ctl_name, instance->name,
 				   block ? block->name : "N/A", msg);
 }
@@ -626,12 +626,12 @@ void edac_device_handle_ue(struct edac_d
 
 	if (edac_device_get_log_ue(edac_dev))
 		edac_device_printk(edac_dev, KERN_EMERG,
-				   "UE ctl: %s, instance: %s, block: %s: %s\n",
+				   "UE: %s instance: %s block: %s '%s'\n",
 				   edac_dev->ctl_name, instance->name,
 				   block ? block->name : "N/A", msg);
 
 	if (edac_device_get_panic_on_ue(edac_dev))
-		panic("EDAC %s: UE instance: %s, block %s: %s\n",
+		panic("EDAC %s: UE instance: %s block %s '%s'\n",
 		      edac_dev->ctl_name, instance->name,
 		      block ? block->name : "N/A", msg);
 }

