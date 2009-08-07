Return-Path: <linux-kernel-owner+w=401wt.eu-S1757690AbZHGMLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbZHGMLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 08:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757638AbZHGML3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 08:11:29 -0400
Received: from mail-yw0-f177.google.com ([209.85.211.177]:45153 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbZHGML2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 08:11:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=nXaP3rRXe5zYH7OBCIcgxH/Iwtdt9RoSUq69+rLoZDfQqC+a6GCj/K/LMugJHaxx3U
         X7Cv+eTQLv7dJRgkHz6hm7GLCcigKVYJXfLtIfaPE1QyGNKwDnv3aQcJIKgDxQ42W3Nn
         XVd+Tco9i/eO46Bzire8bPntpmQwg6nZuybV4=
Date: Fri, 7 Aug 2009 14:11:20 +0200 (SAST)
From: Dan Carpenter <error27@gmail.com>
X-X-Sender: dcarpenter@bicker
To: isdn@linux-pingi.de
cc: linux-kernel@vger.kernel.org
Subject: [patch] mISDN: fix reversed if in st_own_ctrl()
Message-ID: <alpine.DEB.2.00.0907171336470.12306@bicker>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code probably returns -EINVAL a lot.  Otherwise it would oops.

Compile tested only.  Found by smatch (http://repo.or.cz/w/smatch.git).

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/isdn/mISDN/stack.c	2009-07-17 13:34:57.000000000 +0300
+++ new/drivers/isdn/mISDN/stack.c	2009-07-17 13:35:32.000000000 +0300
@@ -364,7 +364,7 @@
 static int
 st_own_ctrl(struct mISDNchannel *ch, u_int cmd, void *arg)
 {
-	if (!ch->st || ch->st->layer1)
+	if (!ch->st || !ch->st->layer1)
 		return -EINVAL;
 	return ch->st->layer1->ctrl(ch->st->layer1, cmd, arg);
 }
