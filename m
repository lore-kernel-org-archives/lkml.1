Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbZFSVY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbZFSVY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 17:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbZFSVYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 17:24:15 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:50835 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZFSVYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 17:24:14 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] HID: hiddev, fix lock imbalance
Date: Fri, 19 Jun 2009 23:24:11 +0200
Message-Id: <1245446651-1652-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add omitted BKL to one switch/case.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/usbhid/hiddev.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 9e94215..215b2ad 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -527,8 +527,10 @@ static noinline int hiddev_ioctl_usage(struct hiddev *hiddev, unsigned int cmd,
 			goto goodreturn;
 
 		case HIDIOCGCOLLECTIONINDEX:
+			i = field->usage[uref->usage_index].collection_index;
+			unlock_kernel();
 			kfree(uref_multi);
-			return field->usage[uref->usage_index].collection_index;
+			return i;
 		case HIDIOCGUSAGES:
 			for (i = 0; i < uref_multi->num_values; i++)
 				uref_multi->values[i] =
-- 
1.6.3.2

