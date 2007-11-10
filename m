Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbXKJUjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbXKJUjO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 15:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbXKJUjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 15:39:00 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:60357 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbXKJUi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 15:38:59 -0500
Date: Sat, 10 Nov 2007 21:40:38 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/5] introduce K64BIT=y and backward compatibility ARCH={i386,x86_64} for x86
Message-ID: <20071110204038.GA13140@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed in another thread the right thing is to add a generic solution
to select between 32 and 64 bit - useable for powerpc, s390, ppc et al.

First step was to teach kconfig how to force 64BIT to a specific value.
The x86 Kconfig file needed a small twist to use 64BIT as the symbol
to seelct 32 or 64 bit.
Then it was simple to add backward compatibility ARCH= settings.

The patchset is not yet pushed out - I will await a bit feedback first.

Shortlog and diffstat.
      kconfig: factor out code in confdata.c
      kconfig: use $K64BIT to set 64BIT with all*config targets
      x86: Use CONFIG_64BIT to select between 32 and 64 bit in Kconfig
      kconfig: document make K64BIT=y in README
      x86: introduce ARCH=i386,ARCH=x86_64 to select 32/64 bit


 Makefile                    |   16 ++++-
 README                      |    2 +
 arch/x86/Kconfig            |   26 +++-----
 arch/x86/Makefile           |   10 ++-
 scripts/kconfig/Makefile    |    2 +-
 scripts/kconfig/conf.c      |    1 +
 scripts/kconfig/confdata.c  |  146 +++++++++++++++++++++++++++----------------
 scripts/kconfig/lkc_proto.h |    1 +
 8 files changed, 124 insertions(+), 80 deletions(-)

The majority of the diffstat is the code refactoring of confdata.c
The rest is simple changes.

Patches follows...
Patches are on top of the patchset to introduce "make ARCH=x86"

	Sam
