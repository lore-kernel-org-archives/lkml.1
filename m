Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764Ab0AVMb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab0AVMb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 07:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144Ab0AVMb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 07:31:28 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:63742 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795Ab0AVMb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 07:31:28 -0500
Subject: [PATCH] get_maintainer.pl: teach git log to use --no-color
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 12:31:24 +0000
Message-ID: <1264163484.2143.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When git has been set to always use color in .gitconfig then I get the
warning message

    	Bad divisor in main::vcs_assign: 0
    
This is caused by vcs_file_signoffs not matching any commits due to the
pattern not understand the colour codes. Fix this by telling git log to
never use colour.
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
----
patch against 2.6.33-rc5
git --version 1.6.6


diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 090f248..2cae27a 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -74,7 +74,7 @@ my %VCS_cmds;
 my %VCS_cmds_git = (
     "execute_cmd" => \&git_execute_cmd,
     "available" => '(which("git") ne "") && (-d ".git")',
-    "find_signers_cmd" => "git log --since=\$email_git_since -- \$file",
+    "find_signers_cmd" => "git log --no-color --since=\$email_git_since -- \$file",
     "find_commit_signers_cmd" => "git log -1 \$commit",
     "blame_range_cmd" => "git blame -l -L \$diff_start,+\$diff_length \$file",
     "blame_file_cmd" => "git blame -l \$file",


