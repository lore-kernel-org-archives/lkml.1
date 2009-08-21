Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbZHUQwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbZHUQwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 12:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbZHUQwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 12:52:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50212 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZHUQws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 12:52:48 -0400
Date: Fri, 21 Aug 2009 12:52:48 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] kconfig: add missing dependency of conf to localyesconfig
In-Reply-To: <alpine.DEB.2.00.0908211200160.30182@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0908211251360.30182@gandalf.stny.rr.com>
References: <20090819025634.987354707@goodmis.org> <20090821143525.GH11098@elte.hu> <alpine.DEB.2.00.0908211047160.16405@gandalf.stny.rr.com> <20090821145406.GA3659@elte.hu> <alpine.DEB.2.00.0908211200160.30182@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-kconfig.git

    branch: for-next


Steven Rostedt (1):
      kconfig: add missing dependency of conf to localyesconfig

----
 scripts/kconfig/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit 48586218b6515b9bd70694e3cd8c901a6a6ee69c
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Aug 21 12:42:20 2009 -0400

    kconfig: add missing dependency of conf to localyesconfig
    
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


