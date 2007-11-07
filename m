Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbXKGJRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbXKGJRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 04:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbXKGJRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 04:17:10 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:13251 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbXKGJRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 04:17:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gy+vht1Hqtl4uDK6shZuFwabPLHZKhecdR8WuAkZklSejQuEzGa2KVTFhQZMOwenfYB3B1T09tVIs67zjZ2NvegpLjUQ67G+WIfig5EK2V+6mbjB9TWLvJbZB3YHIQQuBHn/BUJXl6VmW97VE6oD9spafK7pZxh0VxLERgkjfSQ=
From: Mike Frysinger <vapier.adi@gmail.com>
Organization: ADI
To: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: [patch] tweak driver documentation for rtc periodic
Date: Wed, 7 Nov 2007 04:17:00 -0500
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711070417.00969.vapier.adi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The max_user_freq member is not really meant for RTC drivers to modify, so
update the rtc documentation so drivers writers know what is expected of them
when handling periodic events.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/Documentation/rtc.txt b/Documentation/rtc.txt
index c931d61..6153790 100644
--- a/Documentation/rtc.txt
+++ b/Documentation/rtc.txt
@@ -180,9 +180,10 @@ driver returns ENOIOCTLCMD.  Some common examples:
     *	RTC_IRQP_SET, RTC_IRQP_READ: the irq_set_freq function will be called
 	to set the frequency while the framework will handle the read for you
 	since the frequency is stored in the irq_freq member of the rtc_device
-	structure.  Also make sure you set the max_user_freq member in your
-	initialization routines so the framework can sanity check the user
-	input for you.
+	structure.  Your driver needs to initialize the irq_freq member during
+	init.  Make sure you check the requested frequency is in range of your
+	hardware in the irq_set_freq function.  If you cannot actually change
+	the frequency, just return -ENOTTY.
 
 If all else fails, check out the rtc-test.c driver!
 
