Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbXJ1USc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbXJ1USc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 16:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbXJ1USX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 16:18:23 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:52899 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbXJ1USW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 16:18:22 -0400
Date: Sun, 28 Oct 2007 16:15:49 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Only show RESOURCES_64BIT on relevant architectures
Message-ID: <20071028201549.GA23138@fattire.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To quote lolcats: CONFIG_RESOURCES_64BIT DO NOT WANT!

I *think* I have the logic of this right... Anyway, I was annoyed by
having to do the bloody ugly casts to unsigned long long in
arch-specific code. As near as I can tell, we only want this selectable
in the case of PAE on x86, and some random PPC and MIPS embedded boards.

For everyone else, it should be whatever the value of 64BIT is.

And I can be happy and continue using unsigned long and going about my
merry business.

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
---
diff --git a/mm/Kconfig b/mm/Kconfig
index c070ec0..c25a838 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -172,6 +172,7 @@ config MIGRATION
 
 config RESOURCES_64BIT
 	bool "64 bit Memory and IO resources (EXPERIMENTAL)" if (!64BIT && EXPERIMENTAL)
+	depends on (MIPS || PPC32 || X86_PAE) || 64BIT
 	default 64BIT
 	help
 	  This option allows memory and IO resources to be 64 bit.
