Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbZLPNAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbZLPNAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 08:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbZLPNAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 08:00:36 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:35058 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbZLPNAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 08:00:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=bTSTFUdT7tv4cZ2Px+lfnvWHLSTu0xdNvNrmnCJKXv6dx1pIQDQg2Y8hyyvotvsafq
         +wCseVaxGNCCnjgESJ5YkfrZxlPfwjcY97kPVmY+87MBjuAWgk7uNfzyIwlWGhLDEaMq
         5jIXd2afP0qaE62uXsiTXp+FQlJLI9+yOpmXA=
Message-ID: <4B28DA62.40909@gmail.com>
Date: Wed, 16 Dec 2009 14:02:26 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: netdev@vger.kernel.org, mcarlson@broadcom.com,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, davem@davemloft.net
Subject: [PATCH] broadcom: bcm54xx_shadow_read() errors ignored in bcm54xx_adjust_rxrefclk()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If not signed read errors are ignored.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index f63c96a..c13cf64 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -326,7 +326,8 @@ error:
 
 static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
 {
-	u32 val, orig;
+	u32 orig;
+	int val;
 	bool clk125en = true;
 
 	/* Abort if we are using an untested phy. */
