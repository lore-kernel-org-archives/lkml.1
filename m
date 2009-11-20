Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbZKTTFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbZKTTFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbZKTTFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:05:38 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37491 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZKTTFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:05:37 -0500
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 14:05:37 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=fQlB9xvWPcZ1KhJOpcNza9wsIqUo1xkUkO8W9K8y+OjcUmpNT5ma9p5NbRYw92lj2O
         rxQ7+veEJeahKAeqllnVHPQdSIIz5PjZfChMq5t7b+ln5pZeM3+9Rtxt95EAne3Gy2KJ
         hvAjZzQYYLydgGqOus8s0F7KfbZ/oVFgjjDiY=
Message-ID: <4B06EA21.1010405@gmail.com>
Date: Fri, 20 Nov 2009 20:12:33 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, bzolnier@gmail.com
Subject: [PATCH] r8192U_core: test for negative error in rtl8192_rx_isr()?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error tested for is negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/staging/rtl8192su/r8192U_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Is this maybe required?

diff --git a/drivers/staging/rtl8192su/r8192U_core.c b/drivers/staging/rtl8192su/r8192U_core.c
index 66274d7..b492ff5 100644
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -1501,7 +1501,7 @@ static void rtl8192_rx_isr(struct urb *urb)
         urb->context = skb;
         skb_queue_tail(&priv->rx_queue, skb);
         err = usb_submit_urb(urb, GFP_ATOMIC);
-	if(err && err != EPERM)
+	if(err && err != -EPERM)
 		printk("can not submit rxurb, err is %x,URB status is %x\n",err,urb->status);
 }
 
