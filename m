Return-Path: <linux-kernel-owner+w=401wt.eu-S1759403AbYAYU1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403AbYAYU1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbYAYU1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:27:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:14030 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbYAYU1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:27:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=bgxE5FnsvSdhntXjBNQ6MMzeXAN6SZExqThqLQeeDN1Ig8fs2+eKrp6mTZVkUz1/v9BJrLg/dHuuJUKrgNl2uOHZVDV1xieJjnA/YuVTCZHgQkKbYPUZqjiVMcOIyou9+hOid/2iOv9EbiM2CN1n83wBmPSojVSHNJsUXmImBKA=
Date: Fri, 25 Jan 2008 23:27:20 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] driver: tcm825x - fix logical typo error
Message-ID: <20080125202720.GD7233@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does fix potential NULL pointer dereference
due to logical typo error.

The issue is pointed out by
Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/drivers/media/video/tcm825x.c
===================================================================
--- linux-2.6.git.orig/drivers/media/video/tcm825x.c	2008-01-23 19:01:47.000000000 +0300
+++ linux-2.6.git/drivers/media/video/tcm825x.c	2008-01-25 23:13:15.000000000 +0300
@@ -851,7 +851,7 @@ static int tcm825x_probe(struct i2c_clie
 	sensor->platform_data = client->dev.platform_data;
 
 	if (sensor->platform_data == NULL
-	    && !sensor->platform_data->is_okay())
+	    || !sensor->platform_data->is_okay())
 		return -ENODEV;
 
 	sensor->v4l2_int_device = &tcm825x_int_device;

-- 

