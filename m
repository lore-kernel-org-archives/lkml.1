Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbZD3Xii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbZD3Xii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbZD3XiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:38:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50962 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434AbZD3Xh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:37:59 -0400
Message-Id: <20090430233757.468789683@goodmis.org>
References: <20090430233642.333097165@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 30 Apr 2009 19:36:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>
Subject: [PATCH 1/2] kconfig: unset IKCONFIG_PROC and clean up nesting
Content-Disposition: inline; filename=0001-kconfig-unset-IKCONFIG_PROC-and-clean-up-nesting.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Due to cut and paste error IKCONFIG was both set and cleared.
It was suppose to be IKCONFIG_PROC to be cleared.

Also cleaned up if nesting.

[ Impact: enable IKCONFIG ]

Reported-by: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 9fa3f81..69b7c3f 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -323,7 +323,7 @@ while(<CIN>) {
 	    # enable IKCONFIG at least as a module
 	    print "CONFIG_IKCONFIG=m\n";
 	    # don't ask about PROC
-	    print "# CONFIG_IKCONFIG is not set\n";
+	    print "# CONFIG_IKCONFIG_PROC is not set\n";
 	} else {
 	    print;
 	}
@@ -333,15 +333,12 @@ while(<CIN>) {
     if (/^(CONFIG.*)=(m|y)/) {
 	if (defined($configs{$1})) {
 	    $setconfigs{$1} = $2;
-	    print;
 	} elsif ($2 eq "m") {
 	    print "# $1 is not set\n";
-	} else {
-	    print;
+	    next;
 	}
-    } else {
-	print;
     }
+    print;
 }
 close(CIN);
 
-- 
1.6.2.1

-- 
