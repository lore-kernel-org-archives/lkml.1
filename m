Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750868Ab0BJFCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 00:02:41 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56832 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab0BJFCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 00:02:40 -0500
Date: Wed, 10 Feb 2010 16:02:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Finn Thain <fthain@telegraphics.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: linux-next: manual merge of the devicetree tree with the m68k tree
Message-Id: <20100210160234.673f32d1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Today's linux-next merge of the devicetree tree got a conflict in
drivers/serial/pmac_zilog.c between commit
f0ccf0f0269dfe53ec3f1c58fe130a47b908b907 ("pmac-zilog: cleanup") from
the m68k tree and commit71a157e8edca55198e808f8561dd49017a54ee34  ("of: add
'of_' prefix to machine_is_compatible()") from the devicetree tree.

The first removes a space ... I fixed it up (see below) and can carry the
fix as necessary.  (Grant, you could get rid of this by removing the
space between the tabs on the line "baud = 57600;".  Not a big issue,
though.)

Also, there is a further patch in the m68k tree
(89d58f83cfce675a2054975cc2598ba1979816c7 "pmac-zilog: add platform
driver") that adds a define for machine_is_compatible.  I fixed that as
below as well.  Hmmm, this file should really include linux/of_fdt.h for
the definition of of_machine_is_compatible(), shouldn't it?  And then
maybe we could have a non OF version of the prototype/define in
of_fdt.h?  Just an idea.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/serial/pmac_zilog.c
index 870b6a3,3e2ae48..0000000
--- a/drivers/serial/pmac_zilog.c
+++ b/drivers/serial/pmac_zilog.c
@@@ -70,10 -68,6 +70,10 @@@
  #include <asm/pmac_feature.h>
  #include <asm/dbdma.h>
  #include <asm/macio.h>
 +#else
 +#include <linux/platform_device.h>
- #define machine_is_compatible(x) (0)
++#define of_machine_is_compatible(x) (0)
 +#endif
  
  #if defined (CONFIG_SERIAL_PMACZILOG_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
  #define SUPPORT_SYSRQ
@@@ -2145,10 -2031,10 +2145,10 @@@ static int __init pmz_console_setup(str
  	/*
  	 * XServe's default to 57600 bps
  	 */
- 	if (machine_is_compatible("RackMac1,1")
- 	    || machine_is_compatible("RackMac1,2")
- 	    || machine_is_compatible("MacRISC4"))
+ 	if (of_machine_is_compatible("RackMac1,1")
+ 	    || of_machine_is_compatible("RackMac1,2")
+ 	    || of_machine_is_compatible("MacRISC4"))
 -	 	baud = 57600;
 +		baud = 57600;
  
  	/*
  	 * Check whether an invalid uart number has been specified, and
