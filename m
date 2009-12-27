Return-Path: <linux-kernel-owner+w=401wt.eu-S1751447AbZL0VOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbZL0VOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZL0VOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:14:09 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40853 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZL0VOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:14:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=CJ2gbrtPOTBVOfgfz8rc3kmNRgsLvF6spRPGLVLAil/KV0Y6muYmOcOdhCaycRiOQd
         pP1yCi6LNvRvNFYq55aCEOTr0VkPFlTgTBmYHHptqwIAlP+Tim0C8aF8IPW6Tr3RDiKa
         SGZSQtG5UCPg7/0XDJ2pdP+qoHh7px3u16edc=
Message-ID: <4B37CEC9.4080801@gmail.com>
Date: Sun, 27 Dec 2009 22:16:57 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Karsten Keil <isdn@linux-pingi.de>, isdn4linux@listserv.isdn4linux.de,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] hisax: timeout off by one in waitrecmsg()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With `while (timeout++ < maxdelay)' timeout reaches maxdelay + 1 after the loop
This is probably unlikely a problem in practice.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/isdn/hisax/isar.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hisax/isar.c b/drivers/isdn/hisax/isar.c
index bfeb9b6..6bde16c 100644
--- a/drivers/isdn/hisax/isar.c
+++ b/drivers/isdn/hisax/isar.c
@@ -138,7 +138,7 @@ waitrecmsg(struct IsdnCardState *cs, u_char *len,
 	while((!(cs->BC_Read_Reg(cs, 0, ISAR_IRQBIT) & ISAR_IRQSTA)) &&
 		(timeout++ < maxdelay))
 		udelay(1);
-	if (timeout >= maxdelay) {
+	if (timeout > maxdelay) {
 		printk(KERN_WARNING"isar recmsg IRQSTA timeout\n");
 		return(0);
 	}
