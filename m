Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440Ab0ALAuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab0ALAuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189Ab0ALAuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:50:12 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:47812 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab0ALAuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:50:11 -0500
Date: Tue, 12 Jan 2010 11:50:09 +1100
From: Simon Horman <horms@verge.net.au>
To: Dan Carpenter <error27@gmail.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Huewe <PeterHuewe@gmx.de>
Subject: Re: [patch] tch 5/6 v2] otus: zfTkipInit(): increment another
 pointer
Message-ID: <20100112005006.GC20676@verge.net.au>
References: <20100108075748.059645106@vergenet.net>
 <20100108075921.305507492@vergenet.net>
 <20100109084405.GC7840@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100109084405.GC7840@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increment the pointer rather than its value.
These appear to be logic errors.

Thanks to Dan Carpenter for the first hunk of this change.

Cc: Dan Carpenter <error27@gmail.com>
Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/drivers/staging/otus/80211core/ctkip.c
===================================================================
--- linux-2.6.orig/drivers/staging/otus/80211core/ctkip.c	2010-01-12 11:45:55.000000000 +1100
+++ linux-2.6/drivers/staging/otus/80211core/ctkip.c	2010-01-12 11:46:28.000000000 +1100
@@ -255,7 +255,8 @@ void zfTkipInit(u8_t* key, u8_t* ta, str
     zfMemoryCopy(pSeed->ta, ta, 6);
     zfMemoryCopy(pSeed->tk, key, 16);
 
-    iv16 = *initIv++;
+    iv16 = *initIv;
+    initIv++;
     iv16 += *initIv<<8;
     initIv++;
 
@@ -264,7 +265,7 @@ void zfTkipInit(u8_t* key, u8_t* ta, str
     for(i=0; i<4; i++)      // initiv is little endian
     {
         iv32 += *initIv<<(i*8);
-        *initIv++;
+        initIv++;
     }
 
     pSeed->iv32 = iv32+1; // Force Recalculating on Tkip Phase1
