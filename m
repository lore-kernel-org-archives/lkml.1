Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbXHUWYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbXHUWYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 18:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbXHUWYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 18:24:38 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55854 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371AbXHUWYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 18:24:37 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, bryan.wu@analog.com
Subject: [PATCH] Add stack checking for Blackfin
Date: Tue, 21 Aug 2007 18:24:57 -0400
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708211824.58432.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simply fill out the bits in checkstack.pl for Blackfin.  I thought I already
sent this, but I don't see it in -mm anywhere ...

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Bryan Wu <bryan.wu@analog.com>
---
 scripts/checkstack.pl |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/scripts/checkstack.pl b/scripts/checkstack.pl
index f7844f6..9226381 100755
--- a/scripts/checkstack.pl
+++ b/scripts/checkstack.pl
@@ -73,6 +73,9 @@ my (@stack, $re, $x, $xs);
 		#     pair for larger users. -- PFM.
 		#a00048e0:       d4fc40f0        addi.l  r15,-240,r15
 		$re = qr/.*addi\.l.*r15,-(([0-9]{2}|[3-9])[0-9]{2}),r15/o;
+	} elsif ($arch =~ /^blackfin$/) {
+		#   0:   00 e8 38 01     LINK 0x4e0;
+		$re = qr/.*[[:space:]]LINK[[:space:]]*(0x$x{1,8})/o;
 	} else {
 		print("wrong or unknown architecture\n");
 		exit
-- 
1.5.3.rc5
