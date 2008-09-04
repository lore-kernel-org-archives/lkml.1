Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbYIDU0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbYIDU0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbYIDUYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:24:35 -0400
Received: from mail.work.de ([212.12.32.20]:34097 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757310AbYIDUYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:24:33 -0400
Message-ID: <48C043FD.2080401@gmail.com>
Date: Fri, 05 Sep 2008 00:24:29 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
Subject: DVB Update [PATCH 9/31] fix a possible lockup
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------050903090003020409040708"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050903090003020409040708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From e7e5de8bd62c8bcff20570f1ee8b28fde02f8b88 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 12:34:05 +0200
Subject: [PATCH] DVB: Fix a possible lockup situation

* If algorithm is not defined, we should not simply exit but
the semaphore should be down and then only exit the frontend thread.

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |    1 +
 1 file changed, 1 insertion(+)


--------------050903090003020409040708
Content-Type: text/x-patch;
 name="9.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="9.patch"

>From e7e5de8bd62c8bcff20570f1ee8b28fde02f8b88 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 12:34:05 +0200
Subject: [PATCH] DVB: Fix a possible lockup situation

* If algorithm is not defined, we should not simply exit but
the semaphore should be down and then only exit the frontend thread.

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index c830997..ac224db 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1230,6 +1230,7 @@ restart:
 				}
 				break;
 			default:
+				down(&fepriv->sem);
 				dprintk("%s: UNDEFINED ALGO !\n", __func__);
 				break;
 			}


--------------050903090003020409040708--
