Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbYDTUio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbYDTUio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 16:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbYDTUih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 16:38:37 -0400
Received: from ozlabs.org ([203.10.76.45]:59755 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbYDTUig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 16:38:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] usb: libusual kthread_run() called with wrong format.
Date: Mon, 21 Apr 2008 06:38:34 +1000
User-Agent: KMail/1.9.9
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb-devel@lists.sourceforge.net,
       mdharm-usb@one-eyed-alien.net
References: <200804210635.49188.rusty@rustcorp.com.au>
In-Reply-To: <200804210635.49188.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804210638.34304.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/usb/storage/libusual.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -r bf2ff23fda93 drivers/usb/storage/libusual.c
--- a/drivers/usb/storage/libusual.c	Mon Apr 07 17:07:09 2008 +1000
+++ b/drivers/usb/storage/libusual.c	Mon Apr 07 17:30:33 2008 +1000
@@ -134,7 +134,7 @@ static int usu_probe(struct usb_interfac
 	stat[type].fls |= USU_MOD_FL_THREAD;
 	spin_unlock_irqrestore(&usu_lock, flags);
 
-	task = kthread_run(usu_probe_thread, (void*)type, "libusual_%d", type);
+	task = kthread_run(usu_probe_thread, (void*)type, "libusual_%ld", type);
 	if (IS_ERR(task)) {
 		rc = PTR_ERR(task);
 		printk(KERN_WARNING "libusual: "
