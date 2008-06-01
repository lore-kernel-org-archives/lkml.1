Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbYFAXao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbYFAXao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYFAX1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:27:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:24300 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbYFAX1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=BLAoKB2n0lUOUyn3igrUmyHOHn3dxgWd4ZpdaeCmMDUukXGexx/B5Vvjz7DDaweDTL8/C+Hi2Eg8YnfvSYE6gXbL5DOUPMyRiAuWRkU8vQPg3zk0qGqIia3q+Ampisg08F6njr+dEEglvZUhUJtheiJFDE3Lys2DAgdhMNjZY+U=
Message-Id: <20080601231530.988658978@gmail.com>
References: <20080601231329.223608711@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 08:13:38 +0900
From: akinobu.mita@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <greg@kroah.com>
Subject: [patch -v2 09/23] usbmon: use simple_read_from_buffer
Content-Disposition: inline; filename=mon-use-simple-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
---
 drivers/usb/mon/mon_stat.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

Index: 2.6-git/drivers/usb/mon/mon_stat.c
===================================================================
--- 2.6-git.orig/drivers/usb/mon/mon_stat.c
+++ 2.6-git/drivers/usb/mon/mon_stat.c
@@ -9,6 +9,7 @@
 
 #include <linux/kernel.h>
 #include <linux/usb.h>
+#include <linux/fs.h>
 #include <asm/uaccess.h>
 
 #include "usb_mon.h"
@@ -42,19 +43,8 @@ static ssize_t mon_stat_read(struct file
 				size_t nbytes, loff_t *ppos)
 {
 	struct snap *sp = file->private_data;
-	loff_t pos = *ppos;
-	int cnt;
 
-	if (pos < 0 || pos >= sp->slen)
-		return 0;
-	if (nbytes == 0)
-		return 0;
-	if ((cnt = sp->slen - pos) > nbytes)
-		cnt = nbytes;
-	if (copy_to_user(buf, sp->str + pos, cnt))
-		return -EFAULT;
-	*ppos = pos + cnt;
-	return cnt;
+	return simple_read_from_buffer(buf, nbytes, ppos, sp->str, sp->slen);
 }
 
 static int mon_stat_release(struct inode *inode, struct file *file)

-- 
