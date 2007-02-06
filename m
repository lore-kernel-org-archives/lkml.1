Return-Path: <linux-kernel-owner+w=401wt.eu-S933000AbXBFQIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000AbXBFQIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933002AbXBFQIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:08:02 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:59552 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000AbXBFQIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:08:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=c/0X8iuzn1AUPgDqkI44EQS+L+knrwe6WY2qNUvqkBR0Tz7xdyWUR44GFf2mBbExG9JwpsE1gXAn5DB1kbk12mq929PPi3jwX3D3+f1quNZd+CdawimtUodju2WCzCm5qRqwNqcXiW+S8DRvhuXQHrt8yTjmfYUsE+/lA97nyyI=
Date: Tue, 6 Feb 2007 18:07:44 +0200
To: schwidefsky@de.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-390@vm.marist.edu
Subject: [PATCH 2.6.20] s390-drivers: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206160744.GK8991@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206160204.GA8991@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
Not compile tested due to (ofcourse ;)) missing hardware.

diff --git a/drivers/s390/cio/device_id.c b/drivers/s390/cio/device_id.c
index f172759..997f468 100644
--- a/drivers/s390/cio/device_id.c
+++ b/drivers/s390/cio/device_id.c
@@ -11,6 +11,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 
 #include <asm/ccwdev.h>
 #include <asm/delay.h>
@@ -138,7 +139,7 @@ VM_virtual_device_info (__u16 devno, struct senseid *ps)
 		ps->cu_model = 0x60;
 		return;
 	}
-	for (i = 0; i < sizeof(vm_devices) / sizeof(vm_devices[0]); i++)
+	for (i = 0; i < ARRAY_SIZE(vm_devices); i++)
 		if (diag_data.vrdcvcla == vm_devices[i].vrdcvcla &&
 		    diag_data.vrdcvtyp == vm_devices[i].vrdcvtyp) {
 			ps->cu_type = vm_devices[i].cu_type;


-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
