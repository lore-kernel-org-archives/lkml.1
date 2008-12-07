Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbYLGSf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbYLGSf7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbYLGSbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:31:37 -0500
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:55731 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbYLGSbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:31:34 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 11/13] checkpatch: struct file_operations should normally be const
Date: Sun,  7 Dec 2008 18:30:48 +0000
Message-Id: <1228674650-24392-12-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1228674650-24392-1-git-send-email-apw@shadowen.org>
References: <1228674650-24392-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

In the general use case struct file_operations should be a const object.
Check for and warn where it is not.  As suggested by Steven and Ingo.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c39ce0b..94371f6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2509,6 +2509,11 @@ sub process {
 		if ($line =~ /^.\s*__initcall\s*\(/) {
 			WARN("please use device_initcall() instead of __initcall()\n" . $herecurr);
 		}
+# check for struct file_operations, ensure they are const.
+		if ($line =~ /\bstruct\s+file_operations\b/ &&
+		    $line !~ /\bconst\b/) {
+			WARN("struct file_operations should normally be const\n" . $herecurr);
+		}
 
 # use of NR_CPUS is usually wrong
 # ignore definitions of NR_CPUS and usage to define arrays as likely right
-- 
1.6.0.4.911.gc990

