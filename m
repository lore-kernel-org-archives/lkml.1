Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYAOJsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYAOJsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 04:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYAOJsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 04:48:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58615 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbYAOJso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 04:48:44 -0500
Message-ID: <478C80B3.4060106@cn.fujitsu.com>
Date: Tue, 15 Jan 2008 17:45:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: apw@shadowen.org
CC: Randy Dunlap <rdunlap@xenotime.net>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH][try #2] checkpatch: clear the report buffer after processing
 a file
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When checking multiple files, the report buffer is not cleared
after processing a file, thus the report will be printed again
and again, mixing up with other reports.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 scripts/checkpatch.pl |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 579f50f..a88f7a1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -624,16 +624,15 @@ sub possible {
 
 my $prefix = '';
 
-my @report = ();
 sub report {
 	my $line = $prefix . $_[0];
 
 	$line = (split('\n', $line))[0] . "\n" if ($terse);
 
-	push(@report, $line);
+	push(our @report, $line);
 }
 sub report_dump {
-	@report;
+	our @report;
 }
 sub ERROR {
 	report("ERROR: $_[0]\n");
@@ -670,6 +669,7 @@ sub process {
 	my $signoff = 0;
 	my $is_patch = 0;
 
+	our @report = ();
 	our $cnt_lines = 0;
 	our $cnt_error = 0;
 	our $cnt_warn = 0;
-- 
1.5.3.rc7



