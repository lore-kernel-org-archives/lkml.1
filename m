Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab0CCHGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:06:00 -0500
Received: from mail-bw0-f212.google.com ([209.85.218.212]:40618 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab0CCHF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:05:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=xK/PFzp29pU3QBwuXtOozgcz5xV9HlqvgbYuZYWbpdJdwZUDdx5kVR+DlM/L1eesJi
         hXXUgUMP9vZvQvAXfMsYcDbPHL4cKlkCGPTogWXyeNuaXznQ1TzGONklXJ5F6+9vbuAL
         jGzhbEOt/rkJ9CuGOPX7l1W3r3E1WHX9wjpZ4=
Date: Wed, 3 Mar 2010 10:05:44 +0300
From: Dan Carpenter <error27@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Scott Moreau <oreaus@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] gamecon: fix off by one range check
Message-ID: <20100303070544.GB5086@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Scott Moreau <oreaus@gmail.com>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be >= GC_MAX not > GC_MAX.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/input/joystick/gamecon.c b/drivers/input/joystick/gamecon.c
index ae998d9..7a55714 100644
--- a/drivers/input/joystick/gamecon.c
+++ b/drivers/input/joystick/gamecon.c
@@ -819,7 +819,7 @@ static int __init gc_setup_pad(struct gc *gc, int idx, int pad_type)
 	int i;
 	int err;
 
-	if (pad_type < 1 || pad_type > GC_MAX) {
+	if (pad_type < 1 || pad_type >= GC_MAX) {
 		pr_err("Pad type %d unknown\n", pad_type);
 		return -EINVAL;
 	}
