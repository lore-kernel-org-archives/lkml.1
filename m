Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbZE2Hym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbZE2Hym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 03:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbZE2Hyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 03:54:35 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:51873 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbZE2Hye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 03:54:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=uqHnbVvAHW+H7W2KNFOaXA84hu296wzr7nWKVm0qcM6f9gD5V2MlFyoTcQSDj2KkAj
         plLQVne15su6smvwL925EL+nuH2ESZGNrjAJw9OSecOCrnaNuTlwKGqo/9wN4I09FUGJ
         76qPJ+acX0uA0MuGvspw2KLPbkfV2s8ilIvww=
MIME-Version: 1.0
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Fri, 29 May 2009 13:24:16 +0530
Message-ID: <430c80e90905290054n7416802cq7128394db5de036d@mail.gmail.com>
Subject: [TRIVIAL][PATCH 1/1] Fix warning in staging/otus/ioctl.c
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This patch fixes the following warning

drivers/staging/otus/ioctl.c: In function `usbdrv_wpa_ioctl':
drivers/staging/otus/ioctl.c:2269: warning: ISO C90 forbids mixed
declarations and code
drivers/staging/otus/ioctl.c: In function `usbdrv_ioctl':
drivers/staging/otus/ioctl.c:2448: warning: ISO C90 forbids mixed
declarations and code

Thanks,
-- 
Pranith.

Signed-off-by: D Pranith Kumar <bobby.prani@gmail.com>

diff --git a/drivers/staging/otus/ioctl.c b/drivers/staging/otus/ioctl.c
index ce04218..26bd999 100644
--- a/drivers/staging/otus/ioctl.c
+++ b/drivers/staging/otus/ioctl.c
@@ -2045,6 +2045,7 @@ int usbdrv_wpa_ioctl(struct net_device *dev,
struct athr_wlan_param *zdparm)
        struct zsKeyInfo keyInfo;
        struct usbdrv_private *macp = dev->ml_priv;
        u16_t vapId = 0;
+    int ii;

        /* zmw_get_wlan_dev(dev); */

@@ -2168,7 +2169,6 @@ int usbdrv_wpa_ioctl(struct net_device *dev,
struct athr_wlan_param *zdparm)
                /* DUMP key context */
                /* #ifdef WPA_DEBUG */
                if (keyInfo.keyLength > 0) {
-                       int ii;
                        printk(KERN_WARNING
                                                "Otus: Key Context:\n");
                        for (ii = 0; ii < keyInfo.keyLength; ) {
@@ -2266,7 +2266,6 @@ int usbdrv_wpa_ioctl(struct net_device *dev,
struct athr_wlan_param *zdparm)
                /* zfiWlanSetWpaIe(dev, zdparm->u.generic_elem.data,
                * zdparm->u.generic_elem.len);
                */
-               int ii;
                u8_t len = zdparm->u.generic_elem.len;
                u8_t *wpaie = (u8_t *)zdparm->u.generic_elem.data;

@@ -2401,7 +2400,7 @@ int usbdrv_ioctl(struct net_device *dev, struct
ifreq *ifr, int cmd)
        struct athr_wlan_param zdparm;
        struct usbdrv_private *macp = dev->ml_priv;

-       int err = 0;
+       int err = 0, val = 0;
        int changed = 0;

        /* regp = macp->regp; */
@@ -2445,7 +2444,7 @@ int usbdrv_ioctl(struct net_device *dev, struct
ifreq *ifr, int cmd)
                        err = -EPERM;
                        break;
                }
-               int val = *((int *) wrq->u.name);
+               val = *((int *) wrq->u.name);
                if ((val < 0) || (val > 2)) {
                        err = -EINVAL;
                        break;
