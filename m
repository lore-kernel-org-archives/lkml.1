Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbZFEJ0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbZFEJ0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZFEJ0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:26:37 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:48560 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbZFEJ0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:26:36 -0400
Date: Fri, 5 Jun 2009 11:26:37 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Pierre Ossman <pierre@ossman.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.29.4] Driver for CB710/720 memory card reader (MMC
	part) - v5 fixed
Message-ID: <20090605092637.GA30315@rere.qmqm.pl>
References: <20081029141146.GA17741@rere.qmqm.pl> <20081114220658.38f0645c@mjolnir.drzeus.cx> <20090201185435.GA9165@rere.qmqm.pl> <20090221134603.6bc3c385@mjolnir.ossman.eu> <20090508151622.GA23006@rere.qmqm.pl> <20090522132755.144efcca@mjolnir.ossman.eu> <20090522175501.GA673@rere.qmqm.pl> <20090522183359.GA3567@rere.qmqm.pl> <20090527221342.3a1ba44d@mjolnir.ossman.eu> <20090604102455.GA32296@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090604102455.GA32296@rere.qmqm.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cb710: Fix compilation warnings

Fix compilation warnings reported by Stephen Rothwell and change
the only dev_vdbg() to dev_dbg().

drivers/misc/cb710/debug.c: In function 'cb710_read_regs_8':                                                           
drivers/misc/cb710/debug.c:100: warning: suggest parentheses around operand of '!' or change '&' to '&&' or '!' to '~' 
drivers/misc/cb710/debug.c: In function 'cb710_read_regs_16':                                                          
drivers/misc/cb710/debug.c:101: warning: suggest parentheses around operand of '!' or change '&' to '&&' or '!' to '~' 
drivers/misc/cb710/debug.c: In function 'cb710_read_regs_32':                                                          
drivers/misc/cb710/debug.c:102: warning: suggest parentheses around operand of '!' or change '&' to '&&' or '!' to '~' 
drivers/mmc/host/cb710-mmc.c: In function 'cb710_mmc_set_transfer_size':                                               
drivers/mmc/host/cb710-mmc.c:222: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'            
drivers/mmc/host/cb710-mmc.c:222: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'            

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

diff -urpN test2/drivers/misc/cb710/debug.c test3/drivers/misc/cb710/debug.c
--- test2/drivers/misc/cb710/debug.c	2009-06-04 10:53:34.000000000 +0200
+++ test3/drivers/misc/cb710/debug.c	2009-06-05 11:22:38.000000000 +0200
@@ -37,7 +37,7 @@ static void cb710_read_regs_##t(void __i
 	unsigned i, j;							\
 									\
 	for (i = 0; i < ARRAY_SIZE(allow); ++i, reg += 16/(t/8)) {	\
-		if (!select & (1 << i))					\
+		if (!(select & (1 << i)))				\
 			continue;					\
 									\
 		for (j = 0; j < 0x10/(t/8); ++j) {			\
diff -urpN test2/drivers/mmc/host/cb710-mmc.c test3/drivers/mmc/host/cb710-mmc.c
--- test2/drivers/mmc/host/cb710-mmc.c	2009-06-04 10:53:34.000000000 +0200
+++ test3/drivers/mmc/host/cb710-mmc.c	2009-06-05 11:22:39.000000000 +0200
@@ -219,7 +219,7 @@ static void cb710_mmc_set_transfer_size(
 	cb710_write_port_32(slot, CB710_MMC_TRANSFER_SIZE_PORT,
 		((count - 1) << 16)|(blocksize - 1));
 
-	dev_vdbg(cb710_slot_dev(slot), "set up for %d block%s of %d bytes\n",
+	dev_dbg(cb710_slot_dev(slot), "set up for %Zu block%s of %Zu bytes\n",
 		count, count == 1 ? "" : "s", blocksize);
 }
 
