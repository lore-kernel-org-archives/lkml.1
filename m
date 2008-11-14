Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbYKNSgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbYKNSgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 13:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYKNSgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 13:36:44 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:51997 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbYKNSgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 13:36:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=cCxMil4+W1Ws8s/7+Q6e81k2sJ86GtpEqIbMOQKmTaIBsDRSXZxHmoj7vGXTK6oo6F
         HypbXp8ILGr75M/GTEtDI9EPdAtz/3b6mmIdfVClhHbWwtdooGgT8mhnxkCeEC00Z4K9
         fFnu+zDQ/nPXO+xj9WuH3azyrcN7RKpvnKDJE=
Subject: [PATCH] dvb: cinergyt2 annotate struct endiannes, remove unused
 variable, add static
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-maintainer <v4l-dvb-maintainer@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 14 Nov 2008 10:34:26 -0800
Message-Id: <1226687666.5483.34.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All noticed by sparse:
drivers/media/dvb/dvb-usb/cinergyT2-core.c:35:5: warning: symbol 'disable_remote' was not declared. Should it be static?
drivers/media/dvb/dvb-usb/cinergyT2-core.c:48:23: warning: symbol 'cinergyt2_usb_device' was not declared. Should it be static?
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:160:15: warning: cast to restricted __le16
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:190:9: warning: cast to restricted __le32
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:208:9: warning: cast to restricted __le32
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:227:24: warning: cast to restricted __le16
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:275:12: warning: incorrect type in assignment (different base types)
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:275:12:    expected unsigned short [unsigned] [assigned] [usertype] tps
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:275:12:    got restricted __le16 [usertype] <noident>
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:276:13: warning: incorrect type in assignment (different base types)
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:276:13:    expected unsigned int [unsigned] [assigned] [usertype] freq
drivers/media/dvb/dvb-usb/cinergyT2-fe.c:276:13:    got restricted __le32 [usertype] <noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/media/dvb/dvb-usb/cinergyT2-core.c |    3 +--
 drivers/media/dvb/dvb-usb/cinergyT2.h      |   10 +++++-----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/cinergyT2-core.c b/drivers/media/dvb/dvb-usb/cinergyT2-core.c
index 3ac9f74..80e37a0 100644
--- a/drivers/media/dvb/dvb-usb/cinergyT2-core.c
+++ b/drivers/media/dvb/dvb-usb/cinergyT2-core.c
@@ -32,7 +32,6 @@
 
 /* debug */
 int dvb_usb_cinergyt2_debug;
-int disable_remote;
 
 module_param_named(debug, dvb_usb_cinergyt2_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info, xfer=2, rc=4 "
@@ -45,7 +44,7 @@ struct cinergyt2_state {
 };
 
 /* We are missing a release hook with usb_device data */
-struct dvb_usb_device *cinergyt2_usb_device;
+static struct dvb_usb_device *cinergyt2_usb_device;
 
 static struct dvb_usb_device_properties cinergyt2_properties;
 
diff --git a/drivers/media/dvb/dvb-usb/cinergyT2.h b/drivers/media/dvb/dvb-usb/cinergyT2.h
index 11d79eb..84efe03 100644
--- a/drivers/media/dvb/dvb-usb/cinergyT2.h
+++ b/drivers/media/dvb/dvb-usb/cinergyT2.h
@@ -70,11 +70,11 @@ struct dvbt_get_status_msg {
 	uint8_t bandwidth;
 	uint16_t tps;
 	uint8_t flags;
-	uint16_t gain;
+	__le16 gain;
 	uint8_t snr;
-	uint32_t viterbi_error_rate;
+	__le32 viterbi_error_rate;
 	uint32_t rs_error_rate;
-	uint32_t uncorrected_block_count;
+	__le32 uncorrected_block_count;
 	uint8_t lock_bits;
 	uint8_t prev_lock_bits;
 } __attribute__((packed));
@@ -82,9 +82,9 @@ struct dvbt_get_status_msg {
 
 struct dvbt_set_parameters_msg {
 	uint8_t cmd;
-	uint32_t freq;
+	__le32 freq;
 	uint8_t bandwidth;
-	uint16_t tps;
+	__le16 tps;
 	uint8_t flags;
 } __attribute__((packed));
 
-- 
1.6.0.4.879.g9d19a



