Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbYHGRe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbYHGRe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYHGReQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:34:16 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:28750 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbYHGReP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:34:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=GSvlBId1mYyt0df+SegJ6XAaJa89eIgUKIbhfKoUMMUkNZNpzcjer5EMqyBTV0TkP6
         UJ9bpURSgU6Zuh3N+aMZPKd4PbB5zRhxAd+GkFIAIw+Wpx9tIGwy1zsQeCpqs3VW7U6w
         CFZJKSUzL4P4DCfr5bC9F9H3/EswW2XuaNGK8=
Message-ID: <82e4877d0808071034o3ec31f75k95308ed585563b2e@mail.gmail.com>
Date: Thu, 7 Aug 2008 13:34:14 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: justinmattock@gmail.com
Subject: [PATCH] isight_firmware : Fix a leak and double kfree()
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

--- linux-2.6/drivers/usb/misc/isight_firmware.c	2008-07-29
23:26:24.000000000 -0400
+++ linux-2.6-wk/drivers/usb/misc/isight_firmware.c	2008-08-07
13:23:01.000000000 -0400
@@ -48,7 +48,8 @@

 	if (request_firmware(&firmware, "isight.fw", &dev->dev) != 0) {
 		printk(KERN_ERR "Unable to load isight firmware\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
 	}

 	ptr = firmware->data;
@@ -91,7 +92,6 @@
 			     buf, llen, 300) != llen) {
 				printk(KERN_ERR
 				       "Failed to load isight firmware\n");
-				kfree(buf);
 				ret = -ENODEV;
 				goto out;
 			}
