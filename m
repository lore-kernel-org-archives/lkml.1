Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbZJZVf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbZJZVf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZJZVf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:35:57 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:48683 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbZJZVf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:35:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sXtGLoaQhhEi56L5VddmETs7Wnv72JqTsUMBp1tyXpyjkityeRd5FWxum9c42A/oWs
         O3UoY+ktgviHb0wrnKksJSahGVqt2bvi9tQUuRlpB6M5iIKXUryOPfHo72ozO0fJsVWe
         J6oh36tau5Yc/JGwUsy1a9Ybx+IHtSWKu3SD0=
Message-ID: <4AE618BB.4060601@gmail.com>
Date: Mon, 26 Oct 2009 22:46:35 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] icst525: Add missing increment
References: <4AE61590.2030603@gmail.com>
In-Reply-To: <4AE61590.2030603@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this increment the loop can only break if it does in the
first iteration.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/arm/common/icst525.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Same issue, different file.

diff --git a/arch/arm/common/icst525.c b/arch/arm/common/icst525.c
index 3d377c5..0aef96a 100644
--- a/arch/arm/common/icst525.c
+++ b/arch/arm/common/icst525.c
@@ -53,7 +53,7 @@ icst525_khz_to_vco(const struct icst525_params *p, unsigned long freq)
 		 */
 		if (f > 10000 && f <= p->vco_max)
 			break;
-	} while (i < ARRAY_SIZE(idx2s));
+	} while (++i < ARRAY_SIZE(idx2s));
 
 	if (i >= ARRAY_SIZE(idx2s))
 		return vco;
@@ -116,7 +116,7 @@ icst525_ps_to_vco(const struct icst525_params *p, unsigned long period)
 		 */
 		if (f >= ps && f < 100000)
 			break;
-	} while (i < ARRAY_SIZE(idx2s));
+	} while (++i < ARRAY_SIZE(idx2s));
 
 	if (i >= ARRAY_SIZE(idx2s))
 		return vco;
