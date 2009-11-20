Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbZKTNur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbZKTNur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 08:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbZKTNur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 08:50:47 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:28887 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbZKTNuq convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;2:1>);
	Fri, 20 Nov 2009 08:50:46 -0500
Message-Id: <4B06ACCD02000078000211E0@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 20 Nov 2009 13:50:53 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <jason.wessel@windriver.com>
Subject: [PATCH] fix section mismatch in early ehci dbgp
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 917778267fbe67703ab7d5c6f0b7a05d4c3df485 removed __init from
ehci_wait_for_port(), but left it in place on ehci_reset_port(), which
is being called from the former function.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jason Wessel <jason.wessel@windriver.com>

---
 drivers/usb/early/ehci-dbgp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.32-rc8/drivers/usb/early/ehci-dbgp.c	2009-11-20 14:11:29.000000000 +0100
+++ 2.6.32-rc8-ehci-dbgp-section-mismatch/drivers/usb/early/ehci-dbgp.c	2009-11-20 11:23:52.000000000 +0100
@@ -613,7 +613,7 @@ err:
 }
 EXPORT_SYMBOL_GPL(dbgp_external_startup);
 
-static int __init ehci_reset_port(int port)
+static int ehci_reset_port(int port)
 {
 	u32 portsc;
 	u32 delay_time, delay;



