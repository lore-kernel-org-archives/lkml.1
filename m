Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbYE3RjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbYE3RjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 13:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYE3RjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 13:39:08 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:50850 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbYE3RjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 13:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YA68uRc9CHzKfvoCayX2HaKbICXD3A6DD/6M4G/37riP7k9euiuBsj9UxCBuJkrtrvVDh0GofKcWUTr9iqWQ4xA6xx1nu6T05pW7C+HulRwI+8T2U7Z7cPKOsQEwXjIGiU9O+YnLOB+B5U9ZhbKBTZRrXKt0GuC+cHVLQuHjMyg=
Subject: [PATCH] usb: speedtch.c fix sparse shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 30 May 2008 10:39:04 -0700
Message-Id: <1212169144.28403.200.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i is used only as a for-loop index no need to declare another.
drivers/usb/atm/speedtch.c:832:7: warning: symbol 'i' shadows an earlier one
drivers/usb/atm/speedtch.c:766:6: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/usb/atm/speedtch.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/atm/speedtch.c b/drivers/usb/atm/speedtch.c
index 7d27c9c..76fce44 100644
--- a/drivers/usb/atm/speedtch.c
+++ b/drivers/usb/atm/speedtch.c
@@ -829,7 +829,6 @@ static int speedtch_bind(struct usbatm_data *usbatm,
 	if (use_isoc) {
 		const struct usb_host_interface *desc = data_intf->cur_altsetting;
 		const __u8 target_address = USB_DIR_IN | usbatm->driver->isoc_in;
-		int i;
 
 		use_isoc = 0; /* fall back to bulk if endpoint not found */
 
-- 
1.5.6.rc0.277.g804cf



