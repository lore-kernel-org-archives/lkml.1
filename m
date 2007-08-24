Return-Path: <linux-kernel-owner+w=401wt.eu-S934164AbXHXAbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934164AbXHXAbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764697AbXHXAbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:31:35 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:3324 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762981AbXHXAbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:31:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=oQL/ebXL3rBxpyIas3uR/nxeyxoaF8nSoSoE9f59kDIe1QWT9zOvjaHZK+kL6HVsOMqwSepxoYPBj8gS5RM29ZhbYvPxroQcCzg+FTZzbb2PFgotdoOoqF1E978QZWjFT4QFdqOhILHB16v0lGfbXh29R1t/bqYkt15Ev2ACtYU=
Message-Id: <4d63101a9182b9ffd3bd662d8193873f83436883.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 02:28:42 +0200
Subject: [PATCH 25/30] tty: dont needlessly cast kmalloc() return value
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc() hands us a void pointer, we don't need to cast it.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/char/tty_io.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 51ea93c..9c867cf 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2063,8 +2063,7 @@ static int init_dev(struct tty_driver *driver, int idx,
 	}
 
 	if (!*tp_loc) {
-		tp = (struct ktermios *) kmalloc(sizeof(struct ktermios),
-						GFP_KERNEL);
+		tp = kmalloc(sizeof(struct ktermios), GFP_KERNEL);
 		if (!tp)
 			goto free_mem_out;
 		*tp = driver->init_termios;
@@ -2094,8 +2093,7 @@ static int init_dev(struct tty_driver *driver, int idx,
 		}
 
 		if (!*o_tp_loc) {
-			o_tp = (struct ktermios *)
-				kmalloc(sizeof(struct ktermios), GFP_KERNEL);
+			o_tp = kmalloc(sizeof(struct ktermios), GFP_KERNEL);
 			if (!o_tp)
 				goto free_mem_out;
 			*o_tp = driver->other->init_termios;
-- 
1.5.2.2

