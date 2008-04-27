Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbYD0FPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbYD0FPy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 01:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYD0FPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 01:15:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55233 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbYD0FPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 01:15:46 -0400
Date: Sun, 27 Apr 2008 06:15:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] e1000e triggers sparc32 gcc bug
Message-ID: <20080427051541.GN5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	... and isn't possible on sparc32 boxen anyway, unless somebody
had done JavaStation with PCIE lately.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index b6ebcb9..733db3d 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2011,7 +2011,7 @@ config E1000_DISABLE_PACKET_SPLIT
 
 config E1000E
 	tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
-	depends on PCI
+	depends on PCI && (!SPARC32 || BROKEN)
 	---help---
 	  This driver supports the PCI-Express Intel(R) PRO/1000 gigabit
 	  ethernet family of adapters. For PCI or PCI-X e1000 adapters,
