Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbYG2Byw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbYG2Byw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYG2Bym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:54:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:18014 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYG2Byl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:54:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=pNUN/DpwJ9EAAJsKffCQ6Im6+RDDxnNn8OZyzTO2n5G+VXpz4dnG+C3RnKV6sOy+1G
         +/7pHQvRoyOnxKKt1BobcT4R4BBE0iK9sNTPtxTFFEvx7TvF1YHsj3gHSRKLyH8eQwC6
         S+tz4Jc84a74ZXEFgPiG01drpI3U2o91Q37rw=
Date: Tue, 29 Jul 2008 05:54:31 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-usb@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] usb/core/driver: fix warning
Message-ID: <20080729015431.GA28952@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

usb/core/driver: fix warning:
drivers/usb/core/driver.c:834: warning: 'do_unbind_rebind' defined but not used


Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

---

 drivers/usb/core/driver.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index ddb54e1..6618bc8 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -774,6 +774,7 @@ void usb_deregister(struct usb_driver *driver)
 }
 EXPORT_SYMBOL_GPL(usb_deregister);
 
+#ifdef CONFIG_PM
 
 /* Forced unbinding of a USB interface driver, either because
  * it doesn't support pre_reset/post_reset/reset_resume or
@@ -872,8 +873,6 @@ static void do_unbind_rebind(struct usb_device *udev, int action)
 	}
 }
 
-#ifdef CONFIG_PM
-
 /* Caller has locked udev's pm_mutex */
 static int usb_suspend_device(struct usb_device *udev, pm_message_t msg)
 {
