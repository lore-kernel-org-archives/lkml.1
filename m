Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbZJEPGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbZJEPGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 11:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZJEPGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 11:06:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46587 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZJEPGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 11:06:18 -0400
Date: Mon, 5 Oct 2009 16:05:30 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix sparsemem configuration
Message-ID: <20091005150530.GA12271@rmk-PC.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, sparsemem is only available if EXPERIMENTAL is enabled.
However, it hasn't ever been marked experimental.

It's been about four years since sparsemem was merged, and we have
platforms which depend on it; allow architectures to decide whether
sparsemem should be the default memory model.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
--
 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 2477607..95b2965 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -67,7 +67,7 @@ config DISCONTIGMEM
 
 config SPARSEMEM
 	def_bool y
-	depends on SPARSEMEM_MANUAL
+	depends on (!SELECT_MEMORY_MODEL && ARCH_SPARSEMEM_ENABLE) || SPARSEMEM_MANUAL
 
 config FLATMEM
 	def_bool y
