Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZLBNzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZLBNzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZLBNzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:55:24 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:46726 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZLBNzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:55:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Os3Bj1qBB8sOoqOWRG9haAR5ChaJKCcrgq6BbKZa3ZYUIqo3E6SDBBpOdXs+lhULUw
         8XMZhX5TVmitmaQhqL5e+YVjQa+La6ig9I88yQcrMhdjSXWjW8OIlNF+WZ0D9W58GYL7
         6tN5e8jYZyC7P9T6UYkY9k5ceTlf7KX3xUsig=
Message-ID: <4B1671C8.1030205@gmail.com>
Date: Wed, 02 Dec 2009 21:55:20 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 3/4]ARM: NUC900: enable timer clock for nuc932
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

This patch enables timer clock support for nuc932.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/time_932.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-w90x900/time_932.c b/arch/arm/mach-w90x900/time_932.c
index c50f9c0..3f315fe 100644
--- a/arch/arm/mach-w90x900/time_932.c
+++ b/arch/arm/mach-w90x900/time_932.c
@@ -38,10 +38,12 @@
 static void __init nuc900_timer_init(void)
 {
 	struct clk *ck_ext = clk_get(NULL, "ext");
+	struct clk *ck_timer = clk_get(NULL, "timer");
 	unsigned int	rate;
 
-	BUG_ON(IS_ERR(ck_ext));
+	BUG_ON(IS_ERR(ck_ext) || IS_ERR(ck_timer));
 
+	clk_enable(ck_timer);
 	rate = clk_get_rate(ck_ext);
 	clk_put(ck_ext);
 	rate = rate / (PRESCALE + 0x01);
-- 
1.5.6.3
