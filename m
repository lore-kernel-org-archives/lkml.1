Return-Path: <linux-kernel-owner+w=401wt.eu-S1761932AbZJNWBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761932AbZJNWBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761632AbZJNWBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:01:50 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:59417 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761592AbZJNWBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:01:50 -0400
Date: Wed, 14 Oct 2009 14:59:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org, netdev <netdev@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, David Choi <david.choi@micrel.com>
Subject: [PATCH -mmotm] net: ks8851_mll uses mii interfaces
Message-Id: <20091014145905.219416bb.randy.dunlap@oracle.com>
In-Reply-To: <200910140436.n9E4aF9G001644@imap1.linux-foundation.org>
References: <200910140436.n9E4aF9G001644@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AD64A1A.01AF:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

ks8851_mll uses mii interfaces so it needs to select MII.

ks8851_mll.c:(.text+0xf95ac): undefined reference to `generic_mii_ioctl'
ks8851_mll.c:(.text+0xf96a0): undefined reference to `mii_ethtool_gset'
ks8851_mll.c:(.text+0xf96fa): undefined reference to `mii_ethtool_sset'
ks8851_mll.c:(.text+0xf9754): undefined reference to `mii_link_ok'
ks8851_mll.c:(.text+0xf97ae): undefined reference to `mii_nway_restart'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Choi <david.choi@micrel.com>
---
 drivers/net/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2009-1013-2113.orig/drivers/net/Kconfig
+++ mmotm-2009-1013-2113/drivers/net/Kconfig
@@ -1741,6 +1741,7 @@ config KS8851
 config KS8851_MLL
 	tristate "Micrel KS8851 MLL"
 	depends on HAS_IOMEM
+	select MII
 	help
 	  This platform driver is for Micrel KS8851 Address/data bus
 	  multiplexed network chip.
