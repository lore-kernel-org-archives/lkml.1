Return-Path: <linux-kernel-owner+w=401wt.eu-S933741AbXHPWVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741AbXHPWVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 18:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932686AbXHPWVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 18:21:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:3497 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764285AbXHPWVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 18:21:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=sggwkEJp+Xsn4NJHCP/rM8waM4CHflgKu0VBopqNbg8xFC46iJXmCxs7oQznQ5Fxjm/dARADZYGEPDeQxVf4jUD+Vp1jeiJICdP5VFh3yThKOv2vWPx0cXvPSlckYVBZ8aQ6GEaDC5YAf/RqpJK/XtXgOiCwaOul1UqRUN1nELo=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] Moxa: Fix warning: 'CheckIsMoxaMust' defined but not used
Date: Fri, 17 Aug 2007 00:17:56 +0200
User-Agent: KMail/1.9.7
Cc: support@moxa.com.tw, Alan Cox <alan@redhat.com>,
       linux-kernel@vger.kernel.org, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708170017.56815.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This should have been part of the previous Moxa patch I just sent, but I 
forgot to include it, so here it is as a seperate patch. Sorry about that.


This fixes the warning : 
  drivers/char/mxser.c:427: warning: 'CheckIsMoxaMust' defined but not used
when building Moxa driver without CONFIG_PCI.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 mxser.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6/drivers/char/mxser.c~	2007-08-17 00:11:23.000000000 +0200
+++ linux-2.6/drivers/char/mxser.c	2007-08-17 00:11:23.000000000 +0200
@@ -424,7 +424,7 @@
 static void mxser_startrx(struct tty_struct *tty);
 static void mxser_stoprx(struct tty_struct *tty);
 
-
+#ifdef CONFIG_PCI
 static int CheckIsMoxaMust(int io)
 {
 	u8 oldmcr, hwid;
@@ -447,6 +447,7 @@
 	}
 	return MOXA_OTHER_UART;
 }
+#endif
 
 /* above is modified by Victor Yu. 08-15-2002 */
 


