Return-Path: <linux-kernel-owner+w=401wt.eu-S1760815AbZBXVuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815AbZBXVuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 16:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760628AbZBXVtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 16:49:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55708 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069AbZBXVtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 16:49:51 -0500
Date: Tue, 24 Feb 2009 22:49:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: hpa@zytor.com, mingo@redhat.com, tj@kernel.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/percpu] bootmem: clean up arch-specific bootmem
	wrapping
Message-ID: <20090224214932.GC12601@elte.hu>
References: <tip-c132937556f56ee4b831ef4b23f1846e05fde102@kernel.org> <20090224214638.GA2049@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224214638.GA2049@cmpxchg.org>
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


* Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Tue, Feb 24, 2009 at 08:23:03PM +0000, Tejun Heo wrote:
> > Author:     Tejun Heo <tj@kernel.org>
> > AuthorDate: Tue, 24 Feb 2009 11:57:20 +0900
> > Commit:     Tejun Heo <tj@kernel.org>
> > CommitDate: Tue, 24 Feb 2009 11:57:20 +0900
> > 
> > bootmem: clean up arch-specific bootmem wrapping
> > 
> > Impact: cleaner and consistent bootmem wrapping
> > 
> > By setting CONFIG_HAVE_ARCH_BOOTMEM_NODE, archs can define
> > arch-specific wrappers for bootmem allocation.  However, this is done
> > a bit strangely in that only the high level convenience macros can be
> > changed while lower level, but still exported, interface functions
> > can't be wrapped.  This not only is messy but also leads to strange
> > situation where alloc_bootmem() does what the arch wants it to do but
> > the equivalent __alloc_bootmem() call doesn't although they should be
> > able to be used interchangeably.
> > 
> > This patch updates bootmem such that archs can override / wrap the
> > backend function - alloc_bootmem_core() instead of the highlevel
> > interface functions to allow simpler and consistent wrapping.  Also,
> > HAVE_ARCH_BOOTMEM_NODE is renamed to HAVE_ARCH_BOOTMEM.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Johannes Weiner <hannes@saeurebad.de>
> 
> What does this message mean?  That the patch was commited to 
> the -tip tree?

yes.

> Well, why not... oh, right, it is broken ;-)

In your reply you pointed out a change that was not adequately 
declared plus an opportunity for a cleanup - is that what you 
mean by breakage?

	Ingo
