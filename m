Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbYKCSxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbYKCSxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 13:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYKCSw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 13:52:57 -0500
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:49146 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110AbYKCSw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 13:52:56 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] rtc-cmos: Fix boot log message
Date: Mon, 3 Nov 2008 19:52:38 +0100
User-Agent: KMail/1.9.9
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200811031942.20360.elendil@planet.nl>
In-Reply-To: <200811031942.20360.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811031952.39423.elendil@planet.nl>
X-OriginalArrivalTime: 03 Nov 2008 18:52:39.0937 (UTC) FILETIME=[588F6F10:01C93DE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 November 2008, Frans Pop wrote:
> rtc0: alarms up to one month, y3k, 114 bytes nvram, , hpet irqs irqs

Here's a possible patch for this one.

Alternative would be to change the following line at 808:
			is_hpet_enabled() ? ", hpet irqs" : "");
to:
			is_hpet_enabled() ? "hpet" : "<sensible value>");

Question is what that sensible value would be...

---
From: Frans Pop <elendil@planet.nl>

rtc-cmos: Fix boot log message
    
-rtc0: alarms up to one month, y3k, 114 bytes nvram, , hpet irqs irqs
+rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
    
Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 5549231..6cf8e28 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -794,7 +794,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 		goto cleanup2;
 	}
 
-	pr_info("%s: alarms up to one %s%s, %zd bytes nvram, %s irqs\n",
+	pr_info("%s: alarms up to one %s%s, %zd bytes nvram%s\n",
 			cmos_rtc.rtc->dev.bus_id,
 			is_valid_irq(rtc_irq)
 				?  (cmos_rtc.mon_alrm
