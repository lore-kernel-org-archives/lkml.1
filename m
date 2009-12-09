Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbZLIJGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbZLIJGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZLIJGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:06:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48739 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZLIJGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:06:38 -0500
Date: Wed, 9 Dec 2009 10:06:39 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: pass upstream rev to scripts/get_maintainer.pl
Message-ID: <20091209090639.GA23236@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I often face the "problem" that get_maintainer.pl yields my name, too,
as the commits I want to send are included in HEAD.

I think the nicest fix for that would be to be able to pass an upstream
rev à la:

	scripts/get_maintainer.pl --upstream linus/master ...

.  As my knowledge of perl is quite limited I only provide you with
my quick'n'dirty patch I usually use, just to give you an idea.

Best regards
Uwe

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 81a67a4..2f27c13 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -715,7 +715,7 @@ sub recent_git_signoffs {
 	return;
     }
 
-    $cmd = "git log --since=${email_git_since} -- ${file}";
+    $cmd = "git log --since=${email_git_since} linus/master -- ${file}";
 
     $output = `${cmd}`;
     $output =~ s/^\s*//gm;
@@ -785,12 +785,12 @@ sub git_assign_blame {
 	    my $diff_start = $2;
 	    my $diff_length = $3;
 	    next if (!("$file" eq "$diff_file"));
-	    $cmd = "git blame -l -L $diff_start,+$diff_length $file";
+	    $cmd = "git blame -l -L $diff_start,+$diff_length linus/master -- $file";
 	    @commits = save_commits($cmd, @commits);
 	}
     } else {
 	if (-f $file) {
-	    $cmd = "git blame -l $file";
+	    $cmd = "git blame -l linus/master -- $file";
 	    @commits = save_commits($cmd, @commits);
 	}
     }

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
