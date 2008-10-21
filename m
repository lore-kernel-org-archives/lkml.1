Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYJUU2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYJUU2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYJUU2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:28:46 -0400
Received: from anchor-post-32.mail.demon.net ([194.217.242.90]:2677 "EHLO
	anchor-post-32.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbYJUU2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:28:46 -0400
Subject: [PATCH] block: convert ata_port_for_each_link to use a while loop
	to reduce code size
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: jgarzik@pobox.com
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 21:24:32 +0100
Message-Id: <1224620672.3110.59.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert a for loop to a while loop in the ata_port_for_each_link macros
to reduce code size.

on x86_64 size reports reduction of text size in
	libata.ko : -272 bytes
	ahci.ko   : -44 bytes

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

----
This patch is against 2.6.27 git head.

I've been running this patch on my AMD64 desktop machine for several
days & have not seen any problems.
regards
Richard


diff --git a/include/linux/libata.h b/include/linux/libata.h
index 947cf84..bbe3b9d 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1283,12 +1283,12 @@ extern struct ata_link *__ata_port_next_link(struct ata_port *ap,
 					     bool dev_only);
 
 #define __ata_port_for_each_link(link, ap) \
-	for ((link) = __ata_port_next_link((ap), NULL, false); (link); \
-	     (link) = __ata_port_next_link((ap), (link), false))
+	(link) = NULL; \
+	while (((link) = __ata_port_next_link((ap), (link), false)))
 
 #define ata_port_for_each_link(link, ap) \
-	for ((link) = __ata_port_next_link((ap), NULL, true); (link); \
-	     (link) = __ata_port_next_link((ap), (link), true))
+	(link) = NULL; \
+	while (((link) = __ata_port_next_link((ap), (link), true)))
 
 #define ata_link_for_each_dev(dev, link) \
 	for ((dev) = (link)->device; \


