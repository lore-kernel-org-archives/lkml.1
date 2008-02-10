Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbYBJJJC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbYBJJJC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 04:09:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYBJJIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 04:08:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55014 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYBJJIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 04:08:45 -0500
Date: Sun, 10 Feb 2008 10:08:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210090817.GA15409@elte.hu>
References: <20080210071331.GC3851@elte.hu> <20080210073542.GB26666@infradead.org> <20080210074352.GA7188@elte.hu> <20080210075732.GA9349@infradead.org> <20080210080225.GC7188@elte.hu> <20080210082132.GA9878@elte.hu> <20080210082624.GB10479@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210082624.GB10479@infradead.org>
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


* Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Feb 10, 2008 at 09:21:32AM +0100, Ingo Molnar wrote:
> > > Kerneldoc comments don't belong above the prototype of a function but 
> > > the function body.
> > 
> > disagree - the best is to have it in both places - and in many 
> > places we do that. Anyway, this is up to maintainer discretion.
> 
> Huh?  In both places is the worst idea ever.  It just means things 
> will 100% sure get out of sync.  And the reason why it should be at 
> the function declaration is because that's where the kerneldoc tool 
> picks it up.

Anyway, to resolve this i've turning them into non-docbook, descriptive 
comments. Please submit any docbook patch to arch/x86/kernel/kgdb.c to 
x86.git if you'd like more documentation. KGDB is already quite well 
documented.

Trivially updated kgdb tree can be pulled from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-kgdb.git

tip a92381ae1a93b6e3bdba60a63972d2ebd6eb73f5. Shortlog and diffstat 
below.

( but i believe you are missing the big picture: duplicating the same 
  information in all places, for functions that do _the same thing_ is 
  pointless. It's much better to have a single, consistent set of 
  information at the prototypes site. If docbook does not pick that up 
  that's a docbook problem. Anyway, it's moot now with the latest tree. )

test-built and test-booted on x86.

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
 include/asm-generic/kgdb.h          |   91 ++
 include/asm-x86/kgdb.h              |   85 ++
 include/linux/kgdb.h                |  333 ++++++
 include/linux/pid.h                 |    2 +
 include/linux/serial_core.h         |    4 +
 include/linux/tty_driver.h          |   12 +
 include/linux/uaccess.h             |   22 +
 kernel/Makefile                     |    1 +
 kernel/kgdb.c                       | 2019 +++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                     |    2 +-
 lib/Kconfig.debug                   |    2 +
 lib/Kconfig.kgdb                    |   37 +
 22 files changed, 3512 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kernel/kgdb.c
 create mode 100644 drivers/serial/kgdboc.c
 create mode 100644 include/asm-generic/kgdb.h
 create mode 100644 include/asm-x86/kgdb.h
 create mode 100644 include/linux/kgdb.h
 create mode 100644 kernel/kgdb.c
 create mode 100644 lib/Kconfig.kgdb

