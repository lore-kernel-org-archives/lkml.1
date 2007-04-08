Return-Path: <linux-kernel-owner+w=401wt.eu-S1752418AbXDHDjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbXDHDjf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 23:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932753AbXDHDjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 23:39:35 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:53748 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbXDHDje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 23:39:34 -0400
Date: Sat, 7 Apr 2007 23:39:27 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: aeb@cwi.nl
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] partitions: Add Kconfig dependency to clear benign
 compiler warning
In-Reply-To: <alpine.DEB.0.83.0704072235180.27057@sigma.j-a-k-j.com>
Message-ID: <alpine.DEB.0.83.0704072338490.27057@sigma.j-a-k-j.com>
References: <alpine.DEB.0.83.0704072235180.27057@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

Adds a dependency to ACORN_PARTITION_RISCIX in fs/partitions/Kconfig to 
prevent compilation of the function riscix_partition which is used only 
within ACORN_PARTITION_CUMANA and ACORN_PARTITION_ADFS sections, thereby 
preventing an unused-function compiler warning if ACORN_PARTITION_RISCIX 
is defined and neither of the other two are.

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

---

Nothing depending on RISCIX is defined except inside CUMANA and ADFS, so 
without either of those, nothing using the RISCIX stuff is compiled, hance 
the unused-function warning.

--- linux-2.6.20.6-orig/fs/partitions/Kconfig	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/Kconfig	2007-04-07 22:10:15.000000000 -0400
@@ -62,7 +62,7 @@ config ACORN_PARTITION_POWERTEC
 config ACORN_PARTITION_RISCIX
 	bool "RISCiX partition support" if PARTITION_ADVANCED
 	default y if ARCH_ACORN
-	depends on ACORN_PARTITION
+	depends on ACORN_PARTITION && (ACORN_PARTITION_CUMANA || ACORN_PARTITION_ADFS)
 	help
 	  Once upon a time, there was a native Unix port for the Acorn series
 	  of machines called RISCiX.  If you say 'Y' here, Linux will be able
