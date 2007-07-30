Return-Path: <linux-kernel-owner+w=401wt.eu-S939789AbXG3W3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939789AbXG3W3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969366AbXG3W2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:28:38 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:54342 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S969214AbXG3W2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:28:37 -0400
Date: Tue, 31 Jul 2007 00:28:17 +0200
From: Adrian Bunk <bunk@stusta.de>
To: v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] dvb_frontend_ioctl(): fix check-after-use
Message-ID: <20070730222817.GE3972@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted that we have already oops'ed if "fe" was NULL.

Since "fe" being NULL seems impossible at this point this patch removes 
the NULL check.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/drivers/media/dvb/dvb-core/dvb_frontend.c.old	2007-07-29 21:41:56.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/media/dvb/dvb-core/dvb_frontend.c	2007-07-29 21:42:16.000000000 +0200
@@ -706,11 +706,11 @@ static int dvb_frontend_ioctl(struct ino
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int err = -EOPNOTSUPP;
 
 	dprintk ("%s\n", __FUNCTION__);
 
-	if (!fe || fepriv->exit)
+	if (fepriv->exit)
 		return -ENODEV;
 
 	if ((file->f_flags & O_ACCMODE) == O_RDONLY &&
 	    (_IOC_DIR(cmd) != _IOC_READ || cmd == FE_GET_EVENT ||
 	     cmd == FE_DISEQC_RECV_SLAVE_REPLY))

