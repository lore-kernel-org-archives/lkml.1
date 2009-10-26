Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbZJZVW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbZJZVW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZJZVW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:22:27 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:49476 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbZJZVW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=iUFW1u7grUYvY5/08bvtodUaWMKjCbwTdFkwkmdfv+xwlHVlR2FZVt5hyGuUZpB8hz
         ARH3pMGNKii7k/eSTM+zTEDyypB/+QKRP8xOXsY13vzlN57Khq6rrVW4KRsOwYjrhMqC
         hb+6/CHWjM2xHYK0CQdHNtGQBqw37FlcmNO/E=
Message-ID: <4AE61590.2030603@gmail.com>
Date: Mon, 26 Oct 2009 22:33:04 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] icst307: Add missing increment
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this increment the loop can only break if it does in the
first iteration.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/arm/common/icst307.c b/arch/arm/common/icst307.c
index 6d094c1..b255fbf 100644
--- a/arch/arm/common/icst307.c
+++ b/arch/arm/common/icst307.c
@@ -55,7 +55,7 @@ icst307_khz_to_vco(const struct icst307_params *p, unsigned long freq)
 		 */
 		if (f > 6000 && f <= p->vco_max)
 			break;
-	} while (i < ARRAY_SIZE(idx2s));
+	} while (++i < ARRAY_SIZE(idx2s));
 
 	if (i >= ARRAY_SIZE(idx2s))
 		return vco;
@@ -117,7 +117,7 @@ icst307_ps_to_vco(const struct icst307_params *p, unsigned long period)
 		 */
 		if (f >= ps && f < 1000000000UL / 6000 + 1)
 			break;
-	} while (i < ARRAY_SIZE(idx2s));
+	} while (++i < ARRAY_SIZE(idx2s));
 
 	if (i >= ARRAY_SIZE(idx2s))
 		return vco;
