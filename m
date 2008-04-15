Return-Path: <linux-kernel-owner+w=401wt.eu-S933180AbYDOV32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180AbYDOV32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932726AbYDOV27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:28:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50482 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932405AbYDOV26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:28:58 -0400
Date: Tue, 15 Apr 2008 23:28:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       travis@sgi.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415212833.GA6180@elte.hu>
References: <20080415202805.GA26880@elte.hu> <20080415203405.GA27958@elte.hu> <20080415204208.GA30432@elte.hu> <Pine.LNX.4.64.0804151344340.1785@schroedinger.engr.sgi.com> <20080415205820.GC31645@elte.hu> <Pine.LNX.4.64.0804151405120.3252@schroedinger.engr.sgi.com> <20080415211953.GA4243@elte.hu> <Pine.LNX.4.64.0804151420430.3252@schroedinger.engr.sgi.com> <20080415212301.GA5428@elte.hu> <Pine.LNX.4.64.0804151423460.3252@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804151423460.3252@schroedinger.engr.sgi.com>
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


* Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 15 Apr 2008, Ingo Molnar wrote:
> 
> > > static DEFINE_PER_CPU(char, dummy)[10000];
> > 
> > what's the guarantee that it's at the end of the section? I'd like 
> > to pad the per cpu areas at their end. (doubling their size is a 
> > good way to achieve that)
> 
> No guarantee. Its up to the linker. Sorry. We could add a new 
> percpu.last section but that requires a number of changes to linking.

ah. Then the patch below should do the trick, right?

	Ingo

------------->
Subject: larger: percpu
From: Ingo Molnar <mingo@elte.hu>
Date: Tue Apr 15 23:13:18 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/vmlinux_32.lds.S |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/x86/kernel/vmlinux_32.lds.S
===================================================================
--- linux.orig/arch/x86/kernel/vmlinux_32.lds.S
+++ linux/arch/x86/kernel/vmlinux_32.lds.S
@@ -186,6 +186,7 @@ SECTIONS
 	__per_cpu_start = .;
 	*(.data.percpu)
 	*(.data.percpu.shared_aligned)
+	. = . + 65536;
 	__per_cpu_end = .;
   }
   . = ALIGN(PAGE_SIZE);
