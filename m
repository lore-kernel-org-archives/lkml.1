Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbYAVROu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbYAVROu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 12:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYAVROn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 12:14:43 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:60990 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbYAVROm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 12:14:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=IPiv7FJi5J9xhSQK7kODvSCV671wSWEW76hqjnP/FGfmvBSlDJaXi33/eIwGUz5dnB/ukv7bjYDMxzqossvS2ZUO2KtPEeT3ceoPJV0+xAQUDByhgBNbAALVYXX8v5FF5LEBk5IXMG7odLOyiRqBaATptBZR/Qgn9uCMXg9S6oM=
Date: Tue, 22 Jan 2008 20:14:23 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: Sakari Ailus <sakari.ailus@nokia.com>, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com
Subject: Re: [MUST-FIX] in today's Linus' git
Message-ID: <20080122171423.GA6724@cvg>
References: <Pine.LNX.4.64.0801221601460.6933@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801221601460.6933@axis700.grange>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Guennadi Liakhovetski - Tue, Jan 22, 2008 at 04:08:15PM +0100]
| Hi
| 
| Could someone, please, fix this:
| 
| drivers/media/video/tcm825x.c:
| 
| 853:	if (sensor->platform_data == NULL
| 854:	    && !sensor->platform_data->is_okay())
| 
| I haven't looked through the entire file, so, cannot guarantee, that this 
| is the only place. Maybe, someone could review this file and the whole 
| commit it came in with properly...
| 
| Thanks
| Guennadi
| ---
| Guennadi Liakhovetski

Hi,

i hope this help ;)

		- Cyrill -

---
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] driver: fix incorrect logical operator

This patch does fix potential NULL pointer dereference
due to incorrect logical operator.

The issue is pointed out by
Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/drivers/media/video/tcm825x.c
===================================================================
--- linux-2.6.git.orig/drivers/media/video/tcm825x.c	2008-01-21 19:35:14.000000000 +0300
+++ linux-2.6.git/drivers/media/video/tcm825x.c	2008-01-22 20:07:21.000000000 +0300
@@ -851,7 +851,7 @@
 	sensor->platform_data = client->dev.platform_data;
 
 	if (sensor->platform_data == NULL
-	    && !sensor->platform_data->is_okay())
+	    || !sensor->platform_data->is_okay())
 		return -ENODEV;
 
 	sensor->v4l2_int_device = &tcm825x_int_device;
