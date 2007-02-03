Return-Path: <linux-kernel-owner+w=401wt.eu-S1946269AbXBCCjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946269AbXBCCjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946263AbXBCCjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:39:01 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53013 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946260AbXBCCij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:38:39 -0500
Message-Id: <20070203024258.513553000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:37 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Francois Romieu <romieu@fr.zoreil.com>, Andrew Morton <akpm@osdl.org>,
       <sleepy@mike-neko.net>, Jeff Garzik <jeff@garzik.org>
Subject: [patch 33/59] sis190: failure to set the MAC address from EEPROM
Content-Disposition: inline; filename=sis190-failure-to-set-the-mac-address-from-eeprom.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Francois Romieu <romieu@fr.zoreil.com>

Fix from http://bugzilla.kernel.org/show_bug.cgi?id=7747

Signed-off-by: Andrew Morton <akpm@osdl.org>
Cc: <sleepy@mike-neko.net>
Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/sis190.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.19.2.orig/drivers/net/sis190.c
+++ linux-2.6.19.2/drivers/net/sis190.c
@@ -1559,7 +1559,7 @@ static int __devinit sis190_get_mac_addr
 	for (i = 0; i < MAC_ADDR_LEN / 2; i++) {
 		__le16 w = sis190_read_eeprom(ioaddr, EEPROMMACAddr + i);
 
-		((u16 *)dev->dev_addr)[0] = le16_to_cpu(w);
+		((u16 *)dev->dev_addr)[i] = le16_to_cpu(w);
 	}
 
 	sis190_set_rgmii(tp, sis190_read_eeprom(ioaddr, EEPROMInfo));

--
