Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbZFCXvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbZFCXvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZFCXu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:50:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55933 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbZFCXu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:50:57 -0400
Date: Thu, 4 Jun 2009 09:50:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Carvalho de Assis <acassis@gmail.com>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the mips tree with the arm tree
Message-Id: <20090604095055.1d1dfb5e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf,

Today's linux-next merge of the mips tree got conflicts in
drivers/char/hw_random/Kconfig and drivers/char/hw_random/Makefile
between commit 45001e92d0249a8c4b9f6c3695215652e8e8493d ("i.MX31: Add
hw-random for RNGA") from the arm tree and commit
5f2b54f3ee4417d943b98440063a5534503f6d6d ("MIPS: hwrng: Add TX4939 RNG
driver") from the mips tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/char/hw_random/Kconfig
index 26c93c7,9d321cc..0000000
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@@ -149,14 -149,15 +149,27 @@@ config HW_RANDOM_VIRTI
  	  To compile this driver as a module, choose M here: the
  	  module will be called virtio-rng.  If unsure, say N.
  
 +config HW_RANDOM_MXC_RNGA
 +	tristate "Freescale i.MX RNGA Random Number Generator"
 +	depends on HW_RANDOM && ARCH_HAS_RNGA
 +	---help---
 +	  This driver provides kernel-side support for the Random Number
 +	  Generator hardware found on Freescale i.MX processors.
 +
 +	  To compile this driver as a module, choose M here: the
 +	  module will be called mxc-rnga.
 +
 +	  If unsure, say Y.
++
+ config HW_RANDOM_TX4939
+ 	tristate "TX4939 Random Number Generator support"
+ 	depends on HW_RANDOM && SOC_TX4939
+ 	default HW_RANDOM
+ 	---help---
+ 	  This driver provides kernel-side support for the Random Number
+ 	  Generator hardware found on TX4939 SoC.
+ 
+ 	  To compile this driver as a module, choose M here: the
+ 	  module will be called tx4939-rng.
+ 
+ 	  If unsure, say Y.
diff --cc drivers/char/hw_random/Makefile
index fd1ecd2,936d388..0000000
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@@ -15,4 -15,4 +15,5 @@@ obj-$(CONFIG_HW_RANDOM_IXP4XX) += ixp4x
  obj-$(CONFIG_HW_RANDOM_OMAP) += omap-rng.o
  obj-$(CONFIG_HW_RANDOM_PASEMI) += pasemi-rng.o
  obj-$(CONFIG_HW_RANDOM_VIRTIO) += virtio-rng.o
 +obj-$(CONFIG_HW_RANDOM_MXC_RNGA) += mxc-rnga.o
+ obj-$(CONFIG_HW_RANDOM_TX4939) += tx4939-rng.o
