Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbXJXOkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbXJXOkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbXJXOkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:40:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:54603 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbXJXOko convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:40:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Xlc4OxATzyST0qlzIWUC5NNvWV1rh5sMqlcC4Z111l2JPlyzQXNYk/KFjw3NoBojZLaDtTupZ36/BDss4QLDreMmYDYIVbtXSaFj9XhU8UaZAB1jKpjUV/7W7PRSWi3olhHfMgajMstdTxtFsLBnOq8lVV8dSRd8mcPVvwrbWkg=
From: Miguel =?iso-8859-1?q?Bot=F3n?= <mboton.lkml@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] mac80211: fix "format '%d' expects type 'int', but argument 7 has type 'long unsigned int'" warning
Date: Wed, 24 Oct 2007 16:37:08 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710241637.08224.mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

printf() expects an "integer" value but we give it a "long unsigned integer".

diff -ruN linux-2.6.24-rc1.orig/net/mac80211/ieee80211_sta.c 
linux-2.6.24-rc1/net/mac80211/ieee80211_sta.c
--- linux-2.6.24-rc1.orig/net/mac80211/ieee80211_sta.c  2007-10-24 
16:06:49.000000000 +0200
+++ linux-2.6.24-rc1/net/mac80211/ieee80211_sta.c       2007-10-24 
16:12:05.000000000 +0200
@@ -1182,7 +1182,7 @@
 	aid = le16_to_cpu(mgmt->u.assoc_resp.aid);

 	printk(KERN_DEBUG "%s: RX %sssocResp from %s (capab=0x%x "
-	       "status=%d aid=%d)\n",
+	       "status=%d aid=%ld)\n",
 	       dev->name, reassoc ? "Rea" : "A", print_mac(mac, mgmt->sa),
 	       capab_info, status_code, aid & ~(BIT(15) | BIT(14)));
 

-- 
	Miguel Botón
