Return-Path: <linux-kernel-owner+w=401wt.eu-S1763364AbXERRMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763364AbXERRMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 13:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757538AbXERRMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 13:12:25 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:60259 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760054AbXERRMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 13:12:24 -0400
X-Originating-Ip: 72.143.65.211
Date: Fri, 18 May 2007 13:11:02 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Protect include/linux/console_struct.h against multiple
 inclusion.
Message-ID: <Pine.LNX.4.64.0705181305560.30719@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Protect the header file include/linux/console_struct.h against
multiple inclusion, since not doing this causes one of the example
module programs in the Linux Kernel Module Programming Guide to fail
to build due to a bogus "redeclaration" of some structures.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/include/linux/console_struct.h b/include/linux/console_struct.h
index a461f76..e4c1f65 100644
--- a/include/linux/console_struct.h
+++ b/include/linux/console_struct.h
@@ -1,3 +1,5 @@
+#ifndef _LINUX_CONSOLE_STRUCT_H
+#define _LINUX_CONSOLE_STRUCT_H
 /*
  * console_struct.h
  *
@@ -130,3 +132,5 @@ extern void vc_SAK(struct work_struct *work);
 #define CUR_DEFAULT CUR_UNDERLINE

 #define CON_IS_VISIBLE(conp) (*conp->vc_display_fg == conp)
+
+#endif // _LINUX_CONSOLE_STRUCT_H
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
