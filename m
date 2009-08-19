Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbZHSPui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbZHSPui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 11:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbZHSPuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 11:50:37 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:58085 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbZHSPug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 11:50:36 -0400
Date: Wed, 19 Aug 2009 08:52:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: fix ks8851 build errors
Message-Id: <20090819085202.810630a2.randy.dunlap@oracle.com>
In-Reply-To: <20090818.201200.69809801.davem@davemloft.net>
References: <20090818184215.fdf1c7ae.sfr@canb.auug.org.au>
	<20090818152705.64557a0b.randy.dunlap@oracle.com>
	<20090818.201200.69809801.davem@davemloft.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4A8C1F3E.0067:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors due to missing Kconfig select of CRC32:

ks8851.c:(.text+0x7d2ee): undefined reference to `crc32_le'
ks8851.c:(.text+0x7d2f5): undefined reference to `bitrev32'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090818.orig/drivers/net/Kconfig
+++ linux-next-20090818/drivers/net/Kconfig
@@ -1733,6 +1733,7 @@ config KS8851
        tristate "Micrel KS8851 SPI"
        depends on SPI
        select MII
+	select CRC32
        help
          SPI driver for Micrel KS8851 SPI attached network chip.
 




---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
