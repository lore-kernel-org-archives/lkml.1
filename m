Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbXDLX4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbXDLX4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbXDLX4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:56:31 -0400
Received: from mail.screens.ru ([213.234.233.54]:57274 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbXDLX4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:56:30 -0400
Date: Fri, 13 Apr 2007 03:56:31 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Duncan Sands <baldrick@free.fr>, linux-kernel@vger.kernel.org
Subject: [PATCH] usbatm_heavy_init: don't use CLONE_SIGHAND
Message-ID: <20070412235631.GA1050@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

usbatm_do_heavy_init() calls allow_signal() which plays with parent process's
->sighand.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 2.6.21-rc5/drivers/usb/atm/usbatm.c~usbatm	2006-11-27 21:19:30.000000000 +0300
+++ 2.6.21-rc5/drivers/usb/atm/usbatm.c	2007-04-13 03:34:56.000000000 +0400
@@ -1019,7 +1019,7 @@ static int usbatm_do_heavy_init(void *ar
 
 static int usbatm_heavy_init(struct usbatm_data *instance)
 {
-	int ret = kernel_thread(usbatm_do_heavy_init, instance, CLONE_KERNEL);
+	int ret = kernel_thread(usbatm_do_heavy_init, instance, CLONE_FS | CLONE_FILES);
 
 	if (ret < 0) {
 		usb_err(instance, "%s: failed to create kernel_thread (%d)!\n", __func__, ret);

