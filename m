Return-Path: <linux-kernel-owner+w=401wt.eu-S1751187AbXCFUCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbXCFUCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbXCFUCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:02:43 -0500
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:26656 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751187AbXCFUCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:02:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=a/Gjh+3UiGAu7d8YwC68mj/N8Ky1wttPPHKX2dYsPBBO92a+BCtnfKSYtYZ8v7Kwkwn6F8vPd1g2xOc0Lxv6lWINuLeeJv3qg1jxZ3LHIh7Lxog9ESoB5bWMWjKonFMuL46zura27ajJdIDFbZ/7dOdJS+FsM1WG7bEQ9cK07vk=  ;
X-YMail-OSG: BhglM34VM1nUTt0d65V9hm3aXj_rPuhSqMm3jeVRmwkn9arnVby79DG3coaO9fNXgOkioon2DRQaNlZ3HrNRMOgdhw0cslra1GCdbD68EOCobyu_I_YWG6PHU2aPX2Dnl7XWTUTQvN17R3Vka2oGHy8paQ--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.21-rc2-git] reduce rtc syslog spam
Date: Tue, 6 Mar 2007 11:35:23 -0800
User-Agent: KMail/1.7.1
Cc: rtc-linux@googlegroups.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703061135.24429.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the RTC core less noisy.  On fault paths this message is confusing;
and on success, a message from the driver itself should be much more
informative (displaying chip type, options, etc).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
It would be nice if this cleanup went into 2.6.21, to reduce that
confusion.  Previous patches cleaned up the per-interface debug
messages, but neglected this one.

Index: linux-2.6/drivers/rtc/class.c
===================================================================
--- linux-2.6.orig/drivers/rtc/class.c	2007-03-01 17:12:41.000000000 -0800
+++ linux-2.6/drivers/rtc/class.c	2007-03-06 04:06:54.000000000 -0800
@@ -85,7 +85,7 @@ struct rtc_device *rtc_device_register(c
 	if (err)
 		goto exit_kfree;
 
-	dev_info(dev, "rtc core: registered %s as %s\n",
+	dev_dbg(dev, "rtc core: registered %s as %s\n",
 			rtc->name, rtc->class_dev.class_id);
 
 	return rtc;
