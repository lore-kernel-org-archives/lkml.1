Return-Path: <linux-kernel-owner+w=401wt.eu-S932395AbYJMKDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbYJMKDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757950AbYJMJp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:45:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51043 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759254AbYJMJpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:45:25 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 75/80] applicom: Fix an unchecked user ioctl range and an
	error return
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:45:17 +0100
Message-ID: <20081013094512.21645.96843.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Closes bug #11408 by checking the card index range for command 0
Fixes the ioctl to return ENOTTY which is correct for unknown ioctls

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/applicom.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)


diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 31d08b6..b899d91 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -712,8 +712,7 @@ static int ac_ioctl(struct inode *inode, struct file *file, unsigned int cmd, un
 	
 	IndexCard = adgl->num_card-1;
 	 
-	if(cmd != 0 && cmd != 6 &&
-	   ((IndexCard >= MAX_BOARD) || !apbs[IndexCard].RamIO)) {
+	if(cmd != 6 && ((IndexCard >= MAX_BOARD) || !apbs[IndexCard].RamIO)) {
 		static int warncount = 10;
 		if (warncount) {
 			printk( KERN_WARNING "APPLICOM driver IOCTL, bad board number %d\n",(int)IndexCard+1);
@@ -832,8 +831,7 @@ static int ac_ioctl(struct inode *inode, struct file *file, unsigned int cmd, un
 		}
 		break;
 	default:
-		printk(KERN_INFO "APPLICOM driver ioctl, unknown function code %d\n",cmd) ;
-		ret = -EINVAL;
+		ret = -ENOTTY;
 		break;
 	}
 	Dummy = readb(apbs[IndexCard].RamIO + VERS);

