Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbZKCS7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbZKCS7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 13:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZKCS67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 13:58:59 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:43773 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbZKCS67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:58:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Whf5GXU+QtDXc1dSuROq+z9wVZWbvFyvqcYz+M8SxDCofTT672TfuHFV1dbtqsSwUV
         cGvFyTWQ0EuxRaArVtyaviFQ61g3sklffq1RYDWuVLJK4YCxFx9tK9vnP/adwvAGYe1C
         UPenAuhzkIeRFD2j8fo64DDwIjWVFXKIhdOug=
Message-ID: <4AF08014.4000704@gmail.com>
Date: Tue, 03 Nov 2009 20:10:12 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khc@pm.waw.pl>,
       linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] IXP4xx: Ensure index is positive
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The indexes are signed, make sure they are not negative
when we read the array elements.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/arm/mach-ixp4xx/common.c     |    2 +-
 arch/arm/mach-ixp4xx/ixp4xx_npe.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index cfd52fb..2df77bc 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -119,7 +119,7 @@ EXPORT_SYMBOL(gpio_to_irq);
 
 int irq_to_gpio(int irq)
 {
-	int gpio = (irq < 32) ? irq2gpio[irq] : -EINVAL;
+	int gpio = (irq < 32 && irq >= 0) ? irq2gpio[irq] : -EINVAL;
 
 	if (gpio == -1)
 		return -EINVAL;
diff --git a/arch/arm/mach-ixp4xx/ixp4xx_npe.c b/arch/arm/mach-ixp4xx/ixp4xx_npe.c
index 47ac69c..30e1456 100644
--- a/arch/arm/mach-ixp4xx/ixp4xx_npe.c
+++ b/arch/arm/mach-ixp4xx/ixp4xx_npe.c
@@ -667,7 +667,7 @@ err:
 
 struct npe *npe_request(int id)
 {
-	if (id < NPE_COUNT)
+	if (id >= 0 && id < NPE_COUNT)
 		if (npe_tab[id].valid)
 			if (try_module_get(THIS_MODULE))
 				return &npe_tab[id];
