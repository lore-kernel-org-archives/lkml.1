Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbZESPyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbZESPyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 11:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZESPyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 11:54:06 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:51527 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbZESPyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 11:54:05 -0400
Message-Id: <1632b1a819cda8ef1bd56bbe89b46dc5cf280698.1242739648.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
Subject: [PATCH 05/19] DSP now uses ring buffer for echo canceler
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Tue, 19 May 2009 15:58:26 +0200
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Eversberg <andreas@eversberg.eu>

DSP now uses ring buffer for echo canceler.
Added missing include in l1oip_codec.c

Signed-off-by: Andreas Eversberg <andreas@eversberg.eu>
Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/mISDN/dsp.h         |    3 ++-
 drivers/isdn/mISDN/l1oip_codec.c |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp.h b/drivers/isdn/mISDN/dsp.h
index 98a33c5..0a4a362 100644
--- a/drivers/isdn/mISDN/dsp.h
+++ b/drivers/isdn/mISDN/dsp.h
@@ -112,7 +112,8 @@ struct dsp_conf {
 
 #define DSP_DTMF_NPOINTS 102
 
-#define ECHOCAN_BUFLEN (4*128)
+#define ECHOCAN_BUFF_SIZE 0x400 /* must be 2**n */
+#define ECHOCAN_BUFF_MASK 0x3ff /* -1 */
 
 struct dsp_dtmf {
 	int		treshold; /* above this is dtmf (square of) */
diff --git a/drivers/isdn/mISDN/l1oip_codec.c b/drivers/isdn/mISDN/l1oip_codec.c
index e4ecba3..bbfd1b8 100644
--- a/drivers/isdn/mISDN/l1oip_codec.c
+++ b/drivers/isdn/mISDN/l1oip_codec.c
@@ -48,6 +48,7 @@ NOTE: The bytes are handled as they are law-encoded.
 
 #include <linux/vmalloc.h>
 #include <linux/mISDNif.h>
+#include <linux/in.h>
 #include "core.h"
 #include "l1oip.h"
 
-- 
1.6.0.2

