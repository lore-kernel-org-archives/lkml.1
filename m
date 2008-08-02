Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbYHBUBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbYHBUBg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 16:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbYHBUB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 16:01:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:51482 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbYHBUB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 16:01:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=kgX09zVL00sUKnpHTAiz842qT+O7hKwDGd/oVnIlL9pZtZLCaETGtG6QBVgTyvGFLq
         X9zq0cLdtZZOvKc2EiLYonB12fP7A/21cfOA443hqE8Eww/hCTvqCYqugAptFOkpvAz8
         tM42DPyjzY3DINUoneTpTn5eN8EkWJ0bUx7gA=
From: Oliver Pinter <oliver.pntr@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>, stable@kernel.org
Subject: [RFC, 2.6.26.2-rc1] HID: fix memory leak in hidraw_release
Date: Sat, 2 Aug 2008 22:13:07 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Juan Marcos Diez Esteban <juan_m_diez@yahoo.es>,
       Oliver Pinter <oliver.pntr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808022213.07303.oliver.pntr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4db1c62c9991e62b441672db7f227e722776adc4 Mon Sep 17 00:00:00 2001
From: Jiri Kosina <jkosina@suse.cz>
Date: Tue, 24 Jun 2008 14:45:27 +0200
Subject: [PATCH] HID: fix memory leak in hidraw_release

[ Upstream commit 4db1c62c9991e62b441672db7f227e722776adc4 ]

hidraw_release() forgot to free the linked list structure, causing memory
leak.

Reported-by: Juan Marcos Diez Esteban <juan_m_diez@yahoo.es>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 0c6b4d4..8ecd775 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -211,6 +211,8 @@ static int hidraw_release(struct inode * inode, struct file * file)
 			kfree(list->hidraw);
 	}
 
+	kfree(list);
+
 	return 0;
 }
 
