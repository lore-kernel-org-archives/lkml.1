Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191Ab0AHIBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab0AHIBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 03:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015Ab0AHIBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 03:01:38 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:54991 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab0AHIBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 03:01:35 -0500
Message-Id: <20100108075921.305507492@vergenet.net>
User-Agent: quilt/0.48-1
Date: Fri, 08 Jan 2010 18:57:53 +1100
From: horms@vergenet.net
Subject: [patch 5/6] otus: zfTkipInit(): increment pointer
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Peter Huewe <PeterHuewe@gmx.de>
References: <20100108075748.059645106@vergenet.net>
Content-Disposition: inline; filename=otus-unused-value.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increment the pointer rather than its value.
This appears to be a logic error.

$ gcc (Debian 4.4.2-8) 4.4.2
Copyright (C) 2009 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ make
...
drivers/staging/otus/80211core/ctkip.c: In function 'zfTkipInit':
drivers/staging/otus/80211core/ctkip.c:267: warning: value computed is not
used
...

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/drivers/staging/otus/80211core/ctkip.c
===================================================================
--- linux-2.6.orig/drivers/staging/otus/80211core/ctkip.c	2010-01-08 17:08:37.000000000 +1100
+++ linux-2.6/drivers/staging/otus/80211core/ctkip.c	2010-01-08 17:09:40.000000000 +1100
@@ -264,7 +264,7 @@ void zfTkipInit(u8_t* key, u8_t* ta, str
     for(i=0; i<4; i++)      // initiv is little endian
     {
         iv32 += *initIv<<(i*8);
-        *initIv++;
+        initIv++;
     }
 
     pSeed->iv32 = iv32+1; // Force Recalculating on Tkip Phase1

