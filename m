Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbYHHO6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbYHHO6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 10:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYHHO6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 10:58:32 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:23750 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbYHHO6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 10:58:31 -0400
Date: Fri, 8 Aug 2008 16:58:23 +0200
From: Jean Delvare <khali@linux-fr.org>
To: linux-fbdev-devel@lists.sourceforge.net,
       Antonino Daplas <adaplas@gmail.com>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] matrox maven: Fix a broken error path
Message-ID: <20080808165823.71d9bea3@hyperion.delvare>
In-Reply-To: <20080808164937.141a95e0@hyperion.delvare>
References: <20080808164937.141a95e0@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I broke an error path with d03c21ec0be7787ff6b75dcf56c0e96209ccbfbd,
sorry about that.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/video/matrox/matroxfb_maven.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.26-rc6.orig/drivers/video/matrox/matroxfb_maven.c	2008-06-17 17:22:42.000000000 +0200
+++ linux-2.6.26-rc6/drivers/video/matrox/matroxfb_maven.c	2008-06-17 17:23:18.000000000 +0200
@@ -1266,7 +1266,7 @@ static int maven_detect_client(struct i2
 ERROR4:;
 	i2c_detach_client(new_client);
 ERROR3:;
-	kfree(new_client);
+	kfree(data);
 ERROR0:;
 	return err;
 }


-- 
Jean Delvare
