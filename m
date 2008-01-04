Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbYADNXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbYADNXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYADNXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:23:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49439 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbYADNXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:23:38 -0500
Date: Fri, 4 Jan 2008 14:23:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] This patch to profile.c fixes a few errors reported by
	checkpatch.pl
Message-ID: <20080104132328.GA27330@elte.hu>
References: <20080104003253.7a7309d8@paolo-desktop> <20080104083442.GD22803@elte.hu> <4d8e3fd30801040318q2e3be951rbf517f7d6022ae04@mail.gmail.com> <20080104130702.GC20981@elte.hu> <4d8e3fd30801040518q4e115efcoc8967e516fa365f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8e3fd30801040518q4e115efcoc8967e516fa365f1@mail.gmail.com>
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


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> > i.e. take the implicit assignment out of the condition. (it's easy 
> > to mistake it for '==' while reviewing the code and forgetting about 
> > the assignment's side-effect)
> 
> OK, thanks.
> 
> Is the following correct?
> 
> Before:
>  if (!(entry = create_proc_entry("prof_cpu_mask", 0600, root_irq_dir)))
> 
> After:
> entry = create_proc_entry("prof_cpu_mask", 0600, root_irq_dir)
> if (!entry)
> 
> BTW, how can i compile only the profile.c file?

make kernel/profile.o

> I would like to verify that my changes (now I'm at total: 2 errors, 1 
> warnings, 599 lines checked) doesn't impact on the compiled code?

check out:

 http://people.redhat.com/mingo/misc/q-size-obj-compare

which does a size and md5 comparison. (assuming your patch is in a quilt 
queue) But if you reorder symbols (due to the EXPORT_SYMBOL moving) the 
md5 might differ. (but size should still be the same)

	Ingo
