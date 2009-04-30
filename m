Return-Path: <linux-kernel-owner+w=401wt.eu-S1761263AbZD3DUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761263AbZD3DUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 23:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbZD3DTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 23:19:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41628 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZD3DTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 23:19:46 -0400
Message-Id: <20090430030821.523327994@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 29 Apr 2009 23:08:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 0/3] removing unwanted module configs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it has been brought up last Kernel Summit, we want to make it easier
for those that report bugs to build their own kernels, and maybe even
bisect with git.  Some of these people are not programmers and do not
understand the complexity of the configuration options. But to compile
a distribution configured kernel on their boxes can take hours.

This patch series comes to the rescue. I wrote the first instance of
streamline config when I bought a new box in 2005 and got frustrated
with finding all the necessary configurations to boot it. It is a
small (yet powerful) perl script.

Here's what it does:

 * Reads the modules that are load by using lsmod.
 * Reads all Makefiles to map modules to CONFIG_* options
 * Reads the Kconfig files to find dependencies and selects
 * Figures out what CONFIGS are needed to compile the loaded modules
 * Reads the .config and prints out a version with all module configurations
    that not needed, disabled.

The next two patches add options to make.

 localmodconfig - this will run streamline_config.pl on the .config file
	and replace it at the end.

 localyesconfig - this will do the same as localmodconfig but will also
	sed -i s/=m/=y/  to turn all modules to core. It will also run
	the 'make oldcondfig' to fix it up and let the user handle
	andything that was changed by converting a module to core.

Anyway, this is now in git and as a series of patches here. My git tree
is based off of the latest Linus git tree.

Have fun!

-- Steve



The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: kconfig


Steven Rostedt (3):
      kconfig: add streamline_config.pl to scripts
      kconfig: make localmodconfig to run streamline_config.pl
      kconfig: add make localyesconfig option

----
 scripts/kconfig/Makefile             |   24 +++-
 scripts/kconfig/streamline_config.pl |  291 ++++++++++++++++++++++++++++++++++
 2 files changed, 314 insertions(+), 1 deletions(-)
-- 
