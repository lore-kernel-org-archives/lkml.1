Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbZKCVyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbZKCVyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 16:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZKCVyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 16:54:12 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:57803 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbZKCVyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 16:54:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jhmBvtEo3iAKRviIpZFhTsyiFK6Bxc7KN8L8EvsT2wtvqz0bAKMJWZao7tHL0k4Lpz
         Abz5YbmBiIVy317Efvl5if5alJ42cuFyMpGLmRGiytr/QfM/Zk/lCQsAsKtQPshg5+Ld
         deRUgdKtvdUwly30wNO5VPTZKhvNq2OCfupfg=
Message-ID: <4AF0A92C.6050400@gmail.com>
Date: Tue, 03 Nov 2009 23:05:32 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Karl Hiramoto <karl@hiramoto.org>, Imre Kaloz <kaloz@openwrt.org>,
       linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] IXP4xx: Ensure index is positive
References: <4AF08014.4000704@gmail.com> <4AF0922B.3030701@hiramoto.org> <m3eiofl2v8.fsf@intrepid.localdomain>
In-Reply-To: <m3eiofl2v8.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The indexes were signed, so negatives were possible.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Op 03-11-09 22:23, Krzysztof Halasa schreef:
> Karl Hiramoto <karl@hiramoto.org> writes:

>> changing npe_request() to unsigned would probably be better

> Right. Both files in fact.
> 
> Even the id < NPE_COUNT test is probably not needed but I can imagine
> someone lowering NPE_COUNT. Negative values are unreasonable (though
> unsigned type make this unrelevant, of course).

 arch/arm/mach-ixp4xx/common.c            |    2 +-
 arch/arm/mach-ixp4xx/include/mach/gpio.h |    2 +-
 arch/arm/mach-ixp4xx/include/mach/npe.h  |    2 +-
 arch/arm/mach-ixp4xx/ixp4xx_npe.c        |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

Is this ok?

diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index cfd52fb..3bbf40f 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -117,7 +117,7 @@ int gpio_to_irq(int gpio)
 }
 EXPORT_SYMBOL(gpio_to_irq);
 
-int irq_to_gpio(int irq)
+int irq_to_gpio(unsigned int irq)
 {
 	int gpio = (irq < 32) ? irq2gpio[irq] : -EINVAL;
 
diff --git a/arch/arm/mach-ixp4xx/include/mach/gpio.h b/arch/arm/mach-ixp4xx/include/mach/gpio.h
index cd5aec2..a5f87de 100644
--- a/arch/arm/mach-ixp4xx/include/mach/gpio.h
+++ b/arch/arm/mach-ixp4xx/include/mach/gpio.h
@@ -70,7 +70,7 @@ static inline void gpio_set_value(unsigned gpio, int value)
 #include <asm-generic/gpio.h>			/* cansleep wrappers */
 
 extern int gpio_to_irq(int gpio);
-extern int irq_to_gpio(int gpio);
+extern int irq_to_gpio(unsigned int irq);
 
 #endif
 
diff --git a/arch/arm/mach-ixp4xx/include/mach/npe.h b/arch/arm/mach-ixp4xx/include/mach/npe.h
index 37d0511..e320db2 100644
--- a/arch/arm/mach-ixp4xx/include/mach/npe.h
+++ b/arch/arm/mach-ixp4xx/include/mach/npe.h
@@ -33,7 +33,7 @@ int npe_send_message(struct npe *npe, const void *msg, const char *what);
 int npe_recv_message(struct npe *npe, void *msg, const char *what);
 int npe_send_recv_message(struct npe *npe, void *msg, const char *what);
 int npe_load_firmware(struct npe *npe, const char *name, struct device *dev);
-struct npe *npe_request(int id);
+struct npe *npe_request(unsigned id);
 void npe_release(struct npe *npe);
 
 #endif /* __IXP4XX_NPE_H */
diff --git a/arch/arm/mach-ixp4xx/ixp4xx_npe.c b/arch/arm/mach-ixp4xx/ixp4xx_npe.c
index 47ac69c..e8bb257 100644
--- a/arch/arm/mach-ixp4xx/ixp4xx_npe.c
+++ b/arch/arm/mach-ixp4xx/ixp4xx_npe.c
@@ -665,7 +665,7 @@ err:
 }
 
 
-struct npe *npe_request(int id)
+struct npe *npe_request(unsigned id)
 {
 	if (id < NPE_COUNT)
 		if (npe_tab[id].valid)
