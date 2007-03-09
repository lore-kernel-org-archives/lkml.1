Return-Path: <linux-kernel-owner+w=401wt.eu-S2993042AbXCIHSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993042AbXCIHSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993035AbXCIHSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:18:50 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:35215 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993044AbXCIHSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:18:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Sh9pdoBst93+vI6a2PqHgpI0X6v1ZR02IOyX6TSvn1dntHDzUBs0C32xtdEK50qG1socpENklrTrNvap6bV2HWXt1+ShRwITkZ0VAYK77aYQ1X1EjwMSCF27ABkA3v3uvv5+CxX0KoqM2r8pZa5ea3pBq77kqPCqxn+31mvmZUc=
Date: Thu, 8 Mar 2007 23:18:33 -0800
From: Amit Choudhary <amit2030@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/usb/serial/mos7840.c: check kmalloc() return value.
Message-Id: <20070308231833.69b0611e.amit2030@gmail.com>
Organization: X
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.8.15; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Description: Check the return value of kmalloc() in function mos7840_get_reg(), in file drivers/usb/serial/mos7840.c.

Signed-off-by: Amit Choudhary <amit2030@gmail.com>

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 021be39..91d474b 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -475,6 +475,14 @@ static int mos7840_get_reg(struct moschi
 	int ret = 0;
 	buffer = (__u8 *) mcs->ctrl_buf;
 
+	/* The memory for ctrl_buf is allocated in
+	 * mos7840_startup(), but it is not checked if
+	 * kmalloc failed. So, mcs->ctrl_buf might be NULL.
+	 * So, it should be checked here.
+	 */
+	if (!buffer)
+		return -ENOMEM;
+
 //      dr=(struct usb_ctrlrequest *)(buffer);
 	dr = (void *)(buffer + 2);
 	dr->bRequestType = MCS_RD_RTYPE;
