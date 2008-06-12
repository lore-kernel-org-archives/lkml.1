Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbYFLM0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbYFLM0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759047AbYFLM0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:26:30 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4172 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759013AbYFLM03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:26:29 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/23] checkpatch: usb_free_urb() can take NULL
Date: Thu, 12 Jun 2008 13:05:54 +0100
Message-Id: <1213272362-19457-16-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

usb_free_urb() can take a NULL, so let's check and warn about that.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 13d7a33..a4e8087 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2078,6 +2078,13 @@ sub process {
 				WARN("kfree(NULL) is safe this check is probabally not required\n" . $hereprev);
 			}
 		}
+# check for needless usb_free_urb() checks
+		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
+			my $expr = $1;
+			if ($line =~ /\busb_free_urb\(\Q$expr\E\);/) {
+				WARN("usb_free_urb(NULL) is safe this check is probably not required\n" . $hereprev);
+			}
+		}
 
 # warn about #ifdefs in C files
 #		if ($line =~ /^.\s*\#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
-- 
1.5.6.rc0.140.ga9675

