Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbZCYWDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbZCYWDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 18:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbZCYWDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 18:03:42 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:41940 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbZCYWDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 18:03:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=wwB3Q3vBOVCXk0xvSMLB8TRyuBl5hdk0bEhJ5EHYuEmaOzUPxeLW/WKA1DGxz85Rd8
         o1PPDqobuDSd07mAgPmxpn6SX3xWotebNrFgGLT4+dDBSvOG2XiO17LFUJ37u0LNya+t
         Y1rZJAu4WFdoJTf+qcopB9Yzs++Ha4ORVUpEo=
Date: Wed, 25 Mar 2009 23:03:28 +0100 (CET)
From: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
X-X-Sender: frans@linux-suse.site
To: drzeus-mmc@drzeus.cx
cc: linux-kernel@vger.kernel.org, beagleboard@googlegroups.com,
       openembedded-devel@openembedded.org, linux-omap@vger.kernel.org
Subject: [PATCH] drivers/mmc/core/core.c: extend limit
Message-ID: <alpine.LNX.2.00.0903252248430.32070@linux-suse.site>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For some reason my 4GB Kingston SDHC class 6 cards stopped functioning 
properly with 2.6.28 on my beagleboard (arm based). The very same cards (I 
have two of them) worked properly with 2.6.27. What happened was that if I 
booted from the card I would get errors -110.
They are similar to the ones reported at lkml last sept in 
http://lkml.org/lkml/2008/9/23/390

Fortunately later on in this thread was a fix:
http://lkml.org/lkml/2008/10/20/124

This did not help me as the limit was already at 300000. However, I 
decided to raise the limit to 500000. Still no go so I also doubled the 
read limit from 100000 to 200000. After that the cards work without 
problem. Changing the write timing back to 300000 brought the problem back 
so apparently both timings need to be extended. Attached is the patch I 
used for this. As it is a timeout limit value, it should not harm anyone, 
and a longer timeout at least allows more cards to be used.

Signed-off-by: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
---

What somewhat troubles me is that this worked in .27, so it might be this 
patch does not address the root cause. Then again this is the best I can 
do. If someone has a better solution, I am more than happy to test it.

Frans.

Index: git/drivers/mmc/core/core.c
===================================================================
--- git.orig/drivers/mmc/core/core.c
+++ git/drivers/mmc/core/core.c
@@ -284,9 +284,9 @@ void mmc_set_data_timeout(struct mmc_dat
 			 * The limit is really 250 ms, but that is
 			 * insufficient for some crappy cards.
 			 */
-			limit_us = 300000;
+			limit_us = 500000;
 		else
-			limit_us = 100000;
+			limit_us = 200000;

 		/*
 		 * SDHC cards always use these fixed values.
