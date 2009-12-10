Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbZLJRbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbZLJRbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761053AbZLJRbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:31:42 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:46474 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781AbZLJRbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:31:40 -0500
Date: Thu, 10 Dec 2009 09:31:03 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       davem@davemloft.net
Subject: [PATCH -next] net: niu uses crc32, so select CRC32
Message-Id: <20091210093103.eda05dfe.randy.dunlap@oracle.com>
In-Reply-To: <20091210175919.340b4c0c.sfr@canb.auug.org.au>
References: <20091210175919.340b4c0c.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B213079.0152:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

niu drivers uses crc32 functions, so it needs to select CRC32.

niu.c:(.text+0x18a7f8): undefined reference to `crc32_le'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20091210.orig/drivers/net/Kconfig
+++ linux-next-20091210/drivers/net/Kconfig
@@ -2698,6 +2698,7 @@ config NETXEN_NIC
 config NIU
 	tristate "Sun Neptune 10Gbit Ethernet support"
 	depends on PCI
+	select CRC32
 	help
 	  This enables support for cards based upon Sun's
 	  Neptune chipset.
---
~Randy
