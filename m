Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYJ2Tan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYJ2Tan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 15:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYJ2Ta3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 15:30:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56617 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbYJ2Ta2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 15:30:28 -0400
Date: Wed, 29 Oct 2008 15:30:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH] ftrace, kbuild: condense recordmcount.pl parameter code
In-Reply-To: <20081029190045.GC22105@uranus.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0810291529410.13214@gandalf.stny.rr.com>
References: <20081022184313.179487464@goodmis.org> <20081022185135.618026303@goodmis.org> <alpine.DEB.1.10.0810271337370.8006@gandalf.stny.rr.com> <20081029190045.GC22105@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sam Ravnborg pointed out that I could condense the code for the parameters of
recordmcount.pl by using an $(if ...) condition.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 scripts/Makefile.build |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

Index: linux-tip.git/scripts/Makefile.build
===================================================================
--- linux-tip.git.orig/scripts/Makefile.build	2008-10-27 15:29:01.000000000 -0400
+++ linux-tip.git/scripts/Makefile.build	2008-10-29 15:16:13.000000000 -0400
@@ -198,16 +198,10 @@ cmd_modversions =							\
 	fi;
 endif
 
-ifdef CONFIG_64BIT
-arch_bits = 64
-else
-arch_bits = 32
-endif
-
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
-cmd_record_mcount = perl $(srctree)/scripts/recordmcount.pl \
-	"$(ARCH)" "$(arch_bits)" "$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" \
-	"$(NM)" "$(RM)" "$(MV)" "$(@)";
+cmd_record_mcount = perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
+	"$(if $(CONFIG_64BIT),64,32)" \
+	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" "$(@)";
 endif
 
 define rule_cc_o_c


