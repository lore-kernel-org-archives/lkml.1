Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbYJ3MKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbYJ3MKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 08:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbYJ3MKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 08:10:35 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38149 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbYJ3MKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 08:10:35 -0400
Date: Thu, 30 Oct 2008 14:10:33 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] usbtmc: Fix type conflict
Message-ID: <Pine.LNX.4.64.0810301409480.7072@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-1347708008-1225368633=:7072"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-1347708008-1225368633=:7072
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


While making the other change, I noticed this:

  CC      drivers/usb/class/usbtmc.o
drivers/usb/class/usbtmc.c: In function 'usbtmc_ioctl_abort_bulk_in':
drivers/usb/class/usbtmc.c:164: warning: comparison is always false due to
limited range of data type

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 drivers/usb/class/usbtmc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 711a9fa..9f7fefd 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -134,7 +134,7 @@ static int usbtmc_release(struct inode *inode, struct file *file)
 
 static int usbtmc_ioctl_abort_bulk_in(struct usbtmc_device_data *data)
 {
-	char *buffer;
+	u8 *buffer;
 	struct device *dev;
 	int rv;
 	int n;
-- 
1.5.2.2

---696208474-1347708008-1225368633=:7072--
