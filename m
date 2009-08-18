Return-Path: <linux-kernel-owner+w=401wt.eu-S1751514AbZHRWZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbZHRWZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbZHRWZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:25:58 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:33430 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbZHRWZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:25:58 -0400
Date: Tue, 18 Aug 2009 15:25:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH -next] mfd: fix mc13783 build error
Message-Id: <20090818152555.793773ad.randy.dunlap@oracle.com>
In-Reply-To: <20090818184215.fdf1c7ae.sfr@canb.auug.org.au>
References: <20090818184215.fdf1c7ae.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4A8B2A65.0039:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors due to missing Kconfig dependency:

mc13783-core.c:(.text+0x11bbaf): undefined reference to `spi_sync'
mc13783-core.c:(.init.text+0xb6b3): undefined reference to `spi_register_driver'
mc13783-core.c:(.devinit.text+0x1fd8b): undefined reference to `spi_setup'
drivers/built-in.o:(.data+0x157c0): undefined reference to `spi_bus_type'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090818.orig/drivers/mfd/Kconfig
+++ linux-next-20090818/drivers/mfd/Kconfig
@@ -240,6 +240,7 @@ config MFD_PCF50633
 
 config MFD_MC13783
 	tristate "Support Freescale MC13783"
+	depends on SPI_MASTER
 	select MFD_CORE
 	help
 	  Support for the Freescale (Atlas) MC13783 PMIC and audio CODEC.



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
