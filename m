Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbZIYNbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbZIYNbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 09:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZIYNbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 09:31:44 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:33433 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbZIYNbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 09:31:43 -0400
Date: Fri, 25 Sep 2009 19:01:43 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: linux-next: 20090925 - hvc driver build breaks with !HVC_CONSOLE
Message-ID: <20090925133143.GD6831@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20090925133830.1ba29584.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090925133830.1ba29584.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

	next-20090925 randconfig build breaks on hvcs driver on powerpc,
with HVC_CONSOLE=n.

ERROR: ".hvc_put_chars" [drivers/char/hvcs.ko] undefined!
ERROR: ".hvc_get_chars" [drivers/char/hvcs.ko] undefined!

adding the dependency of HVC_CONSOLE helped

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
 drivers/char/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index a2a0e67..2583231 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -682,7 +682,7 @@ config VIRTIO_CONSOLE
 
 config HVCS
 	tristate "IBM Hypervisor Virtual Console Server support"
-	depends on PPC_PSERIES
+	depends on PPC_PSERIES && HVC_CONSOLE
 	help
 	  Partitionable IBM Power5 ppc64 machines allow hosting of
 	  firmware virtual consoles from one Linux partition by
			
			Kamalesh
