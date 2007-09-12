Return-Path: <linux-kernel-owner+w=401wt.eu-S967734AbXILQ7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967734AbXILQ7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 12:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933902AbXILQ7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 12:59:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:13493 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731AbXILQ7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 12:59:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=QVykY8dYCXT1hSjSuSmO3BL4dbLbylJUFA05JVHNsTT1pfvv4hWIAzbsTSah5s4+EzAHhKz5mVI8WYznzINBhlSJiJqUUhMEI6llKMyvZ03N/Dm8X4eGJNwnfvHalgz+FXG/4twTidxCUj7HhigHDi/EGGCuUA/wmAdj3ID0cj4=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Thomas Dahlmann <thomas.dahlmann@amd.com>
Subject: [PATCH] AMD 5536 UDC - Remove unneeded memset()
Date: Wed, 12 Sep 2007 18:56:05 +0200
User-Agent: KMail/1.9.7
Cc: info-linux@geode.amd.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709121856.05742.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In drivers/usb/gadget/amd5536udc.c::udc_pci_probe() - 
We allocate storage for 'dev' with kzalloc(), so it is already zero, 
no need for an extra memset().


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/usb/gadget/amd5536udc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 714156c..e95ffc9 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -3244,7 +3244,6 @@ static int udc_pci_probe(
 		retval = -ENOMEM;
 		goto finished;
 	}
-	memset(dev, 0, sizeof(struct udc));
 
 	/* pci setup */
 	if (pci_enable_device(pdev) < 0) {

