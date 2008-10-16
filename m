Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbYJPTqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbYJPTqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbYJPTqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:46:04 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:31099 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754611AbYJPTqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:46:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=yYl/qYIy3BzhkfJe7Jq6OxYhTI2+GwhnMLQrBMH6pY4ZVXSpFHcmf+TJuqU0Cezf3J+Utc/uyb5v47dVNz/sEVKR1UvCdVDqagV8VreeTuVm0Y29Fjy0+rD0aJKYYpJaQUJzKf69ouABd/zsdX7VFR+kY6CAFbr+vGQThChluG0=  ;
X-YMail-OSG: iFgbEfUVM1mscm7pkfxXqI2YvBEB3eSlvBDLG0IXmTdOZ2t2g5xGXYnQtIxTqRs_nsIcDSp2zmnp4gAUyXsthy.LGnVACACyoJsdlqTRIA1ZY2DI4SU9b2LYCquPi5rgDt7eISlGPBpGopnF3vaCr_5t
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Fwd: [PATCH] Modify sysfs gpio export so that "value" displays as 0 or 1
Date: Thu, 16 Oct 2008 12:45:59 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810161245.59491.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----------  Forwarded Message  ----------

Subject: [PATCH] Modify sysfs gpio export so that "value" displays as 0 or 1
Date: Friday 10 October 2008
From: "Steven A. Falco" <sfalco@harris.com>
To: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>, david-b@pacbell.net

gpiolib can export GPIOs to userspace via sysfs.  This patch modifies
the gpio_value_show() so that any non-zero value is explicitly printed
as "1", rather than whatever numerical value the lower-level driver returns.

Signed-off-by: Steve Falco <sfalco@harris.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 8d29405..36bf72b 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -237,7 +237,7 @@ static ssize_t gpio_value_show(struct device *dev,
 	if (!test_bit(FLAG_EXPORT, &desc->flags))
 		status = -EIO;
 	else
-		status = sprintf(buf, "%d\n", gpio_get_value_cansleep(gpio));
+		status = sprintf(buf, "%d\n", !!gpio_get_value_cansleep(gpio));
 
 	mutex_unlock(&sysfs_lock);
 	return status;


-------------------------------------------------------
