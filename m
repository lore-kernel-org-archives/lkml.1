Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZCKUtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZCKUtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbZCKUrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:47:52 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:51010 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbZCKUru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:47:50 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Henning Zabel <henning@uni-paderborn.de>
Subject: [PATCH 2/5] USB: image/mdc800, fix lock imbalance
Date: Wed, 11 Mar 2009 21:47:37 +0100
Message-Id: <1236804460-1432-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1236804460-1432-1-git-send-email-jirislaby@gmail.com>
References: <1236804460-1432-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an omitted unlock in mdc800_usb_probe's fail path. Add it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Henning Zabel <henning@uni-paderborn.de>
---
 drivers/usb/image/mdc800.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/image/mdc800.c b/drivers/usb/image/mdc800.c
index efc075c..eca355d 100644
--- a/drivers/usb/image/mdc800.c
+++ b/drivers/usb/image/mdc800.c
@@ -499,6 +499,7 @@ static int mdc800_usb_probe (struct usb_interface *intf,
 	retval = usb_register_dev(intf, &mdc800_class);
 	if (retval) {
 		dev_err(&intf->dev, "Not able to get a minor for this device.\n");
+		mutex_unlock(&mdc800->io_lock);
 		return -ENODEV;
 	}
 
-- 
1.6.2
caught by stanse

