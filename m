Return-Path: <linux-kernel-owner+w=401wt.eu-S969033AbXFHNbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969033AbXFHNbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 09:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966776AbXFHNbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 09:31:24 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:35426 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966684AbXFHNbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 09:31:23 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 8 Jun 2007 09:29:12 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Include <asm/termbits.h> from <linux/tty_driver.h>.
Message-ID: <Pine.LNX.4.64.0706080925020.24228@localhost.localdomain>
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


The header file <linux/tty_driver.h> should include <asm/termbits.h>
to pick up the definition of "struct ktermios"; otherwise, you run the
risk of seeing:

include/linux/tty_driver.h:142: warning: 'struct ktermios' \
	declared inside parameter list
include/linux/tty_driver.h:142: warning: its scope is only \
	this definition or declaration, which is probably not what you want

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  i'm *guessing* this is the solution to the above issue.


diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 85c95cd..b687174 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -123,6 +123,7 @@
 #include <linux/fs.h>
 #include <linux/list.h>
 #include <linux/cdev.h>
+#include <asm/termbits.h>

 struct tty_struct;


-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
