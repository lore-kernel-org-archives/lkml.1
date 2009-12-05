Return-Path: <linux-kernel-owner+w=401wt.eu-S1757041AbZLER6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbZLER6A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 12:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbZLER56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 12:57:58 -0500
Received: from mail.perches.com ([173.55.12.10]:1032 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628AbZLER56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 12:57:58 -0500
Subject: [PATCH] scripts/checkpatch.pl: Add warning about leading
 contination tests
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       William Allen Simpson <william.allen.simpson@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Dec 2009 09:58:04 -0800
Message-ID: <1260035884.11126.58.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bc4114f..c35933a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2064,6 +2064,11 @@ sub process {
 			CHK("multiple assignments should be avoided\n" . $herecurr);
 		}
 
+# Check use of leading logical continuation tests
+		if ($line =~ /^.\s*(\|\||&&)/) {
+			WARN("Continuation logic should be at end of previous line\n" . $herecurr);
+		}
+
 ## # check for multiple declarations, allowing for a function declaration
 ## # continuation.
 ## 		if ($line =~ /^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Ident.*/ &&


