Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbYIEDmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbYIEDmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYIEDm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:42:26 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:28164 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbYIEDmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:42:25 -0400
Date: Thu, 4 Sep 2008 20:41:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, jgarzik <jgarzik@pobox.com>,
       jeffrey.t.kirsher@intel.com, e1000-devel@lists.sourceforge.net
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for September 4 (PATCH: IXGBE)
Message-Id: <20080904204137.9b31f644.randy.dunlap@oracle.com>
In-Reply-To: <20080904193606.573f2cb3.sfr@canb.auug.org.au>
References: <20080904193606.573f2cb3.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

ixgbe needs to be restricted to the same build config (m/y)
as DCA since it calls the dca_*() functions.

ixgbe_main.c:(.text+0xd9c09): undefined reference to `dca3_get_tag'
ixgbe_main.c:(.text+0xd9cc9): undefined reference to `dca3_get_tag'
ixgbe_main.c:(.text+0xda5c1): undefined reference to `dca_add_requester'
ixgbe_main.c:(.text+0xda5d6): undefined reference to `dca_remove_requester'
text+0xdc162): undefined reference to `dca_add_requester'
text+0xdc1d3): undefined reference to `dca_remove_requester'
ixgbe_main.c:(.init.text+0xa74b): undefined reference to `dca_register_notify'
ixgbe_main.c:(.devinit.text+0xa4ca): undefined reference to `dca_add_requester'
ixgbe_main.c:(.exit.text+0xd21): undefined reference to `dca_unregister_notify'
ixgbe_main.c:(.devexit.text+0x72d): undefined reference to `dca_remove_requester'
make[1]: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20080904.orig/drivers/net/Kconfig
+++ linux-next-20080904/drivers/net/Kconfig
@@ -2379,7 +2379,7 @@ config EHEA
 
 config IXGBE
 	tristate "Intel(R) 10GbE PCI Express adapters support"
-	depends on PCI && INET
+	depends on PCI && INET && DCA
 	select INET_LRO
 	---help---
 	  This driver supports Intel(R) 10GbE PCI Express family of
