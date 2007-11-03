Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbXKCTBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbXKCTBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 15:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757210AbXKCTBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 15:01:13 -0400
Received: from mail0.scram.de ([78.47.204.202]:44675 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016AbXKCTBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 15:01:10 -0400
X-Spam-Score: -3.906
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.5 AWL AWL: From: address is in the auto white-list
Message-ID: <472CC579.6050008@scram.de>
Date: Sat, 03 Nov 2007 20:01:13 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>
CC: Marcelo Tosatti <marcelo@kvack.org>, Scott Wood <scottwood@freescale.com>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       netdev <netdev@vger.kernel.org>
Subject: [PATCH2/2] [POWERPC] fs_enet: select PHYLIB as the driver needs it.
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a select PHYLIB to config FS_ENET as the driver uses functions of
libphy.

LD      .tmp_vmlinux1
drivers/built-in.o: In function `fs_ioctl':
drivers/net/fs_enet/fs_enet-main.c:952: undefined reference to `phy_mii_ioctl'
[...]
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
drivers/net/fs_enet/Kconfig |    1 +
1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/fs_enet/Kconfig b/drivers/net/fs_enet/Kconfig
index 2765e49..24502d2 100644
--- a/drivers/net/fs_enet/Kconfig
+++ b/drivers/net/fs_enet/Kconfig
@@ -2,6 +2,7 @@ config FS_ENET
     tristate "Freescale Ethernet Driver"
     depends on CPM1 || CPM2
     select MII
+       select PHYLIB

config FS_ENET_HAS_SCC
	bool "Chip has an SCC usable for ethernet"
-- 
1.5.3.4




