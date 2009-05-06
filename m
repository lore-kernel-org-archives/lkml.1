Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbZEFLgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbZEFLgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbZEFLfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:35:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50901 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198AbZEFLfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:35:50 -0400
Date: Wed, 6 May 2009 13:35:50 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: [PATCH] fix blkid.h include
Message-ID: <20090506113550.GQ15802@pengutronix.de>
References: <20090505214214.GC4460@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090505214214.GC4460@nb.net.home>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 13:34:50 up 77 days,  3:28, 25 users,  load average: 0.14, 0.05,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building util-linux-ng-2.15, I get this:

make[3]: Entering directory `/ptx/work/octopus/WORK_2_B/rsc/svn/oselas/bsp/OSELAS.BSP-Pengutronix-AllYes-trunk/platform-phyCORE-PXA270.PCM990/build-target/util-linux-ng-2.15/mount'
arm-iwmmx-linux-gnueabi-gcc -std=gnu99 -DHAVE_CONFIG_H -I. -I..  -include ../config.h -I../include -DLOCALEDIR=\"/usr/share/locale\" -isystem /home/rsc/svn/oselas/bsp/OSELAS.BSP-Pengutronix-AllYes-trunk/platform-phyCORE-PXA270.PCM990/sysroot-target/include -isystem /home/rsc/svn/oselas/bsp/OSELAS.BSP-Pengutronix-AllYes-trunk/platform-phyCORE-PXA270.PCM990/sysroot-target/usr/include  -fsigned-char  -I/home/rsc/svn/oselas/bsp/OSELAS.BSP-Pengutronix-AllYes-trunk/platform-phyCORE-PXA270.PCM990/sysroot-target/usr/include    -g -O2 -MT mount-fsprobe.o -MD -MP -MF .deps/mount-fsprobe.Tpo -c -o mount-fsprobe.o `test -f '../lib/fsprobe.c' || echo './'`../lib/fsprobe.c
../lib/fsprobe.c:10:19: error: blkid.h: No such file or directory

The reason is that blkid.h comes from e2fsutils, which install the header file
into /usr/include/blkid/blkid.h; /usr/include is also what the .pc file
specifies for the include path for the CFLAGS. So IMHO the patch below must be
applied to make it work.

If this is not acceptable, a little bit more configure magic would be necessary.

Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>

---
 lib/fsprobe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: util-linux-ng-2.15/lib/fsprobe.c
===================================================================
--- util-linux-ng-2.15.orig/lib/fsprobe.c
+++ util-linux-ng-2.15/lib/fsprobe.c
@@ -7,7 +7,7 @@
 #include <sys/types.h>
 #include <stdlib.h>
 
-#include <blkid.h>
+#include <blkid/blkid.h>
 
 #include "blkdev.h"
 #include "canonicalize.h"

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
