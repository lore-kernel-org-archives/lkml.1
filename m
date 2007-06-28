Return-Path: <linux-kernel-owner+w=401wt.eu-S1764875AbXF1RvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764875AbXF1RvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 13:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758581AbXF1Ruz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 13:50:55 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:32726 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbXF1Ruz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 13:50:55 -0400
Date: Thu, 28 Jun 2007 10:51:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] scripts/decodecode: fix for /bin/sh
Message-Id: <20070628105137.bf5e5607.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Convert substring expressions to be sh-compatible.

Tested by Arne Georg Gleditsch <argggh@dolphinics.no>

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/decodecode |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.22-rc6-mm1.orig/scripts/decodecode
+++ linux-2.6.22-rc6-mm1/scripts/decodecode
@@ -28,7 +28,7 @@ if [ $marker -eq 0 ]; then
 fi
 
 if [ $marker -ne 0 ]; then
-	beforemark=${code:0:$((marker - 1))}
+	beforemark=`echo "$code" | cut -c-$((${marker} - 1))`
 	echo -n "	.byte 0x" > $T.s
 	echo $beforemark | sed -e 's/ /,0x/g' >> $T.s
 	as -o $T.o $T.s
@@ -36,7 +36,7 @@ if [ $marker -ne 0 ]; then
 	rm $T.o $T.s
 
 # and fix code at-and-after marker
-	code=${code:$marker}
+	code=`echo "$code" | cut -c$((${marker} + 1))-`
 fi
 
 code=`echo $code | sed -e 's/ [<(]/ /;s/[>)] / /;s/ /,0x/g'`
