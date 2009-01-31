Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbZAaMmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbZAaMmr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 07:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZAaMmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 07:42:39 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:61520 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZAaMmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 07:42:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=oNJqOKX//JnKcB49bgrrJ5Jbap/fsJcoHnsfXyPYzI8bO5ZgTVnTVAhYUc+RWn6xYu
         KieYspTtQS7sT8SpK+qyUdG/HXsmtlEHbCJNjc0iODsZzBycLRZNfWfZN0OhAlbbEPzm
         MOIgl0LNXcPEVaiI6urBlADFrwcJoYt18X+MI=
Message-ID: <4984473C.1040508@gmail.com>
Date: Sat, 31 Jan 2009 13:42:36 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] sungem: limit reaches -1, but 0 tested
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a postfix decrement these reach -1 rather than 0,
but after the loop it is tested to have become 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/sungem_phy.c b/drivers/net/sungem_phy.c
index 61843fd..78f8cee 100644
--- a/drivers/net/sungem_phy.c
+++ b/drivers/net/sungem_phy.c
@@ -79,7 +79,7 @@ static int reset_one_mii_phy(struct mii_phy* phy, int phy_id)
 
 	udelay(100);
 
-	while (limit--) {
+	while (--limit) {
 		val = __phy_read(phy, phy_id, MII_BMCR);
 		if ((val & BMCR_RESET) == 0)
 			break;
