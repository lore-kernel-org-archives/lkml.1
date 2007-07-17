Return-Path: <linux-kernel-owner+w=401wt.eu-S1765356AbXGQWyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765356AbXGQWyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 18:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbXGQWyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 18:54:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:55570 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136AbXGQWyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 18:54:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org
Subject: fbdev: make fb_append_extra_logo() depend on fb=y
Date: Wed, 18 Jul 2007 00:52:03 +0200
User-Agent: KMail/1.9.6
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       James Simmons <jsimmons@infradead.org>, Al Viro <viro@ftp.linux.org.uk>
References: <20070716135550.010775000@pademelon.sonytel.be> <20070716135950.895120000@pademelon.sonytel.be>
In-Reply-To: <20070716135950.895120000@pademelon.sonytel.be>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707180052.04659.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+GfIzUqqGuj36BZWOZQGkgGn9SydVgbVGgzn/
 zkE4FKb4oc5I79nM31a8nwmu05oEcZJ/qGCj6VruzxlZn85kuV
 6AWk3wrzfM1gFUEnOMqww==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We can't show the extra logo from boot code if FB is built as
a module. Make the FB_LOGO_EXTRA depend on FB=y.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---

Reported by Al Viro. I don't know how this ended up in the final
patch, as I'm pretty sure we talked about this scenario before
and had a solution...

diff --git a/drivers/video/logo/Kconfig b/drivers/video/logo/Kconfig
index da219c0..9de1c11 100644
--- a/drivers/video/logo/Kconfig
+++ b/drivers/video/logo/Kconfig
@@ -12,7 +12,7 @@ if LOGO
 
 config FB_LOGO_EXTRA
 	bool
-	depends on FB
+	depends on FB=y
 	default y if SPU_BASE
 
 config LOGO_LINUX_MONO
