Return-Path: <linux-kernel-owner+w=401wt.eu-S1759940AbZAMGNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940AbZAMGNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759279AbZAMGLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:11:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53900 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbZAMGLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:11:49 -0500
Message-Id: <20090113061147.742218543@goodmis.org>
References: <20090113061110.856268617@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 13 Jan 2009 01:11:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Shaohua Li <shaohua.li@intel.com>, ia64 <linux-ia64@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
       u.kleine-koenig@pengutronix.de, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/9] ftrace, ia64: Add recordmcount for ia64
Content-Disposition: inline; filename=0004-ftrace-ia64-Add-recordmcount-for-ia64.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

Add recordmcount for ia64.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 scripts/recordmcount.pl |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 070042b..2ded5c8 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -206,6 +206,13 @@ if ($arch eq "x86_64") {
     $alignment = 2;
     $section_type = '%progbits';
 
+} elsif ($arch eq "ia64") {
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
+    $type = "data8";
+
+    if ($is_module eq "0") {
+        $cc .= " -mconstant-gp";
+    }
 } else {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }
-- 
1.5.6.5

-- 
