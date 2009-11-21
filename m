Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbZKUP0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbZKUP0b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756512AbZKUP03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:26:29 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:39190 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbZKUPRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:17:25 -0500
Message-ID: <4B080355.8000300@simon.arlott.org.uk>
Date: Sat, 21 Nov 2009 15:12:21 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090927)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/8] cxacru: document how to interact with the flash memory
References: <4B08013B.90403@simon.arlott.org.uk>
In-Reply-To: <4B08013B.90403@simon.arlott.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These commands were found by accident... fortunately
it still works even if the flash memory is erased,
despite having no USB device IDs.

Some example sysfs code for raw command access:
  http://simon.arlott.org/pub/cxacru/raw.c

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/usb/atm/cxacru.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index f2e7414..41568b1 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -105,6 +105,26 @@ enum cxacru_cm_request {
 	CM_REQUEST_MAX,
 };
 
+/* commands for interaction with the flash memory
+ * 
+ * read:  response is the contents of the first 60 bytes of flash memory
+ * write: request contains the 60 bytes of data to write to flash memory
+ *        response is the contents of the first 60 bytes of flash memory
+ *
+ * layout: PP PP VV VV  MM MM MM MM  MM MM ?? ??  SS SS SS SS  SS SS SS SS
+ *         SS SS SS SS  SS SS SS SS  00 00 00 00  00 00 00 00  00 00 00 00
+ *         00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00
+ *
+ *   P: le16  USB Product ID
+ *   V: le16  USB Vendor ID
+ *   M: be48  MAC Address
+ *   S: le16  ASCII Serial Number
+ */
+enum cxacru_cm_flash {
+	CM_FLASH_READ = 0xa1,
+	CM_FLASH_WRITE = 0xa2
+};
+
 /* reply codes to the commands above */
 enum cxacru_cm_status {
 	CM_STATUS_UNDEFINED,
-- 
1.6.3.3

-- 
Simon Arlott

