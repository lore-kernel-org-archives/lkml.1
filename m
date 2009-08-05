Return-Path: <linux-kernel-owner+w=401wt.eu-S933487AbZHEDbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487AbZHEDbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 23:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933382AbZHEDbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 23:31:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59156 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933348AbZHEDbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 23:31:14 -0400
Date: Wed, 5 Aug 2009 13:31:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: manual merge of the mfd tree with the input tree
Message-Id: <20090805133106.03c8e64e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
drivers/input/misc/Kconfig between commit
4832958218f96f98009c5e01729fbe2b48c7124c ("Input: add Blackfin rotary
input driver") from the input tree and commit
f45c2fa48317249892af5b63f4b35c7c90191df3 ("input: Add support for the
WM831x ON pin") from the mfd tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/input/misc/Kconfig
index cbe21bc,c8e7d8a..0000000
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@@ -270,13 -270,14 +270,23 @@@ config INPUT_DM355EV
  	  To compile this driver as a module, choose M here: the
  	  module will be called dm355evm_keys.
  
 +config INPUT_BFIN_ROTARY
 +	tristate "Blackfin Rotary support"
 +	depends on BF54x || BF52x
 +	help
 +	  Say Y here if you want to use the Blackfin Rotary.
 +
 +	  To compile this driver as a module, choose M here: the
 +	  module will be called bfin-rotary.
 +
+ config INPUT_WM831X_ON
+ 	tristate "WM831X ON pin"
+ 	depends on MFD_WM831X
+ 	help
+ 	  Support the ON pin of WM831X PMICs as an input device
+ 	  reporting power button status.
+ 
+ 	  To compile this driver as a module, choose M here: the module
+ 	  will be called wm831x_on.
+ 
  endif
