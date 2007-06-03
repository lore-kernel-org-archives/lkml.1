Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822AbXFCUfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbXFCUfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbXFCUfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:35:12 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51490 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbXFCUfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:35:10 -0400
Date: Sun, 3 Jun 2007 22:36:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Cc: sam@ravnborg.org
Subject: kbuild update
Message-ID: <20070603203611.GA8834@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Short intro to content of kbuild.git at the moment.
See http://git.kernel.org/?p=linux/kernel/git/sam/kbuild.git;a=summary

Everything are targeted for next merge window.

section mismatch
      kbuild: make better section mismatch reports on i386, arm and mips
      kbuild: The .paravirtprobe section is obsolete, so modpost doesn't need to handle it
      kbuild: ignore section mismatch warnings originating from .note section
      kbuild: refactor code in modpost to improve maintainability
      kbuild: warn about references from .init.text to .exit.text
      kbuild: remove hardcoded apic_es7000 from modpost
      kbuild: refactor code in modpost
      kbuild: remove hardcoded _logo names from modpost
      kbuild: suppress modpost warnings for references from the .toc section as used by powerpc
      kbuild: whitelist references from variables named _timer to .init.text

Several changes to either improve reporting - or to ignore false positives.
In particular modpost now check for and warn about references from .init.text to .exit.text
This check caugth several real bugs - which for the most part are already fixed in upstream.
modpost now does a better job finding the symbols using addend - this works for me
but had caused troubles in the past. If modpost suddenly bails out with a segmentation
violation this may the the culprint.
In addition some trivial code refactoring was done to improve maintainability of modpost.


      kconfig: use POSIX equality test in check-lxdialog.sh
Bugfix.


      scripts: Make cleanfile/cleanpatch warn about long lines
Improved so we all adhere to 80 lines (in)sanity


      kbuild: avoid environment to set variables used by kbuild
I had a report that a user tried to do:
EXTRA_CFLAGS=FOO make fs/nfs/
This is not supposed to impact the build so make sure it does not.


      kbuild: add support for reading stdin with gen_init_cpio
      kbuild: add support for squashing uid/gid in gen_initramfs_list.sh
initramfs improvements


      kbuild: asm-offsets.h is now cleaned with O=.. builds
Bugfix


      kbuild: document cc-fullversion
      kbuild: New 'cc-fullversion' macro
      powerpc: Refuse to build 64-bit with GCC-4.2.0 and CONFIG_MODULES
Add and use cc-fullversion to obtain exact gcc version
See documentation in Documentation/kbuild/makefiles.txt


What's next?
-> davem has requested to add a new section used for code modifying support.
   The actual section name to use needs to be sorted out.
-> A few cygwin specific changes may hit kbuild - to allow the kernel to be built
   using cygwin on a windoze box.
-> A few trivial kconfig changes are pending. Needs to review them before they are ready.
-> A speed-up of headers_check is in the works. Got stalled but will look into it soon.
   The check goes down to ~3 sec on my not-so-fast machine
-> If I get really bored I may start a 'cleaning up all vmlinux.lds files' round.
   If someone would help out here it would be appreciated.
   These change will then be merged via the arch-maintaines and not really kbuild stuff..

	Sam
