Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbZABPWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbZABPWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 10:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZABPWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 10:22:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60084 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbZABPWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 10:22:01 -0500
Date: Fri, 2 Jan 2009 16:21:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, rdreier@cisco.com, ian.campbell@citrix.com,
       jeremy.fitzhardinge@citrix.com, deller@gmx.de, rusty@rustcorp.com.au,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@mcmartin.ca, randolph@tausq.org, sam@ravnborg.org,
       dave@hiauly1.hia.nrc.ca
Subject: [PATCH] kbuild: Remove gcc 4.1.0 quirk from init/main.c
Message-ID: <20090102152124.GA19091@elte.hu>
References: <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain> <20081231.141408.60544902.davem@davemloft.net> <20090102115547.GB3027@elte.hu> <200901021443.58769.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901021443.58769.bzolnier@gmail.com>
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


* Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Friday 02 January 2009, Ingo Molnar wrote:
> > 
> > * David Miller <davem@davemloft.net> wrote:
> > 
> > > From: Linus Torvalds <torvalds@linux-foundation.org>
> > > Date: Wed, 31 Dec 2008 13:22:53 -0800 (PST)
> > > 
> > > > On Wed, 31 Dec 2008, Andrew Morton wrote:
> > > > > 
> > > > > Adrian claimed that it was gcc-4.1.0 and 4.1.1 only.  He proposed
> > > > > banning them: http://lkml.org/lkml/2008/8/5/444
> > > > 
> > > > If it really is just those releases, then yes, considering the number 
> > > > of cases we apparently have, and considering how ugly it is in some 
> > > > cases to move the weak function anywhere else, maybe banning those 
> > > > versions is the proper thing to do.
> > > > 
> > > > It probably won't hurt very many people - yeah, some people will be 
> > > > forced to upgrade, but I have this memory of early 4.1 having had 
> > > > other bugs anyway, so it's probably a good idea.
> > > 
> > > I think this is probably the best way to handle this.
> > 
> > okay - to move this matter from the discussion-space to the 
> > solution-space, how about the patch below? (tested on x86 with a 
> > non-affected compiler version.)
> 
> ...or we can just merge Adrian's patch from June 2008 which also fixes 
> the issue nicely.

didnt know about that patch, but yeah, sure.

> OTOH your patch has an advantage of addressing the problem in the more 
> appropriate place (include/linux/compiler.h) and from what I see allows 
> us to remove previous gcc 4.1.0 check from init/main.c?

Good spotting - find followup cleanup patch below.

	Ingo

------------------->
>From d23cbaaa342e5555a919a543095d656415a55950 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 2 Jan 2009 16:16:16 +0100
Subject: [PATCH] kbuild: Remove gcc 4.1.0 quirk from init/main.c

Impact: cleanup

We now have a cleaner check for gcc 4.1.0/4.1.1 trouble in
include/linux/compiler.h, so remove the 4.1.0 quirk from
init/main.c.

Reported-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 init/main.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/init/main.c b/init/main.c
index 2a7ce0f..5ced153 100644
--- a/init/main.c
+++ b/init/main.c
@@ -75,15 +75,6 @@
 #include <asm/smp.h>
 #endif
 
-/*
- * This is one of the first .c files built. Error out early if we have compiler
- * trouble.
- */
-
-#if __GNUC__ == 4 && __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ == 0
-#warning gcc-4.1.0 is known to miscompile the kernel.  A different compiler version is recommended.
-#endif
-
 static int kernel_init(void *);
 
 extern void init_IRQ(void);
