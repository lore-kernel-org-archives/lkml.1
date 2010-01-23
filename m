Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760Ab0AWOsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab0AWOsh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 09:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756Ab0AWOsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 09:48:36 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:42613 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675Ab0AWOsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 09:48:35 -0500
Subject: Re: [PATCH] get_maintainer.pl: teach git log to use --no-color --
 UPDATED
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1264191393.32383.128.camel@Joe-Laptop.home>
References: <1264163484.2143.13.camel@localhost>
	 <1264191393.32383.128.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Jan 2010 14:48:33 +0000
Message-ID: <1264258113.2860.7.camel@localhost>
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

Updated to fix both calls to 'git log' as requested by Joe Perches
<joe@perches.com>

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

----
patch against 2.6.33-rc5
git --version 1.6.6

Hi Joe, 
will this do? 

regards
Richard


diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 090f248..2f3230d 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -74,8 +74,8 @@ my %VCS_cmds;
 my %VCS_cmds_git = (
     "execute_cmd" => \&git_execute_cmd,
     "available" => '(which("git") ne "") && (-d ".git")',
-    "find_signers_cmd" => "git log --since=\$email_git_since -- \$file",
-    "find_commit_signers_cmd" => "git log -1 \$commit",
+    "find_signers_cmd" => "git log --no-color --since=\$email_git_since -- \$file",
+    "find_commit_signers_cmd" => "git log --no-color -1 \$commit",
     "blame_range_cmd" => "git blame -l -L \$diff_start,+\$diff_length \$file",
     "blame_file_cmd" => "git blame -l \$file",
     "commit_pattern" => "^commit [0-9a-f]{40,40}",


