Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab0CFLKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 06:10:12 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:60974 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab0CFLKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 06:10:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=wVQX9aISiiQPSugA6qPpsqnFZNPtUVV2QCfSQp49FuNb7hTju38hhK+PQAtudFjNH5
         /gzOUuhjIkUn/+hLtrF0FyD0ipXjgyqdYrrnzWqJHSUq4lYezQaOXJ0inc6E4DMuAbBs
         hiV2Q5dsU+c/60Ve34UGBt+gDyLqm+6Z7rwGA=
Date: Sat, 6 Mar 2010 14:09:44 +0300
From: Dan Carpenter <error27@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Scott Moreau <oreaus@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] joystick: off by one error
Message-ID: <20100306110944.GG4958@bicker>
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

This fixes a smatch warning:
drivers/input/joystick/gamecon.c +838 gc_setup_pad(23) error: buffer overflow 'gc_names' 10 <= 10

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
