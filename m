Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbYDYEKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbYDYEKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 00:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYDYEKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 00:10:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49959 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbYDYEKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 00:10:11 -0400
Date: Thu, 24 Apr 2008 21:10:06 -0700
Message-Id: <200804250410.m3P4A67w019427@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 24/24] Use U64_C() instead of casts in kernel/time.c
In-reply-to: <1FE6DD409037234FAB833C420AA843EC012F9FDA@orsmsx424.amr.corp.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com>
	<1209078352-7593-2-git-send-email-hpa@zytor.com>
	<1209078352-7593-3-git-send-email-hpa@zytor.com>
	<1209078352-7593-4-git-send-email-hpa@zytor.com>
	<1209078352-7593-5-git-send-email-hpa@zytor.com>
	<1209078352-7593-6-git-send-email-hpa@zytor.com>
	<1209078352-7593-7-git-send-email-hpa@zytor.com>
	<1209078352-7593-8-git-send-email-hpa@zytor.com>
	<1209078352-7593-9-git-send-email-hpa@zytor.com>
	<1209078352-7593-10-git-send-email-hpa@zytor.com>
	<1209078352-7593-11-git-send-email-hpa@zytor.com>
	<1209078352-7593-12-git-send-email-hpa@zytor.com>
	<1209078352-7593-13-git-send-email-hpa@zytor.com>
	<1209078352-7593-14-git-send-email-hpa@zytor.com>
	<1209078352-7593-15-git-send-email-hpa@zytor.com>
	<1209078352-7593-16-git-send-email-hpa@zytor.com>
	<1209078352-7593-17-git-send-email-hpa@zytor.com>
	<1209078352-7593-18-git-send-email-hpa@zytor.com>
	<1FE6DD409037234FAB833C420AA843EC012F9FDA@orsmsx424.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new U64_C() constructor macro instead of using casts for
constants in kernel/time.c.  This avoids warnings with some gcc
versions.

Note that since pasting has priority over macro resolution, the header
file generation is modified to have suffixed versions of all the
generated values.

This resolves Bugzilla 10153.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 kernel/time.c       |    8 ++++----
 kernel/timeconst.pl |   21 ++++++++++++++++-----
 2 files changed, 20 insertions(+), 9 deletions(-)

This is the corrected version of this patch.  My apologies.
The git repository has also been corrected:

git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-inttypes.git

diff --git a/kernel/time.c b/kernel/time.c
index 35d373a..652fd4f 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -244,7 +244,7 @@ unsigned int inline jiffies_to_msecs(const unsigned long j)
 	return (j + (HZ / MSEC_PER_SEC) - 1)/(HZ / MSEC_PER_SEC);
 #else
 # if BITS_PER_LONG == 32
-	return ((u64)HZ_TO_MSEC_MUL32 * j) >> HZ_TO_MSEC_SHR32;
+	return (U64_C(HZ_TO_MSEC_MUL32) * j) >> HZ_TO_MSEC_SHR32;
 # else
 	return (j * HZ_TO_MSEC_NUM) / HZ_TO_MSEC_DEN;
 # endif
@@ -260,7 +260,7 @@ unsigned int inline jiffies_to_usecs(const unsigned long j)
 	return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
 #else
 # if BITS_PER_LONG == 32
-	return ((u64)HZ_TO_USEC_MUL32 * j) >> HZ_TO_USEC_SHR32;
+	return (U64_C(HZ_TO_USEC_MUL32) * j) >> HZ_TO_USEC_SHR32;
 # else
 	return (j * HZ_TO_USEC_NUM) / HZ_TO_USEC_DEN;
 # endif
@@ -470,7 +470,7 @@ unsigned long msecs_to_jiffies(const unsigned int m)
 	if (HZ > MSEC_PER_SEC && m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
 		return MAX_JIFFY_OFFSET;
 
-	return ((u64)MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
+	return (U64_C(MSEC_TO_HZ_MUL32) * m + U64_C(MSEC_TO_HZ_ADJ32))
 		>> MSEC_TO_HZ_SHR32;
 #endif
 }
@@ -485,7 +485,7 @@ unsigned long usecs_to_jiffies(const unsigned int u)
 #elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
 	return u * (HZ / USEC_PER_SEC);
 #else
-	return ((u64)USEC_TO_HZ_MUL32 * u + USEC_TO_HZ_ADJ32)
+	return (U64_C(USEC_TO_HZ_MUL32) * u + U64_C(USEC_TO_HZ_ADJ32))
 		>> USEC_TO_HZ_SHR32;
 #endif
 }
diff --git a/kernel/timeconst.pl b/kernel/timeconst.pl
index 4146803..6212498 100644
--- a/kernel/timeconst.pl
+++ b/kernel/timeconst.pl
@@ -1,7 +1,7 @@
 #!/usr/bin/perl
 # -----------------------------------------------------------------------
 #
-#   Copyright 2007 rPath, Inc. - All Rights Reserved
+#   Copyright 2007-2008 rPath, Inc. - All Rights Reserved
 #
 #   This file is part of the Linux kernel, and is made available under
 #   the terms of the GNU General Public License version 2 or (at your
@@ -318,6 +318,19 @@ sub compute_values($) {
 	return @val;
 }
 
+# Create defines for a value, including variants with all appropriate
+# suffixes.  The suffixed versions also allow pasted constructs like
+# U64_C(HZ_TO_MSEC_MUL32) to work correctly.
+sub outputval($$)
+{
+	my($name, $val) = @_;
+	my $csuf;
+
+	foreach $csuf ('', 'U', 'L', 'UL', 'LL', 'ULL') {
+		printf "#define %-23s %s\n", $name.$csuf, $val.$csuf;
+	}
+}
+
 sub output($@)
 {
 	my($hz, @val) = @_;
@@ -342,13 +355,11 @@ sub output($@)
 		      'HZ_TO_USEC','USEC_TO_HZ') {
 		foreach $bit (32, 64) {
 			foreach $suf ('MUL', 'ADJ', 'SHR') {
-				printf "#define %-23s %s\n",
-					"${pfx}_$suf$bit", shift(@val);
+				outputval("${pfx}_$suf$bit", shift(@val));
 			}
 		}
 		foreach $suf ('NUM', 'DEN') {
-			printf "#define %-23s %s\n",
-				"${pfx}_$suf", shift(@val);
+			outputval("${pfx}_$suf", shift(@val));
 		}
 	}
 
-- 
1.5.4.1

