Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab0CIGP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 01:15:56 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41442 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0CIGPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 01:15:52 -0500
From: Eli Lindsey <eli@siliconsprawl.com>
To: gregkh@suse.de, d@teklibre.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Eli Lindsey <eli@siliconsprawl.com>
Subject: [PATCH 3/4] staging: frontier: switch to strict_strtoul in tranzport.c
Date: Tue,  9 Mar 2010 00:15:32 -0600
Message-Id: <1268115333-7971-3-git-send-email-eli@siliconsprawl.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268115333-7971-2-git-send-email-eli@siliconsprawl.com>
References: <1268115333-7971-1-git-send-email-eli@siliconsprawl.com>
 <1268115333-7971-2-git-send-email-eli@siliconsprawl.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to tranzport.c that changes a use of simple_strtoul to
strict_strtoul at the suggestion of checkpatch.pl

Signed-off-by: Eli Lindsey <eli@siliconsprawl.com>
---
 drivers/staging/frontier/tranzport.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index 1f91001..f9ab4f3 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -198,7 +198,9 @@ static void usb_tranzport_abort_transfers(struct usb_tranzport *dev)
   {									\
     struct usb_interface *intf = to_usb_interface(dev);			\
     struct usb_tranzport *t = usb_get_intfdata(intf);			\
-    int temp = simple_strtoul(buf, NULL, 10);				\
+    unsigned long temp;							\
+    if (strict_strtoul(buf, 10, &temp))					\
+	return -EINVAL;							\
     t->value = temp;							\
     return count;							\
   }									\
-- 
1.6.3.3

