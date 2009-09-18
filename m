Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294AbZIRCJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbZIRCJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 22:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZIRCJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 22:09:40 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:38439 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZIRCJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 22:09:40 -0400
Subject: [Patch] AMD64_EDAC:  simple fix to allow better report on ECE CE
	errors
From: Keith Mannthey <kmannth@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: borislav.petkov@amd.com, dougthompson@xmission.com
Content-Type: text/plain
Date: Thu, 17 Sep 2009 19:09:39 -0700
Message-Id: <1253239779.7263.111.camel@keith-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tested 2.6.31 and the mainline amd64_edac driver. This is was the
first simple fix.  

This allows the errors to be further decoded and mapped to csrows. 
Tested with ECC debug dimms and an Rev F cpu based system. 

Submitted-by:  Keith Mannthey<kmannth@us.ibm.com>
--- 

diff -urN linux-2.6.31/drivers/edac/amd64_edac.c linux-2.6.31-fixed/drivers/edac/amd64_edac.c
--- linux-2.6.31/drivers/edac/amd64_edac.c	2009-09-09 15:13:59.000000000 -0700
+++ linux-2.6.31-fixed/drivers/edac/amd64_edac.c	2009-09-17 22:32:09.000000000 -0700
@@ -1136,7 +1138,7 @@
 	 * different from the node that detected the error.
 	 */
 	src_mci = find_mc_by_sys_addr(mci, SystemAddress);
-	if (src_mci) {
+	if (!src_mci) {
 		amd64_mc_printk(mci, KERN_ERR,
 			     "failed to map error address 0x%lx to a node\n",
 			     (unsigned long)SystemAddress);


