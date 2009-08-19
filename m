Return-Path: <linux-kernel-owner+w=401wt.eu-S1752170AbZHSDBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbZHSDBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 23:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZHSDAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 23:00:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45391 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbZHSDAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 23:00:38 -0400
Message-Id: <20090819030039.080007250@goodmis.org>
References: <20090819025634.987354707@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 18 Aug 2009 22:56:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 11/14] kconfig: unset IKCONFIG_PROC and clean up nesting
Content-Disposition: inline; filename=0011-kconfig-unset-IKCONFIG_PROC-and-clean-up-nesting.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Due to cut and paste error IKCONFIG was both set and cleared.
It was suppose to be IKCONFIG_PROC to be cleared.

Also cleaned up if nesting.

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
1.6.3.3

-- 
