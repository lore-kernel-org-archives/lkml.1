Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbZJCAKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbZJCAKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 20:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbZJCAKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 20:10:03 -0400
Received: from mail.perches.com ([173.55.12.10]:1622 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331AbZJCAKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 20:10:02 -0400
Subject: [PATCH] checkpatch.pl: Allow > 80 char lines for logging functions
 not just printk
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Oct 2009 17:10:04 -0700
Message-Id: <1254528604.1799.185.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 87bbb8b..ae74ab1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -186,6 +186,14 @@ our $typeTypedefs = qr{(?x:
 	atomic_t
 )};
 
+our $logFunctions = qr{(?x:
+	printk|
+	pr_(debug|dbg|vdbg|devel|info|warning|err|notice|alert|crit|emerg|cont)|
+	dev_(printk|dbg|vdbg|info|warn|err|notice|alert|crit|emerg|WARN)|
+	WARN|
+	panic
+)};
+
 our @typeList = (
 	qr{void},
 	qr{(?:unsigned\s+)?char},
@@ -1367,7 +1375,7 @@ sub process {
 #80 column limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
 		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
-		    $line !~ /^\+\s*printk\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
+		    $line !~ /^\+\s*$logFunctions\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
 		    $length > 80)
 		{
 			WARN("line over 80 characters\n" . $herecurr);


