Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbXICRMC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbXICRMC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 13:12:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbXICRLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 13:11:51 -0400
Received: from mailin.studentenwerk.mhn.de ([141.84.225.229]:41057 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696AbXICRLq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 13:11:46 -0400
X-Greylist: delayed 1379 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Sep 2007 13:11:46 EDT
From: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>
Organization: Studentenwerk =?iso-8859-1?q?M=FCnchen?=
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: bug in 2.6.22.6, net/sunrpc/svcsock.c
Date: Mon, 3 Sep 2007 18:48:45 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709031848.46005.wolfgang.walter@studentenwerk.mhn.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

in 2.6.22.6, net/sunrpc/svcsock.c

random characters are printed by svc_tcp_accept:

	lockd: last TCP connect from <some random chars>

because buf is used unitialized:

printk(KERN_NOTICE
	"%s: last TCP connect from %s\n",
	serv->sv_name, buf);


Probably it should be

printk(KERN_NOTICE
	"%s: last TCP connect from %s\n",
	serv->sv_name, __svc_print_addr(sin, buf, sizeof(buf)));


=============================
--- linux-2.6.22.6/net/sunrpc/svcsock.c	2007-08-27 18:10:14.000000000 +0200
+++ linux-2.6.22.6w/net/sunrpc/svcsock.c	2007-09-03 18:27:30.000000000 +0200
@@ -1090,7 +1090,7 @@
 						   serv->sv_name);
 				printk(KERN_NOTICE
 				       "%s: last TCP connect from %s\n",
-				       serv->sv_name, buf);
+				       serv->sv_name, __svc_print_addr(sin, buf, sizeof(buf)));
 			}
 			/*
 			 * Always select the oldest socket. It's not fair,
===============================

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
