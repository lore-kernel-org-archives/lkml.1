Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbYIDSts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbYIDSts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbYIDSnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:43:12 -0400
Received: from mail.work.de ([212.12.32.20]:42290 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756568AbYIDSnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:43:11 -0400
Message-ID: <48C02C3A.4090003@gmail.com>
Date: Thu, 04 Sep 2008 22:43:06 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
CC: anssi.hannula@gmail.com
Subject: DVB Update [PATCH 31/31] multiproto tree
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------010705040302000004060404"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010705040302000004060404
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 76f0d0929582d49a0c4a0aa4aefe4e5dea0c1267 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 15:01:36 +0200
Subject: [PATCH] DVB fix broken translation for ATSC in olddrv_to_newapi

In olddrv_to_newapi(), the ATSC modulation conversion used
newmod_to_oldmod() instead of the correct oldmod_to_newmod().
Fix it.

From: Anssi Hannula <anssi.hannula@gmail.com>
Signed-off-by: Anssi Hannula <anssi.hannula@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--------------010705040302000004060404
Content-Type: text/x-patch;
 name="31.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="31.patch"

>From 76f0d0929582d49a0c4a0aa4aefe4e5dea0c1267 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 15:01:36 +0200
Subject: [PATCH] DVB fix broken translation for ATSC in olddrv_to_newapi

In olddrv_to_newapi(), the ATSC modulation conversion used
newmod_to_oldmod() instead of the correct oldmod_to_newmod().
Fix it.

From: Anssi Hannula <anssi.hannula@gmail.com>
Signed-off-by: Anssi Hannula <anssi.hannula@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index a8005ef..fcafcfc 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -557,7 +557,7 @@ int olddrv_to_newapi(struct dvb_frontend *fe,
 		}
 		break;
 	case FE_ATSC:
-		newmod_to_oldmod(atsc->modulation, &vsb->modulation);
+		oldmod_to_newmod(vsb->modulation, &atsc->modulation);
 		break;
 	default:
 		dprintk("%s: Unsupported delivery system %x\n", __func__, fe_type);

--------------010705040302000004060404--
