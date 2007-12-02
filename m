Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbXLBMNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbXLBMNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 07:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbXLBMM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 07:12:58 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:43926 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbXLBMM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 07:12:57 -0500
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Dec 2007 07:12:57 EST
Date: Sun, 2 Dec 2007 13:03:35 +0100
From: Christer Weinigel <christer@weinigel.se>
To: Andy Whitcroft <apw@uk.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] teach checkpatch.pl about list_for_each
Message-ID: <20071202130335.690a8daf@cw05lap>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

you seem to be the last person messing around with checkpatch.pl so I'm
addressing this to you. :-)

checkpatch complains about the following:

WARNING: no space between function name and open parenthesis '('
#520: FILE: drivers/spi/spi_s3c24xx_dma.c:478:
+       list_for_each_entry (transfer, &message->transfers, transfer_list) {

which I think is a bit bogus since it actually is a for statement in
disguise.  The following patch adds list_for_each to the list of things
that look like functions that it shouldn't complain about.

By the way, what is the consensus on lines over 80 characters?
checkpatch complains about the following:

WARNING: line over 80 characters
#762: FILE: drivers/spi/spi_s3c24xx_dma.c:720:
+       printk(KERN_INFO "S3C24xx SPI DMA driver (c) 2007 Nordnav Technologies AB\n");

I can of course break this into:

        printk(KERN_INFO "S3C24xx SPI DMA driver (c) 2007 Nordnav "
	       "Technologies AB\n");

but in my opinion that becomes more even unreadable.  Would it be
possible to add a special case so that checkpatch ignores long strings
that go beyond 80 characters?  Do you think it is a good idea?

  /Christer

Index: linux-2.6.23/scripts/checkpatch.pl
===================================================================
--- linux-2.6.23.orig/scripts/checkpatch.pl
+++ linux-2.6.23/scripts/checkpatch.pl
@@ -681,7 +681,7 @@ sub process {
 
 # check for spaces between functions and their parentheses.
 		if ($line =~ /($Ident)\s+\(/ &&
-		    $1 !~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright)$/ &&
+		    $1 !~ /^(?:if|for|while|switch|list_for_each.*|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright)$/ &&
 		    $line !~ /$Type\s+\(/ && $line !~ /^.\#\s*define\b/) {
 			WARN("no space between function name and open parenthesis '('\n" . $herecurr);
 		}
