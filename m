Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZKUTNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZKUTNo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 14:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbZKUTNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 14:13:44 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:64141 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbZKUTNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 14:13:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=m7KH2MQP1ENgX1POmllt48pfDMCt37Fq7B/yheI5aNHeoc11K2TUWF08EiTe5xCYls
         sLI3k8gr228X5yrpink5a7YwyVvge6HPK0AZpT/RJK3LSPw06wjEUm9hNZwwqnWST8w6
         u5oUMU6dJCXt5kq1aGmS9bE/mC0nZZ6icuyWk=
Message-ID: <4B083EE2.9040301@gmail.com>
Date: Sat, 21 Nov 2009 20:26:26 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] e1000e: Use sizeof struct rather than pointer in e1000_get_eeprom()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sizeof the struct should be used rather than of the pointer

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/e1000e/ethtool.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Unless I am mistaken?

diff --git a/drivers/net/e1000e/ethtool.c b/drivers/net/e1000e/ethtool.c
index 1bf4d2a..13c658e 100644
--- a/drivers/net/e1000e/ethtool.c
+++ b/drivers/net/e1000e/ethtool.c
@@ -508,7 +508,7 @@ static int e1000_get_eeprom(struct net_device *netdev,
 
 	if (ret_val) {
 		/* a read error occurred, throw away the result */
-		memset(eeprom_buff, 0xff, sizeof(eeprom_buff));
+		memset(eeprom_buff, 0xff, sizeof(*eeprom_buff));
 	} else {
 		/* Device's eeprom is always little-endian, word addressable */
 		for (i = 0; i < last_word - first_word + 1; i++)
