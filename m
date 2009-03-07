Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbZCGWLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbZCGWLd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 17:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756593AbZCGWLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 17:11:10 -0500
Received: from mail.pxnet.com ([195.227.45.7]:33294 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756442AbZCGWLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 17:11:08 -0500
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 1/2] gigaset: return -ENOSYS for unimplemented functions
To: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
CC: Paul Bolle <pebolle@tiscali.nl>, Hansjoerg Lipp <hjlipp@web.de>
Message-ID: <20090307-patch-01.tilman@imap.cc>
In-Reply-To: <20090307-patch-00.tilman@imap.cc>
References: <20090307-patch-00.tilman@imap.cc>
Date: Sat,  7 Mar 2009 23:10:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>

A number of functions in the usb_gigaset module will return -EINVAL if
CONFIG_GIGASET_UNDOCREQ is not set. Make these return -ENOSYS as it's
more specific and it might make it easier to see (from userspace) why
these functions actually fail.

Impact: some error return codes changed

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/usb-gigaset.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/gigaset/usb-gigaset.c b/drivers/isdn/gigaset/usb-gigaset.c
index fba61f6..2bd6d9d 100644
--- a/drivers/isdn/gigaset/usb-gigaset.c
+++ b/drivers/isdn/gigaset/usb-gigaset.c
@@ -278,17 +278,17 @@ static int gigaset_set_line_ctrl(struct cardstate *cs, unsigned cflag)
 static int gigaset_set_modem_ctrl(struct cardstate *cs, unsigned old_state,
 				  unsigned new_state)
 {
-	return -EINVAL;
+	return -ENOSYS;
 }
 
 static int gigaset_set_line_ctrl(struct cardstate *cs, unsigned cflag)
 {
-	return -EINVAL;
+	return -ENOSYS;
 }
 
 static int gigaset_baud_rate(struct cardstate *cs, unsigned cflag)
 {
-	return -EINVAL;
+	return -ENOSYS;
 }
 #endif
 
@@ -577,7 +577,7 @@ static int gigaset_brkchars(struct cardstate *cs, const unsigned char buf[6])
 	return usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x19, 0x41,
 			       0, 0, &buf, 6, 2000);
 #else
-	return -EINVAL;
+	return -ENOSYS;
 #endif
 }
 
-- 
1.5.4.7.gd8534-dirty

