Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043Ab0AIIo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab0AIIo0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 03:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857Ab0AIIoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 03:44:25 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:47107 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab0AIIoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 03:44:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=sFw32pxgz9ymh2mfUpk0ZGDy6Z6rI2hJUVlAvn6E8ibuR1IIBRUfg3k16/aMcHjs2+
         Y+RDQIofgoDwiIGzRAS4jVPD4CMtPqSw7TbnlsuNT5JM5HJU0I+ZPkhwLiwzMrLxrpEU
         LgD+oao5mxjMzgskaFCvUbj8uepKR95KqpmUs=
Date: Sat, 9 Jan 2010 11:44:05 +0300
From: Dan Carpenter <error27@gmail.com>
To: horms@vergenet.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Peter Huewe <PeterHuewe@gmx.de>
Subject: [patch] otus: zfTkipInit(): increment another pointer
Message-ID: <20100109084405.GC7840@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>, horms@vergenet.net,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Peter Huewe <PeterHuewe@gmx.de>
References: <20100108075748.059645106@vergenet.net> <20100108075921.305507492@vergenet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108075921.305507492@vergenet.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This applies on top of Simon Horman's patch set, particularly [patch 5/6].  
Feel free to roll them into one and change the sign-off to yourself.

There was another pointer that needed to be incremented.  Now all six
of the bytes are used.

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/staging/otus/80211core/ctkip.c	2010-01-09 00:46:14.000000000 +0300
+++ devel/drivers/staging/otus/80211core/ctkip.c	2010-01-09 00:48:39.000000000 +0300
@@ -255,7 +255,8 @@ void zfTkipInit(u8_t* key, u8_t* ta, str
     zfMemoryCopy(pSeed->ta, ta, 6);
     zfMemoryCopy(pSeed->tk, key, 16);
 
-    iv16 = *initIv++;
+    iv16 = *initIv;
+    initIv++;
     iv16 += *initIv<<8;
     initIv++;
 
