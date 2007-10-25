Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbXJYVLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbXJYVLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbXJYVLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:11:15 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:45148 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbXJYVLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:11:14 -0400
Date: Thu, 25 Oct 2007 23:12:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [GIT PULL] kill i386 and x86_64 directories
Message-ID: <20071025211249.GA15078@uranus.ravnborg.org>
References: <20071025195644.GA14501@uranus.ravnborg.org> <alpine.LFD.0.9999.0710252212420.3186@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0710252212420.3186@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

This patch serie kill the old i386 and x86_64 directories.
Introducing a few trivial changes in top-level Makefile
and kconfig Makefile allows us to move all files to
arch/x86/ where they belong.

Kay Sievers hit a bug in the first patch-set - this is now fixed and
the updated patch set is uploaded to my x86.git tree.
Build tested on both i386 and x86_64.
I test builded a few other archs just to check that I did not break them.

Shortlog:

Randy Dunlap (1):
      x86: unification of i386 and x86_64 Kconfig.debug

Sam Ravnborg (5):
      x86: move i386 and x86_64 Makefiles to arch/x86
      x86: move defconfig files for i386 and x86_64 to x86
      kconfig: small code refactoring in kconfig Makefile
      x86: move i386 and x86_64 Kconfig files to x86 directory
      x86: kill the old i386 and x86_64 directories

diffstat:

 Makefile                                           |    7 ++-
 arch/i386/.gitignore                               |    1 -
 arch/{i386 => x86}/Kconfig.cpu                     |    0 
 arch/{i386 => x86}/Kconfig.debug                   |   51 +++++++++++++---
 arch/{i386/Kconfig => x86/Kconfig.i386}            |    4 +-
 arch/{x86_64/Kconfig => x86/Kconfig.x86_64}        |    2 +-
 arch/x86/Makefile                                  |   16 +++++
 arch/{i386/Makefile => x86/Makefile_32}            |    7 +--
 arch/{i386/Makefile.cpu => x86/Makefile_32.cpu}    |    0 
 arch/{x86_64/Makefile => x86/Makefile_64}          |    5 +-
 .../{i386/defconfig => x86/configs/i386_defconfig} |    0 
 .../defconfig => x86/configs/x86_64_defconfig}     |    0 
 arch/x86_64/.gitignore                             |    1 -
 arch/x86_64/Kconfig.debug                          |   61 --------------------
 scripts/kconfig/Makefile                           |   35 +++++++-----
 15 files changed, 89 insertions(+), 101 deletions(-)

A nice patch serie that deletes more lines than it adds.

Under normal circumstances I would not send this to you after the
merge window but this serie give a good hint to the casual
reader that something changed now the directories are gone.
So they do not ask - why are so many files missing. Now they
will hunt for the new location.


Thomas wrote:
On Thu, Oct 25, 2007 at 10:17:53PM +0200, Thomas Gleixner wrote:
> 
> Thanks for doing this.
> 
> I think the last remaining bit to cleanup is the symlink from
> arch/x86/boot/bzImage. Now that the old directories are gone it does
> not make much sense to keep them alive. Andrew will survive it :)
> 
> Please send it Linus wards and feel free to add my Acked-by to all of
> them.

I did not amend the serie to add his acked-by - but just kept it in this mail.

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/sam/x86.git


	Sam
