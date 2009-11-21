Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbZKUSsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbZKUSsJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 13:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbZKUSsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 13:48:08 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:45914 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747AbZKUSsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 13:48:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Llh+aOZemJtmFE9naBp/qj8hU35UHb4UA99lHPZLjQ/G9i3TJIGyh8M6U0DDvA32y2
         MiFKmqFZ6DCvr30f1qiFDwGmbyHS40A2uZD/AflJN6I8JiiJ3jvIPgiNwndMiomJtUQN
         QDjH5wtLidfHnnjsAtPP1vyYJ5j6z9OiaBzuQ=
Message-ID: <4B0838F1.4090202@gmail.com>
Date: Sat, 21 Nov 2009 20:01:05 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Joseph Chan <JosephChan@via.com.tw>, Scott Fang <ScottFang@viatech.com.cn>,
       linux-fbdev-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] viafb: Use sizeof struct rather than pointer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sizeof the struct should be used rather than of the pointer

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/video/via/viafbdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Unless I am mistaken?

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 56ec696..6cf4cb8 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -680,7 +680,7 @@ static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
 		if (!viafb_gamma_table)
 			return -ENOMEM;
 		if (copy_from_user(viafb_gamma_table, argp,
-				sizeof(viafb_gamma_table))) {
+				sizeof(*viafb_gamma_table))) {
 			kfree(viafb_gamma_table);
 			return -EFAULT;
 		}
