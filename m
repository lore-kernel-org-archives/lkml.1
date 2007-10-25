Return-Path: <linux-kernel-owner+w=401wt.eu-S1759788AbXJYTzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788AbXJYTzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 15:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbXJYTzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 15:55:11 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52867 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbXJYTzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 15:55:09 -0400
Date: Thu, 25 Oct 2007 21:56:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: sam@ravnborg.org
Subject: [PATCH 0/6] kill i386 and x86_64 directories
Message-ID: <20071025195644.GA14501@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This series kill the old i386 and x86_64 directories.
The relevant files are moved and adapted and
Kconfig.debug was consolidated (thanks to Randy).

I had to modify both the top-lvel Makefile and the kconfig
Makefile to accomplish this. It was done in such a way that
it is trivial for other archs to use the same mechanism
should they have the need.

To solve the defconfig issue (i386 and x86_64 cannot share one)
the arch/x86/configs/ directory were introduced. This has
been used by other archs for some time now but x86 had not had
the need until now.

The Kconfig files could be consolidated much more - I only
did the minimal changes to make it work in the new place.

Total diffstat (in git format):

 Makefile                                           |    7 ++-
 arch/i386/.gitignore                               |    1 -
 arch/{i386 => x86}/Kconfig.cpu                     |    0 
 arch/{i386 => x86}/Kconfig.debug                   |   51 +++++++++++++---
 arch/{i386/Kconfig => x86/Kconfig.i386}            |    4 +-
 arch/{x86_64/Kconfig => x86/Kconfig.x86_64}        |    6 +--
 arch/x86/Makefile                                  |   16 +++++
 arch/{i386/Makefile => x86/Makefile_32}            |    7 +--
 arch/{i386/Makefile.cpu => x86/Makefile_32.cpu}    |    0 
 arch/{x86_64/Makefile => x86/Makefile_64}          |    5 +-
 .../{i386/defconfig => x86/configs/i386_defconfig} |    0 
 .../defconfig => x86/configs/x86_64_defconfig}     |    0 
 arch/x86_64/.gitignore                             |    1 -
 arch/x86_64/Kconfig.debug                          |   61 --------------------
 scripts/kconfig/Makefile                           |   35 +++++++-----
 15 files changed, 89 insertions(+), 105 deletions(-)

Patches follows.
The full serie can be pulled from:

	git://git.kernel.org/pub/scm/linux/kernel/git/sam/x86.git

Note: The serie were slightly modfied compared to the fist published
      version.

	Sam
