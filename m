Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbZAKNyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbZAKNyA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbZAKNxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:53:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42426 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbZAKNxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:53:40 -0500
Date: Sun, 11 Jan 2009 14:52:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.29-rc1: Reported regressions from 2.6.28
Message-ID: <20090111135237.GA20184@elte.hu>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera> <3f9a31f40901110546h4c069b5dx9726a0fbf8caf5a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901110546h4c069b5dx9726a0fbf8caf5a1@mail.gmail.com>
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


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> On Sun, Jan 11, 2009 at 4:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > Regressions with patches
> > ------------------------
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12428
> > Subject         : Build error on latest git
> > Submitter       : Petr Titera <P.Titera@century.cz>
> > Date            : 2009-01-11 9:49 (1 days old)
> > References      : http://marc.info/?l=linux-kernel&m=123166856318712&w=4
> > Handled-By      : Petr Titera <P.Titera@century.cz>
> > Patch           : http://marc.info/?l=linux-kernel&m=123167509024996&w=4
> 
> This is a wrong fix, asm/smp.h should only be included when CONFIG_SMP 
> is defined.
> 
> I am still in the process of cleaning non-smp data from asm/smp.h for 
> x86
> 
> Attach patch is the solution for the time being
> 
> Ingo, can you please put this in urgent queue.

yes, it already is - see below.

	Ingo

----------------->
>From 8b5a33599c541cf5bf66304343d08ff2795d038b Mon Sep 17 00:00:00 2001
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
Date: Sun, 11 Jan 2009 18:38:55 +0530
Subject: [PATCH] x86: fix mpparse.c build error on latest git

Fix this by reintroducing asm/smp.h include in mpparse.c - later on
I will fix this by removing non-smp data from smp.h.

Reported-by: Petr Titera <P.Titera@century.cz>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/mpparse.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index c0601c2..a649a4c 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -27,6 +27,7 @@
 #include <asm/e820.h>
 #include <asm/trampoline.h>
 #include <asm/setup.h>
+#include <asm/smp.h>
 
 #include <mach_apic.h>
 #ifdef CONFIG_X86_32
