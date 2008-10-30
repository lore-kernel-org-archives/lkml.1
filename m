Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbYJ3L5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbYJ3L5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbYJ3L5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:57:36 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50485 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbYJ3L5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:57:35 -0400
Date: Thu, 30 Oct 2008 13:56:47 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/10] usbtmc: indent & braces disagree, something else is
 desired
In-Reply-To: <Pine.LNX.4.64.0810301307160.7072@wrl-59.cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0810301349460.7072@wrl-59.cs.helsinki.fi>
References: <Pine.LNX.4.64.0810301307160.7072@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-545473979-1225367807=:7072"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-545473979-1225367807=:7072
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


It seems that there's rather involved way to say something
which is commonly written in a plain simple form.

Some type changes would probably be necessary to get gcc
to do bitops instead of divide but it's no worse after my
change than before I think.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 drivers/usb/class/usbtmc.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 543811f..711a9fa 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -21,6 +21,7 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/uaccess.h>
 #include <linux/kref.h>
@@ -481,7 +482,6 @@ static ssize_t usbtmc_write(struct file *filp, const char __user *buf,
 	int retval;
 	int actual;
 	unsigned long int n_bytes;
-	int n;
 	int remaining;
 	int done;
 	int this_part;
@@ -525,11 +525,8 @@ static ssize_t usbtmc_write(struct file *filp, const char __user *buf,
 			goto exit;
 		}
 
-		n_bytes = 12 + this_part;
-		if (this_part % 4)
-			n_bytes += 4 - this_part % 4;
-			for (n = 12 + this_part; n < n_bytes; n++)
-				buffer[n] = 0;
+		n_bytes = roundup(12 + this_part, 4);
+		memset(buffer + 12 + this_part, 0, n_bytes - (12 + this_part));
 
 		retval = usb_bulk_msg(data->usb_dev,
 				      usb_sndbulkpipe(data->usb_dev,
-- 
1.5.2.2

---696208474-545473979-1225367807=:7072--
