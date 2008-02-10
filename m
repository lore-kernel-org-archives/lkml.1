Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbYBJICw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbYBJICw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 03:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbYBJICq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 03:02:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59559 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489AbYBJICp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 03:02:45 -0500
Date: Sun, 10 Feb 2008 09:02:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210080225.GC7188@elte.hu>
References: <20080210071331.GC3851@elte.hu> <20080210073542.GB26666@infradead.org> <20080210074352.GA7188@elte.hu> <20080210075732.GA9349@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210075732.GA9349@infradead.org>
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

> On Sun, Feb 10, 2008 at 08:43:52AM +0100, Ingo Molnar wrote:
> > 
> > * Christoph Hellwig <hch@infradead.org> wrote:
> > 
> > > This still doesn't address a lot of the review comments from Jason's 
> > > last posting.
> > 
> > sorry, which mails are those?
> 
> It's all in the thread starting with '[PATCH 0/8] kgdb 2.6.25 
> version', msgid 
> 1202564114-18587-1-git-send-email-jason.wessel@windriver.com or at 
> http://lkml.org/lkml/2008/2/9/104

thanks - i found Sam's mail meanwhile and addressed most of the 
observations and updated the kgdb.git tree. I'll now check the threads 
above whether i missed anything. (feel free to point it out if you 
notice anything outright) As the changes have been janitorial only i 
refrain from reposting the series once again. The latest shortlog is 
below.

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
