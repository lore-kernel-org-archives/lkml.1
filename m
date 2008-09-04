Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbYIDSlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbYIDSlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbYIDSih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:38:37 -0400
Received: from mail.work.de ([212.12.32.20]:58939 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395AbYIDSig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:38:36 -0400
Message-ID: <48C02B28.30305@gmail.com>
Date: Thu, 04 Sep 2008 22:38:32 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
Subject: DVB Update [PATCH 13/31] multiproto tree
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------040001050100040701060505"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040001050100040701060505
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 8c37315b9966e21894a76b61177727b462992d65 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 13:45:00 +0200
Subject: [PATCH] DVB Fix possible frontend deadlock

The frontend will deadlock if an unspecified delivery system
is specified. Before returning error for the unspecified
delivery system, unlock and then exit.

From: Marco Schluessler <marco@lordzodiac.de>
Signed-off-by: Marco Schluessler <marco@lordzodiac.de>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |    1 +
 1 file changed, 1 insertion(+)

--------------040001050100040701060505
Content-Type: text/x-patch;
 name="13.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="13.patch"

>From 8c37315b9966e21894a76b61177727b462992d65 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 13:45:00 +0200
Subject: [PATCH] DVB Fix possible frontend deadlock

The frontend will deadlock if an unspecified delivery system
is specified. Before returning error for the unspecified
delivery system, unlock and then exit.

From: Marco Schluessler <marco@lordzodiac.de>
Signed-off-by: Marco Schluessler <marco@lordzodiac.de>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 125facb..313c639 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1789,6 +1789,7 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 				fepriv->max_drift = 0;
 				break;
 			default:
+				up(&fepriv->sem);
 				return -EINVAL;
 			}
 		}

--------------040001050100040701060505--
