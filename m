Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbYBJHle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbYBJHle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbYBJHlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:41:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60982 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756947AbYBJHlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:41:22 -0500
Date: Sun, 10 Feb 2008 08:41:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [5/6] x86: kgdb support
Message-ID: <20080210074102.GA5940@elte.hu>
References: <20080210071345.GE3851@elte.hu> <20080210073301.GB9805@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210073301.GB9805@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> >  config X86_64
> >  	def_bool 64BIT
> > +	select KGDB_ARCH_HAS_SHADOW_INFO
> >  
> >  ### Arch settings
> >  config X86
> > @@ -139,6 +140,9 @@ config AUDIT_ARCH
> >  config ARCH_SUPPORTS_AOUT
> >  	def_bool y
> >  
> > +config ARCH_SUPPORTS_KGDB
> > +	def_bool y
> > +
> 
> Please use the documented HAVE_ approach and not this ugly "one 
> variable per arch" idiom. This was also commented last time the 
> patchset were posted.

hm, i wasnt Cc:-ed to that so i didnt read it yet. I have just followed 
the logical ARHC_SUPPORTS_* idiom which reads more naturally than 
HAVE_ARCH_*. But ... no string feelings, changing it is easy enough, i 
renamed them and pushed out the new iteration to:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-kgdb.git

diffstat and shortlog did not change (just a rename of these config 
variables) - but i'm including them below for completeness of the 
submission.

any other observations?

	Ingo

------------------>
Ingo Molnar (3):
      pids: add pid_max prototype
      uaccess: add probe_kernel_write()
      x86: kgdb support

Jan Kiszka (1):
      consoles: polling support, kgdboc

Jason Wessel (2):
      kgdb: core
      kgdb: document parameters

 Documentation/kernel-parameters.txt |    5 +
 arch/x86/Kconfig                    |    4 +
 arch/x86/kernel/Makefile            |    1 +
 arch/x86/kernel/kgdb.c              |  550 ++++++++++
 drivers/char/tty_io.c               |   47 +
 drivers/serial/8250.c               |   62 ++
 drivers/serial/Kconfig              |    3 +
 drivers/serial/Makefile             |    1 +
 drivers/serial/kgdboc.c             |  164 +++
 drivers/serial/serial_core.c        |   67 ++-
 include/asm-generic/kgdb.h          |   93 ++
 include/asm-x86/kgdb.h              |   87 ++
 include/linux/kgdb.h                |  264 +++++
 include/linux/pid.h                 |    2 +
 include/linux/serial_core.h         |    4 +
 include/linux/tty_driver.h          |   12 +
 include/linux/uaccess.h             |   22 +
 kernel/Makefile                     |    1 +
 kernel/kgdb.c                       | 2020 +++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                     |    2 +-
 lib/Kconfig.debug                   |    2 +
 lib/Kconfig.kgdb                    |   37 +
 22 files changed, 3448 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kernel/kgdb.c
 create mode 100644 drivers/serial/kgdboc.c
 create mode 100644 include/asm-generic/kgdb.h
 create mode 100644 include/asm-x86/kgdb.h
 create mode 100644 include/linux/kgdb.h
 create mode 100644 kernel/kgdb.c
 create mode 100644 lib/Kconfig.kgdb
