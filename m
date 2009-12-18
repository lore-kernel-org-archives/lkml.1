Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbZLRTgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbZLRTgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbZLRTgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:36:32 -0500
Received: from kroah.org ([198.145.64.141]:47426 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbZLRTg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:36:26 -0500
Subject: patch staging-rtl8192su-fix-test-for-negative-error-in-rtl8192_rx_isr.patch added to gregkh-2.6 tree
To: roel.kluin@gmail.com, akpm@linux-foundation.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Fri, 18 Dec 2009 11:33:51 -0800
In-Reply-To: <4B06EA21.1010405@gmail.com>
Message-ID: <12611648311917@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: rtl8192su: fix test for negative error in rtl8192_rx_isr()

to my gregkh-2.6 tree.  Its filename is

    staging-rtl8192su-fix-test-for-negative-error-in-rtl8192_rx_isr.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From roel.kluin@gmail.com  Fri Dec 18 10:10:01 2009
From: Roel Kluin <roel.kluin@gmail.com>
Date: Fri, 20 Nov 2009 20:12:33 +0100
Subject: Staging: rtl8192su: fix test for negative error in rtl8192_rx_isr()
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, bzolnier@gmail.com
Message-ID: <4B06EA21.1010405@gmail.com>


The error tested for is negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rtl8192su/r8192U_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -1501,7 +1501,7 @@ static void rtl8192_rx_isr(struct urb *u
         urb->context = skb;
         skb_queue_tail(&priv->rx_queue, skb);
         err = usb_submit_urb(urb, GFP_ATOMIC);
-	if(err && err != EPERM)
+	if(err && err != -EPERM)
 		printk("can not submit rxurb, err is %x,URB status is %x\n",err,urb->status);
 }
 

