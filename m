Return-Path: <linux-kernel-owner+w=401wt.eu-S1758184AbZEVVFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbZEVVFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757428AbZEVVEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 17:04:46 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:42035 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbZEVVEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 17:04:45 -0400
Message-Id: <bb4f2bad6654b2dd9f9e7c4a983c0c784654ac3e.1243024967.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
References: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
Subject: [mISDN PATCH v2 02/19] DSP now uses ring buffer for echo canceler
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Fri, 22 May 2009 23:04:45 +0200
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

