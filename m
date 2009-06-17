Return-Path: <linux-kernel-owner+w=401wt.eu-S1764422AbZFQLS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764422AbZFQLS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 07:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbZFQLSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 07:18:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56584 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbZFQLSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 07:18:15 -0400
Date: Wed, 17 Jun 2009 13:18:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, fengguang.wu@intel.com, adobriyan@gmail.com,
       andi@firstfloor.org, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH] pagemap: add page-types tool, fix build
Message-ID: <20090617111800.GA15261@elte.hu>
References: <200906162232.n5GMWRZe026963@imap1.linux-foundation.org> <20090616223649.719ea378.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616223649.719ea378.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 16 Jun 2009 15:32:27 -0700 akpm@linux-foundation.org wrote:
> 
> > --- a/Documentation/vm/Makefile~pagemap-add-page-types-tool
> > +++ a/Documentation/vm/Makefile
> > @@ -2,7 +2,7 @@
> >  obj- := dummy.o
> >  
> >  # List of programs to build
> > -hostprogs-y := slabinfo
> > +hostprogs-y := slabinfo slqbinfo page-types
> 
> hrm, slqbinfo shouldn't be there.  Thwap at people adding 
> non-2.6.31 material to linux-next, thwap at me for apparently not 
> running allmodconfig.

I just ran into this while merging to latest -git - fix below.

	Ingo

----------------->
>From c89779f6a5c50a8827b803193e87a3e559972391 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 17 Jun 2009 13:14:21 +0200
Subject: [PATCH] pagemap: add page-types tool, fix build

Latest -git fails to build:

 make[2]: *** No rule to make target `Documentation/vm/slqbinfo.c',
 needed by `Documentation/vm/slqbinfo'.  Stop.

but slqbinfo.c is not yet upstream. Fix the makefile.

Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/vm/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/vm/Makefile b/Documentation/vm/Makefile
index 27479d4..5bd269b 100644
--- a/Documentation/vm/Makefile
+++ b/Documentation/vm/Makefile
@@ -2,7 +2,7 @@
 obj- := dummy.o
 
 # List of programs to build
-hostprogs-y := slabinfo slqbinfo page-types
+hostprogs-y := slabinfo page-types
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
