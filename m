Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbZCFUPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbZCFUPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 15:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZCFUPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 15:15:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48892 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbZCFUPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 15:15:31 -0500
Date: Fri, 6 Mar 2009 21:15:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce bootmem_state -v2
Message-ID: <20090306201503.GC4278@elte.hu>
References: <1236257708-27269-7-git-send-email-penberg@cs.helsinki.fi> <49B02498.9080300@kernel.org> <49B02C68.1030203@cs.helsinki.fi> <49B0640A.5080607@kernel.org> <20090306145928.GE21907@elte.hu> <49B16DA6.4090108@kernel.org> <20090306191249.GC28582@elte.hu> <49B17E6C.2040702@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B17E6C.2040702@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Ingo Molnar wrote:
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> Impact: cleanup
> >>
> >> extend after_bootmem and after_init_bootmem to bootmem_state
> >> and will have BEFORE_BOOTMEM, DURING_BOOTMEM, AFTER_BOOTMEM
> >>
> >> v2: style changes according to ingo
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>
> >> ---
> >>  arch/x86/kernel/setup.c |    1 +
> >>  arch/x86/mm/init.c      |   13 +++++++------
> >>  arch/x86/mm/init_32.c   |   28 ++++++++++++++++++++--------
> >>  arch/x86/mm/init_64.c   |   33 +++++++++++++++++++--------------
> >>  include/linux/mm.h      |    9 +++++++++
> >>  5 files changed, 56 insertions(+), 28 deletions(-)
> > 
> >> Index: linux-2.6/include/linux/mm.h
> >> ===================================================================
> >> --- linux-2.6.orig/include/linux/mm.h
> >> +++ linux-2.6/include/linux/mm.h
> >> @@ -1067,6 +1067,15 @@ extern void __init mmap_init(void);
> >>  extern void show_mem(void);
> >>  extern void si_meminfo(struct sysinfo * val);
> >>  extern void si_meminfo_node(struct sysinfo *val, int nid);
> >> +
> >> +enum bootmem_state {
> >> +	BEFORE_BOOTMEM,
> >> +	DURING_BOOTMEM,
> >> +	AFTER_BOOTMEM
> >> +};
> >> +
> >> +extern enum bootmem_state bootmem_state;
> >> +
> >>  extern int after_bootmem;
> > 
> > Btw., the after_bootmem variable itself should either move 
> > to x86 (and arch/sh), or should be defined in mm/bootmem.c.
> > 
> > Right now we have this weird mm.h construct that is not 
> > actually useful to generic code.
> 
> with this patch, only sh is using after_bootmem. could
> 1. make sh to use bootmem_state
> 2. then remove after_bootmem

Hm, lets leave arch/sh alone for now i think - the commits are 
desintd for the x86 tree.

But we should move our after_bootmem to arch/x86/include/ and 
not pollute mm.h with it. It's an x86 internal detail for now.

	Ingo
