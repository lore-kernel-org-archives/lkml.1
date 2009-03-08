Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbZCHPXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbZCHPXk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 11:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbZCHPX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 11:23:28 -0400
Received: from mail.pxnet.com ([195.227.45.7]:50084 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbZCHPX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 11:23:27 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 1/2 v2] gigaset: return -ENOTTY for unimplemented functions
To: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
CC: Paul Bolle <pebolle@tiscali.nl>, Hansjoerg Lipp <hjlipp@web.de>
Message-ID: <20090308-patch-01.tilman@imap.cc>
In-Reply-To: <20090307-patch-01.tilman@imap.cc>
References: <20090307-patch-01.tilman@imap.cc>
Date: Sun,  8 Mar 2009 16:23:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>

A number of functions in the usb_gigaset module will return -EINVAL if
CONFIG_GIGASET_UNDOCREQ is not set. Make these return -ENOTTY as it's
more specific and it might make it easier to see (from userspace) why
these functions actually fail.

Impact: some error return codes changed

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/usb-gigaset.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/gigaset/usb-gigaset.c b/drivers/isdn/gigaset/usb-gigaset.c
index fba61f6..d783851 100644
--- a/drivers/isdn/gigaset/usb-gigaset.c
+++ b/drivers/isdn/gigaset/usb-gigaset.c
@@ -278,17 +278,17 @@ static int gigaset_set_line_ctrl(struct cardstate *cs, unsigned cflag)
 static int gigaset_set_modem_ctrl(struct cardstate *cs, unsigned old_state,
 				  unsigned new_state)
 {
-	return -EINVAL;
+	return -ENOTTY;
 }
 
 static int gigaset_set_line_ctrl(struct cardstate *cs, unsigned cflag)
 {
-	return -EINVAL;
+	return -ENOTTY;
 }
 
 static int gigaset_baud_rate(struct cardstate *cs, unsigned cflag)
 {
-	return -EINVAL;
+	return -ENOTTY;
 }
 #endif
 
@@ -577,7 +577,7 @@ static int gigaset_brkchars(struct cardstate *cs, const unsigned char buf[6])
 	return usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x19, 0x41,
 			       0, 0, &buf, 6, 2000);
 #else
-	return -EINVAL;
+	return -ENOTTY;
 #endif
 }
 
-- 
1.5.4.7.gd8534-dirty

