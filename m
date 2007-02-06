Return-Path: <linux-kernel-owner+w=401wt.eu-S965394AbXBFUFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965394AbXBFUFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965396AbXBFUFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:05:49 -0500
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:3161 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965394AbXBFUFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:05:48 -0500
Date: Tue, 6 Feb 2007 21:05:57 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH]Fix warning in device_add_attrs
Message-Id: <20070206210557.2948f56d.khali@linux-fr.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning which I see with gcc 3.2:
drivers/base/core.c: In function `device_add_attrs':
drivers/base/core.c:251: warning: `i' might be used uninitialized in this function
It's a false positive, but it can be worked around easily, and the new
code makes rather more sense.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/base/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.20.orig/drivers/base/core.c	2007-02-06 09:25:49.000000000 +0100
+++ linux-2.6.20/drivers/base/core.c	2007-02-06 20:40:46.000000000 +0100
@@ -259,10 +259,10 @@ static int device_add_attrs(struct devic
 			if (error)
 				break;
 		}
+		if (error)
+			while (--i >= 0)
+				device_remove_file(dev, &class->dev_attrs[i]);
 	}
-	if (error)
-		while (--i >= 0)
-			device_remove_file(dev, &class->dev_attrs[i]);
 	return error;
 }
 


-- 
Jean Delvare
