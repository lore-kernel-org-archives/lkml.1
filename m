Return-Path: <linux-kernel-owner+w=401wt.eu-S1761647AbXFQWya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761647AbXFQWya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 18:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759041AbXFQWyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 18:54:22 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49440 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757859AbXFQWyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 18:54:21 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch] make hdrscheck.sh force __asm__ in exported headers
Date: Sun, 17 Jun 2007 18:54:24 -0400
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706171854.24763.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This updates scripts/hdrschecks.sh by grepping for asm() constructs and
rejecting them in favor of __asm__() in exported headers.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/scripts/hdrcheck.sh b/scripts/hdrcheck.sh
index 3159858..33d17cc 100755
--- a/scripts/hdrcheck.sh
+++ b/scripts/hdrcheck.sh
@@ -6,5 +6,16 @@ for FILE in `grep '^[ \t]*#[ \t]*include[ \t]*<' $2 | cut -f2 -d\< | cut -f1 -d\
 	exit 1
     fi
 done
+
+# make sure we export __asm__(), not asm()
+lines=$(grep -n -E \
+	-e '\<asm[[:space:]]*(_{1,2}?volatile_{1,2}?[[:space:]]*)?\(' \
+	$2)
+if [ -n "$lines" ] ; then
+	echo "$2 should convert asm() usage to __asm__() in exported headers"
+	echo "$lines"
+	exit 1
+fi
+
 # FIXME: List dependencies into $3
 touch $3
