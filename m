Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007Ab0ANVHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab0ANVHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688Ab0ANVHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:07:10 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:1043 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab0ANVHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:07:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=rNqU5HQweDzS9SXAteyCTkkqz1iS+UrdtAbJK746DNEhDZv7sVP2NQCAeOsPzMRnXG
         /z0GKcW2OijoL7RwqSfyxKB/V4e/Z1tvn5D0AXv80J2uJKce5E8NDwLtuTqpJckXMxrX
         w0FBQHdUARjOR6FmYq2ASi/Yu/h+Y4yDKJCFY=
Message-ID: <4B4F8877.6080105@gmail.com>
Date: Thu, 14 Jan 2010 22:11:19 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Gemini: wrong registers used to set reg_level in gpio_set_irq_type()?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears the wrong GPIO registers were used

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I am not sure whether this is right so please review.

diff --git a/arch/arm/mach-gemini/gpio.c b/arch/arm/mach-gemini/gpio.c
index e726385..fe3bd5a 100644
--- a/arch/arm/mach-gemini/gpio.c
+++ b/arch/arm/mach-gemini/gpio.c
@@ -86,7 +86,7 @@ static int gpio_set_irq_type(unsigned int irq, unsigned int type)
 	unsigned int reg_both, reg_level, reg_type;
 
 	reg_type = __raw_readl(base + GPIO_INT_TYPE);
-	reg_level = __raw_readl(base + GPIO_INT_BOTH_EDGE);
+	reg_level = __raw_readl(base + GPIO_INT_LEVEL);
 	reg_both = __raw_readl(base + GPIO_INT_BOTH_EDGE);
 
 	switch (type) {
@@ -117,7 +117,7 @@ static int gpio_set_irq_type(unsigned int irq, unsigned int type)
 	}
 
 	__raw_writel(reg_type, base + GPIO_INT_TYPE);
-	__raw_writel(reg_level, base + GPIO_INT_BOTH_EDGE);
+	__raw_writel(reg_level, base + GPIO_INT_LEVEL);
 	__raw_writel(reg_both, base + GPIO_INT_BOTH_EDGE);
 
 	gpio_ack_irq(irq);
