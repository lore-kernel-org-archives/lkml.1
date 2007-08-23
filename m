Return-Path: <linux-kernel-owner+w=401wt.eu-S933899AbXHWX51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899AbXHWX51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbXHWX5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:57:19 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:64917 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbXHWX5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:57:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=N5zGsIJsd/UD9LzOIay7lYftO3qP9ehrfG5Av91yOeQ/AHDI1OBSJFTJA4jCdJ8tGWXpQiMXSUZLL6nQViSCvvqwHri228ZThTCNMI3ynw/PzIjzIFyajE5wow2hshUqXTdj08iuHa7yA8o54slEEZHcfEcl4WwIK98oyAb5l8M=
Message-Id: <6d744c4594d042e63fa00469ccbfaeca54639b01.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 01:54:23 +0200
Subject: [PATCH 10/30] irda: Do not do pointless kmalloc return value cast in KingSun driver
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <samuel@sortiz.org>, Alex V Lasso <a_villacis@palosanto.com>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc() returns a void pointer, so there is no need to cast it in
 drivers/net/irda/kingsun-sir.c::kingsun_probe().

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/net/irda/kingsun-sir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/irda/kingsun-sir.c b/drivers/net/irda/kingsun-sir.c
index bdd5c97..4e5101a 100644
--- a/drivers/net/irda/kingsun-sir.c
+++ b/drivers/net/irda/kingsun-sir.c
@@ -509,12 +509,12 @@ static int kingsun_probe(struct usb_interface *intf,
 	spin_lock_init(&kingsun->lock);
 
 	/* Allocate input buffer */
-	kingsun->in_buf = (__u8 *)kmalloc(kingsun->max_rx, GFP_KERNEL);
+	kingsun->in_buf = kmalloc(kingsun->max_rx, GFP_KERNEL);
 	if (!kingsun->in_buf)
 		goto free_mem;
 
 	/* Allocate output buffer */
-	kingsun->out_buf = (__u8 *)kmalloc(KINGSUN_FIFO_SIZE, GFP_KERNEL);
+	kingsun->out_buf = kmalloc(KINGSUN_FIFO_SIZE, GFP_KERNEL);
 	if (!kingsun->out_buf)
 		goto free_mem;
 
-- 
1.5.2.2

