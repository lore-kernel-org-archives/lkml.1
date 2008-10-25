Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbYJYV0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbYJYV0r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 17:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYJYV0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 17:26:39 -0400
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:39371 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131AbYJYV0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 17:26:39 -0400
Subject: [PATCH] usbtmc: Use explicit unsigned type for input buffer
	instead of char*
From: Chris Malley <mail@chrismalley.co.uk>
To: gregkh <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Sat, 25 Oct 2008 22:07:32 +0100
Message-Id: <1224968852.25054.3.camel@helix.beotel.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
X-Cloudmark-Analysis: v=1.0 c=1 a=yRtVjkoVhBMA:10 a=917E5eeKf20A:10 a=aqaR7bKOnZvmi7SDNv4A:9 a=Go4lZDGTbgwJN386DVF58d3cpWMA:4 a=EVQZQ8nMr7cA:10 a=iYlkOlhu7C0A:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Malley <mail@chrismalley.co.uk>

Silences compiler warning about comparison with 0x80, and type now matches the
corresponding _bulk_out function.

drivers/usb/class/usbtmc.c: In function ‘usbtmc_ioctl_abort_bulk_in’:
drivers/usb/class/usbtmc.c:163: warning: comparison is always false due to limited range of data type

Signed-off-by: Chris Malley <mail@chrismalley.co.uk>
---
 drivers/usb/class/usbtmc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 543811f..8e74657 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -133,7 +133,7 @@ static int usbtmc_release(struct inode *inode, struct file *file)
 
 static int usbtmc_ioctl_abort_bulk_in(struct usbtmc_device_data *data)
 {
-	char *buffer;
+	u8 *buffer;
 	struct device *dev;
 	int rv;
 	int n;
-- 

