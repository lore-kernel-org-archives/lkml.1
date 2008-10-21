Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbYJUV2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbYJUV2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYJUV2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:28:00 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:41725 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbYJUV2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:28:00 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 3/4] HID: hidraw, fix lock imbalance
Date: Tue, 21 Oct 2008 23:27:55 +0200
Message-Id: <1224624476-16596-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add omitted unlock_kernel() to hidraw_ioctl().
Added in 979c407e3b89b606e810fa494ef316896eadbfad
(HID: Push down BKL into ioctl handler in hidraw).

Corresponing sparse warning:
drivers/hid/hidraw.c:267:9: warning: context imbalance in 'hidraw_ioctl': wrong count at exit
drivers/hid/hidraw.c:267:9:    context 'kernel_lock': wanted 0, got 1

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/hidraw.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index dffd464..f801755 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -264,6 +264,7 @@ static long hidraw_ioctl(struct file *file, unsigned int cmd,
 		default:
 			ret = -ENOTTY;
 	}
+	unlock_kernel();
 	return ret;
 }
 
-- 
1.6.0.2

