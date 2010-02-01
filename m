Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab0BAUeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 15:34:18 -0500
Received: from mail.perches.com ([173.55.12.10]:1716 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821Ab0BAUeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 15:34:17 -0500
Subject: [PATCH] Warn on unnecessary spaces before quoted newlines
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org, Frans Pop <elendil@planet.nl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1265052929.25140.331.camel@Joe-Laptop.home>
References: <cover.1264967493.git.joe@perches.com>
	 <cover.1264967493.git.joe@perches.com>
	 <m2n.s.201002011906064544@fjphome.nl>
	 <201002012007.25498.elendil@planet.nl>
	 <1265052929.25140.331.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 12:34:15 -0800
Message-ID: <1265056455.25140.340.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3257d3d..4a4d55c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1383,6 +1383,11 @@ sub process {
 			WARN("line over 80 characters\n" . $herecurr);
 		}
 
+# check for spaces before a quoted newline
+		if ($rawline =~ /^.*\".*\s\\n/) {
+			WARN("unnecessary whitespace before a quoted newline\n" . $herecurr);
+		}
+
 # check for adding lines without a newline.
 		if ($line =~ /^\+/ && defined $lines[$linenr] && $lines[$linenr] =~ /^\\ No newline at end of file/) {
 			WARN("adding a line without newline at end of file\n" . $herecurr);


