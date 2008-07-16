Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYGPS6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYGPS6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 14:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbYGPS5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 14:57:54 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:39556 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbYGPS5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 14:57:53 -0400
Date: Wed, 16 Jul 2008 11:50:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, dwmw2 <dwmw2@infradead.org>
Cc: scsi <linux-scsi@vger.kernel.org>,
       jejb <James.Bottomley@HansenPartnership.com>
Subject: [PATCH -next] scsi: fix advansys printk format warnings
Message-Id: <20080716115057.47b3e117.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings (firmware-related):

linux-next-20080716/drivers/scsi/advansys.c:4788: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
linux-next-20080716/drivers/scsi/advansys.c:5117: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
linux-next-20080716/drivers/scsi/advansys.c:5631: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
linux-next-20080716/drivers/scsi/advansys.c:6131: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/advansys.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20080716.orig/drivers/scsi/advansys.c
+++ linux-next-20080716/drivers/scsi/advansys.c
@@ -4784,7 +4784,7 @@ static ushort AscInitAsc1000Driver(ASC_D
 		return err;
 	}
 	if (fw->size < 4) {
-		printk(KERN_ERR "Bogus length %d in image \"%s\"\n",
+		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
 		       fw->size, fwname);
 		release_firmware(fw);
 		return -EINVAL;
@@ -5113,7 +5113,7 @@ static int AdvInitAsc3550Driver(ADV_DVC_
 		return err;
 	}
 	if (fw->size < 4) {
-		printk(KERN_ERR "Bogus length %d in image \"%s\"\n",
+		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
 		       fw->size, fwname);
 		release_firmware(fw);
 		return -EINVAL;
@@ -5627,7 +5627,7 @@ static int AdvInitAsc38C0800Driver(ADV_D
 		return err;
 	}
 	if (fw->size < 4) {
-		printk(KERN_ERR "Bogus length %d in image \"%s\"\n",
+		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
 		       fw->size, fwname);
 		release_firmware(fw);
 		return -EINVAL;
@@ -6127,7 +6127,7 @@ static int AdvInitAsc38C1600Driver(ADV_D
 		return err;
 	}
 	if (fw->size < 4) {
-		printk(KERN_ERR "Bogus length %d in image \"%s\"\n",
+		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
 		       fw->size, fwname);
 		release_firmware(fw);
 		return -EINVAL;


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
