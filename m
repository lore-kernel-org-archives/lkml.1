Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbXBDPrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbXBDPrl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 10:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbXBDPrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 10:47:41 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:47708 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbXBDPrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 10:47:40 -0500
X-Originating-Ip: 74.109.98.130
Date: Sun, 4 Feb 2007 10:46:33 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, jack@suse.cz
Subject: [PATCH] QUOTA: Have <linux/quota.h> include <linux/rwsem.h> explicitly.
Message-ID: <Pine.LNX.4.64.0702041021310.20978@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.646, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, TW_DQ 0.08, TW_RW 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Since quota.h declares a R/W semaphore, it should include rwsem.h
explicitly.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  No, this doesn't fix an *existing* problem, but it's necessary for
an upcoming patch which will remove all includes of <linux/rwsem.h>
from all the semaphore.h files.

  As I read it, since R/W semaphores have their own header file,
there's no rationale for the regular semaphore header files to have
that include statement, so any header file that's been happily picking
up the rwsem header file by accident (via semaphore.h) should be fixed
this way.

  quota.h appears to be the only file that has this issue building on
x86 with "make allyesconfig".


diff --git a/include/linux/quota.h b/include/linux/quota.h
index b8fbf26..77db80a 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -132,6 +132,7 @@ struct if_dqinfo {

 #ifdef __KERNEL__
 #include <linux/spinlock.h>
+#include <linux/rwsem.h>
 #include <linux/mutex.h>

 #include <linux/dqblk_xfs.h>

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
