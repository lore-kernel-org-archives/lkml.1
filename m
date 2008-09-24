Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbYIXIzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbYIXIzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 04:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbYIXIza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 04:55:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37859 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbYIXIza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 04:55:30 -0400
Date: Wed, 24 Sep 2008 10:55:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] timers fixes
Message-ID: <20080924085509.GG5576@elte.hu>
References: <200809240137.40403.rjw@sisk.pl> <20080924074038.GD3655@elte.hu> <20080924074245.GA11474@elte.hu> <1222246186.8277.69.camel@pasglop> <1222246291.8277.71.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222246291.8277.71.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2008-09-24 at 18:49 +1000, Benjamin Herrenschmidt wrote:
> > On Wed, 2008-09-24 at 09:42 +0200, Ingo Molnar wrote:
> > > Linus,
> > > 
> > > Please pull the latest timers-fixes-for-linus git tree from:
> > > 
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus
> > > 
> > > Thanks,
> > > 
> > > 	Ingo
> > > 
> > > ------------------>
> > > Marc Dionne (1):
> > >       x86: prevent stale state of c1e_mask across CPU offline/online, fix
> > 
> > Is that all the changeset comment ? Am I the only one to find that
> > totally useless ? Or is that the mail doesn't contain the actual
> > comment, only the title followed by the patch ?
> 
> Allright, so in fact, it's more like the log doesn't match
> the patch in the email..

only because i already picked up a different submission at that time, 
and posted in this thread.

i picked up this one from lkml:

  Subject: [PATCH] Fix build error introduced by commit 4faac97d44ac27bdbb010a9c3597401a8f89341f

see the full commit log below, it has all the details.

	Ingo

------------>
>From 1eda81495a49a4ee91d8863b0a441a624375efea Mon Sep 17 00:00:00 2001
From: Marc Dionne <marc.c.dionne@gmail.com>
Date: Tue, 23 Sep 2008 22:40:02 -0400
Subject: [PATCH] x86: prevent stale state of c1e_mask across CPU offline/online, fix

Fix build error introduced by commit 4faac97d44ac27 ("x86: prevent stale
state of c1e_mask across CPU offline/online").

process_32.c needs to include idle.h to get the prototype for
c1e_remove_cpu()

Signed-off-by: Marc Dionne <marc.c.dionne@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process_32.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 4b3cfdf..31f40b2 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -55,6 +55,7 @@
 #include <asm/tlbflush.h>
 #include <asm/cpu.h>
 #include <asm/kdebug.h>
+#include <asm/idle.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
