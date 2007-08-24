Return-Path: <linux-kernel-owner+w=401wt.eu-S934377AbXHXAig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934377AbXHXAig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964848AbXHXAiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:38:08 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:5874 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827AbXHXAiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:38:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=dyfd9UvgDs7OMKmjGlJ6EIScS06z3LQNS1gwHZPLniv3atEonPBrtQfztUCSyBwpa6wDiCfBBWUkytN49QDcjlv0FgDXITVF93iut0zzLQ+d4qYQsxTos4W+dS/HcAVjgxtZ4i1fE3nKzpR9BFr8dQZpVVvWcZsP2dEvN6R0OE4=
Message-Id: <e71841eb1d00e260fea44d94a4c8a0f950debcfd.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 02:35:14 +0200
Subject: [PATCH 27/30] usb: avoid redundant cast of kmalloc() return value in OTi-6858 driver
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/usb/serial/oti6858.c::pl2303_buf_alloc() the return value
of kmalloc() is being cast to "struct pl2303_buf *", but that need
not be done here since kmalloc() returns "void *".

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/usb/serial/oti6858.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index d7db71e..fc5e808 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -1161,7 +1161,7 @@ static struct pl2303_buf *pl2303_buf_alloc(unsigned int size)
 	if (size == 0)
 		return NULL;
 
-	pb = (struct pl2303_buf *)kmalloc(sizeof(struct pl2303_buf), GFP_KERNEL);
+	pb = kmalloc(sizeof(struct pl2303_buf), GFP_KERNEL);
 	if (pb == NULL)
 		return NULL;
 
-- 
1.5.2.2

