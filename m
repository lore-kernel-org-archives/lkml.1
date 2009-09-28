Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZI1Q0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZI1Q0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbZI1Q0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:26:13 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:37913 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbZI1Q0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:26:12 -0400
Date: Mon, 28 Sep 2009 09:25:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, davem@davemloft.net
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Karsten Keil <keil@b1-systems.de>, netdev <netdev@vger.kernel.org>
Subject: [PATCH] isdn: fix netjet/isdnhdlc build errors
Message-Id: <20090928092520.b6f921de.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AC0E374.0147:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Commit cb3824bade2549d7ad059d5802da43312540fdee didn't fix this problem.

Fix build errors in netjet, using isdnhdlc module:

drivers/built-in.o: In function `mode_tiger':
netjet.c:(.text+0x1ca0c7): undefined reference to `isdnhdlc_rcv_init'
netjet.c:(.text+0x1ca0d4): undefined reference to `isdnhdlc_out_init'
drivers/built-in.o: In function `fill_dma':
netjet.c:(.text+0x1ca2bd): undefined reference to `isdnhdlc_encode'
drivers/built-in.o: In function `read_dma':
netjet.c:(.text+0x1ca614): undefined reference to `isdnhdlc_decode'
drivers/built-in.o: In function `nj_irq':
netjet.c:(.text+0x1cb07a): undefined reference to `isdnhdlc_encode'

drivers/built-in.o: In function `isdnhdlc_decode':
(.text+0x1c2088): undefined reference to `crc_ccitt_table'
drivers/built-in.o: In function `isdnhdlc_encode':
(.text+0x1c2339): undefined reference to `crc_ccitt_table'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/hardware/mISDN/Kconfig |    1 +
 drivers/isdn/i4l/Kconfig            |    3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

--- lnx-2632-rc1.orig/drivers/isdn/hardware/mISDN/Kconfig
+++ lnx-2632-rc1/drivers/isdn/hardware/mISDN/Kconfig
@@ -78,6 +78,7 @@ config MISDN_NETJET
 	depends on PCI
 	select MISDN_IPAC
 	select ISDN_HDLC
+	select ISDN_I4L
 	help
 	  Enable support for Traverse Technologies NETJet PCI cards.
 
--- lnx-2632-rc1.orig/drivers/isdn/i4l/Kconfig
+++ lnx-2632-rc1/drivers/isdn/i4l/Kconfig
@@ -141,8 +141,7 @@ endmenu
 endif
 
 config ISDN_HDLC
-	tristate 
-	depends on HISAX_ST5481
+	tristate
 	select CRC_CCITT
 	select BITREVERSE
 
