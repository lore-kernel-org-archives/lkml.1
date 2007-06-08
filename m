Return-Path: <linux-kernel-owner+w=401wt.eu-S1030525AbXFHNQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030525AbXFHNQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 09:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937395AbXFHNQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 09:16:30 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:34607 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936937AbXFHNQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 09:16:29 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 8 Jun 2007 09:14:25 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Protect <linux/console_struct.h> from multiple inclusion.
Message-ID: <Pine.LNX.4.64.0706080911520.23230@localhost.localdomain>
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


Prevent <linux/console_struct.h> from being included more than once,
otherwise you get a redefinition error if you happen to include
<linux/vt_kern.h> first.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  any chance of pushing this one through expeditiously?

diff --git a/include/linux/console_struct.h b/include/linux/console_struct.h
index a461f76..dc77fed 100644
--- a/include/linux/console_struct.h
+++ b/include/linux/console_struct.h
@@ -9,6 +9,9 @@
  * to achieve effects such as fast scrolling by changing the origin.
  */

+#ifndef _LINUX_CONSOLE_STRUCT_H
+#define _LINUX_CONSOLE_STRUCT_H
+
 #include <linux/wait.h>
 #include <linux/vt.h>
 #include <linux/workqueue.h>
@@ -130,3 +133,5 @@ extern void vc_SAK(struct work_struct *work);
 #define CUR_DEFAULT CUR_UNDERLINE

 #define CON_IS_VISIBLE(conp) (*conp->vc_display_fg == conp)
+
+#endif /* _LINUX_CONSOLE_STRUCT_H */
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
