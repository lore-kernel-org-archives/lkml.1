Return-Path: <linux-kernel-owner+w=401wt.eu-S1761870AbZAHS6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761870AbZAHS6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 13:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZAHS6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 13:58:39 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:37315 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZAHS6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 13:58:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc
         :disposition-notification-to:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=n5bw5FEfvd5MxfAkUZ73YYdNpMAB24+Yw7vtn6w5oTb0wte54MI34CwJFAJrarFRlH
         XlQ/+suA7/J/KMwaUBaRV0+kihgNo0iLFwpE0iwo5tfCFA6AAhh4+sLwOx+gmR+82Wqq
         xET3Zp5rW9MEm4vHdRMhjdjs67oFrsVQPI4B4=
From: Leonardo Potenza <lpotenza@inwind.it>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH] net: fix section mismatch warnings in dccp/ccids/lib/tfrc.c
Date: Thu, 8 Jan 2009 19:57:03 +0100
User-Agent: KMail/1.9.9
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901081957.03413.lpotenza@inwind.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leonardo Potenza <lpotenza@inwind.it>

Removed the __exit annotation of tfrc_lib_exit(), in order to suppress the following section mismatch messages:

WARNING: net/dccp/dccp.o(.text+0xd9): Section mismatch in reference from the function ccid_cleanup_builtins() to the function .exit.text:tfrc_lib_exit()
The function ccid_cleanup_builtins() references a function in an exit section.
Often the function tfrc_lib_exit() has valid usage outside the exit section
and the fix is to remove the __exit annotation of tfrc_lib_exit.

WARNING: net/dccp/dccp.o(.init.text+0x48): Section mismatch in reference from the function ccid_initialize_builtins() to the function .exit.text:tfrc_lib_exit()
The function __init ccid_initialize_builtins() references
a function __exit tfrc_lib_exit().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
tfrc_lib_exit() so it may be used outside an exit section.

Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>
---
Index: linux-2.6/net/dccp/ccids/lib/tfrc.c
===================================================================
--- linux-2.6.orig/net/dccp/ccids/lib/tfrc.c	2009-01-08 19:19:50.000000000 +0100
+++ linux-2.6/net/dccp/ccids/lib/tfrc.c	2009-01-08 19:20:07.000000000 +0100
@@ -36,7 +36,7 @@ out:
 	return rc;
 }
 
-void __exit tfrc_lib_exit(void)
+void tfrc_lib_exit(void)
 {
 	tfrc_rx_packet_history_exit();
 	tfrc_tx_packet_history_exit();
