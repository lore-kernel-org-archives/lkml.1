Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbZIKUBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbZIKUBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 16:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756353AbZIKUAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 16:00:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:65203 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280AbZIKUAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 16:00:34 -0400
Message-Id: <20090911200036.694094308@goodmis.org>
References: <20090911195849.451244684@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 15:59:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Dick Streefland <dick@streefland.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 15/15] kconfig: add missing dependency of conf to localyesconfig
Content-Disposition: inline; filename=0015-kconfig-add-missing-dependency-of-conf-to-localyesco.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There's a dependency missing.

$ make localyesconfig
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
  HOSTCC  scripts/basic/hash
using config: '/boot/config-2.6.27.25-78.2.56.fc9.x86_64'
/bin/sh: line 8: scripts/kconfig/conf: No such file or directory
make[1]: *** [localyesconfig] Error 127
make: *** [localyesconfig] Error 2

Thus the script failed to run. But the sed command that converts the '=m'
to '=y' still ran. This gives us a distro config with all modules
converted to built in!

The missing dependency was for conf for localyesconfig. This
dependency was already set for localmodconfig.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 915a39a..6d69c7c 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -43,7 +43,7 @@ localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
 	fi
 	$(Q)rm -f .tmp.config
 
-localyesconfig: $(obj)/streamline_config.pl
+localyesconfig: $(obj)/streamline_config.pl $(obj)/conf
 	$(Q)perl $< $(Kconfig) > .tmp.config
 	$(Q)sed -i s/=m/=y/ .tmp.config
 	$(Q)if [ -f .config ]; then 				\
-- 
1.6.3.3

-- 
