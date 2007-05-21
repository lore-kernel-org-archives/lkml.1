Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbXEUCg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbXEUCg5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 22:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbXEUCgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 22:36:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:27492 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbXEUCgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 22:36:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Rin2x7paIgtnAEn5SPDGhdYSoSNolWTeQ4Pk2J0bncUlUaiWDDu230/sr+G8b3X8iMDOMIgB7fsI8WB86eMZ6eljseHkax0H4jk+J5TIkF+zPv7npIYQ0Yfbf72Z+frkME5R63k6w0t/iJBJWd8Ydr2Zwf9hJcL9CF0fMxO+aw8=
Message-ID: <6defe8840705201936s7c011750w5bd4613b33eb9c70@mail.gmail.com>
Date: Sun, 20 May 2007 22:36:48 -0400
From: "Denver Gingerich" <denver@ossguy.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix compiler warning in dd.c
In-Reply-To: <6defe8840705091829h44b78dc2w44f07c0993469128@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6defe8840705091829h44b78dc2w44f07c0993469128@mail.gmail.com>
X-Google-Sender-Auth: efa7f016bb8b0050
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch had been suggested by Indan Zupancic on May 13 but is not
in 2.6.22-rc2 so I'm re-sending it.  Prior to Indan's e-mail, I had
sent the same patch to the kernel janitors list.  I don't care whether
you credit the patch to me or Indan.

Denver


---------- Forwarded message ----------
From: Denver Gingerich <denver@ossguy.com>
Date: May 9, 2007 9:29 PM
Subject: [PATCH] fix compiler warning in dd.c
To: kernel-janitors@lists.linux-foundation.org


Correct the following compiler warning:
warning: 'device_probe_drivers' defined but not used

Verified that there are no device_probe_drivers() calls in the kernel tree.

Signed-off-by: Denver Gingerich <denver@ossguy.com>

---

--- linux-2.6.21/drivers/base/dd.c.000  2007-05-09 18:56:24.000000000 -0400
+++ linux-2.6.21/drivers/base/dd.c      2007-05-09 20:38:12.000000000 -0400
@@ -207,19 +207,6 @@ static int __device_attach(struct device
        return driver_probe_device(drv, dev);
 }

-static int device_probe_drivers(void *data)
-{
-       struct device *dev = data;
-       int ret = 0;
-
-       if (dev->bus) {
-               down(&dev->sem);
-               ret = bus_for_each_drv(dev->bus, NULL, dev, __device_attach);
-               up(&dev->sem);
-       }
-       return ret;
-}
-
 /**
  *     device_attach - try to attach device to a driver.
  *     @dev:   device.
