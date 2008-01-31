Return-Path: <linux-kernel-owner+w=401wt.eu-S934805AbYAaXRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934805AbYAaXRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 18:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934296AbYAaXRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 18:17:00 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:59269 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934285AbYAaXQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 18:16:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=LHNHx/IyRL7dFQG8bETA26+Hr94VeeoWbKlpiNbPOr2hOTEzGiYevXDXJvukU0M8/BypnDxZTLPuM7w0E1Wtoi3CQEhPbOEwmZgUvrW9ZOPPZ3a+SAE2VUiUkNq/Ih7ycm6elCPS9OrEGTZ93+Ss2Q20uyI0Ng4K/RytupEzYPo=
From: Mike Frysinger <vapier.adi@gmail.com>
Organization: ADI
To: a.zummo@towertech.it, Andrew Morton <akpm@osdl.org>
Subject: [patch] update rtc documentation wrt irq_set_freq
Date: Thu, 31 Jan 2008 18:16:48 -0500
User-Agent: KMail/1.9.7
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801311816.48831.vapier.adi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I could have sworn I sent this out already, but I don't see it in the latest
git or in mm, so here we go ...
---
This documents the proper use of the irq_set_freq function.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/Documentation/rtc.txt b/Documentation/rtc.txt
index e20b19c..8deffcd 100644
--- a/Documentation/rtc.txt
+++ b/Documentation/rtc.txt
@@ -182,8 +182,8 @@ driver returns ENOIOCTLCMD.  Some common examples:
 	since the frequency is stored in the irq_freq member of the rtc_device
 	structure.  Your driver needs to initialize the irq_freq member during
 	init.  Make sure you check the requested frequency is in range of your
-	hardware in the irq_set_freq function.  If you cannot actually change
-	the frequency, just return -ENOTTY.
+	hardware in the irq_set_freq function.  If it isn't, return -EINVAL.  If
+	you cannot actually change the frequency, do not define irq_set_freq.
 
 If all else fails, check out the rtc-test.c driver!
 
