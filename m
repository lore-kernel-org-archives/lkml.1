Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbYHTAF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbYHTAF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 20:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYHTAFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 20:05:12 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:26550 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbYHTAFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 20:05:10 -0400
Date: Tue, 19 Aug 2008 17:05:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
       samr <sam@ravnborg.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sameo@openedhand.com
Subject: Re: linux-next: Tree for August 19 (mfd/ucb)
Message-Id: <20080819170517.04d91de8.randy.dunlap@oracle.com>
In-Reply-To: <20080819185454.d9c74915.sfr@canb.auug.org.au>
References: <20080819185454.d9c74915.sfr@canb.auug.org.au>
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

drivers/mfd/ucb1400 is a sound (AC97) driver, so it should depend
on AC97_BUS, like in the patch below.  However, with that patch in
place, oldconfig goes belly up on me:


linux-next-20080819> make ARCH=x86_64  O=X64  V=1 oldconfig
make -C /local/linsrc/linux-next-20080819/X64 \
	KBUILD_SRC=/local/linsrc/linux-next-20080819 \
	KBUILD_EXTMOD="" -f /local/linsrc/linux-next-20080819/Makefile \
	oldconfig
make -f /local/linsrc/linux-next-20080819/scripts/Makefile.build obj=scripts/basic
/bin/sh /local/linsrc/linux-next-20080819/scripts/mkmakefile \
	    /local/linsrc/linux-next-20080819 /local/linsrc/linux-next-20080819/X64 2 6
  GEN     /local/linsrc/linux-next-20080819/X64/Makefile
mkdir -p include/linux include/config
make -f /local/linsrc/linux-next-20080819/scripts/Makefile.build obj=scripts/kconfig oldconfig
scripts/kconfig/conf -o arch/x86/Kconfig
make[2]: *** [oldconfig] Segmentation fault (core dumped)
make[1]: *** [oldconfig] Error 2
make: *** [sub-make] Error 2



---
From: Randy Dunlap <randy.dunlap@oracle.com>

mfd/ucb1400 sound driver uses/depends on AC97_BUS:

ERROR: "ac97_bus_type" [drivers/mfd/ucb1400_core.ko] undefined!


Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Samuel Ortiz <sameo@openedhand.com>

---
 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20080819.orig/drivers/mfd/Kconfig
+++ linux-next-20080819/drivers/mfd/Kconfig
@@ -52,6 +52,7 @@ config HTC_PASIC3
 
 config UCB1400_CORE
 	tristate "Philips UCB1400 Core driver"
+	depends on AC97_BUS
 	help
 	  This enables support for the Philips UCB1400 core functions.
 	  The UCB1400 is an AC97 audio codec.
