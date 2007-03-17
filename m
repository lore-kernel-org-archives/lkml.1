Return-Path: <linux-kernel-owner+w=401wt.eu-S1750945AbXCQGg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945AbXCQGg6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 02:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbXCQGg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 02:36:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57617 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbXCQGg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 02:36:57 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>, zippel@linux-m68k.org
Subject: [patch] dont use obsolete index() function in lxdialog
Date: Sat, 17 Mar 2007 02:37:07 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703170237.07934.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The index() function is obsolete, use strchr() instead.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
--- a/scripts/kconfig/lxdialog/util.c
+++ b/scripts/kconfig/lxdialog/util.c
@@ -336,7 +336,7 @@
 		newl = 1;
 		word = tempstr;
 		while (word && *word) {
-			sp = index(word, ' ');
+			sp = strchr(word, ' ');
 			if (sp)
 				*sp++ = 0;
 
@@ -348,7 +348,7 @@
 			if (wlen > room ||
 			    (newl && wlen < 4 && sp
 			     && wlen + 1 + strlen(sp) > room
-			     && (!(sp2 = index(sp, ' '))
+			     && (!(sp2 = strchr(sp, ' '))
 				 || wlen + 1 + (sp2 - sp) > room))) {
 				cur_y++;
 				cur_x = x;
