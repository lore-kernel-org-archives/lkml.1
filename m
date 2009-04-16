Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990AbZDPIDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbZDPIDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 04:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZDPID3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 04:03:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40922 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbZDPID1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 04:03:27 -0400
Date: Thu, 16 Apr 2009 10:02:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090416080253.GC4507@elte.hu>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <200904152014.11717.rusty@rustcorp.com.au> <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain> <200904161057.07108.rusty@rustcorp.com.au> <20090416023103.GI21586@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416023103.GI21586@mit.edu>
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


* Theodore Tso <tytso@mit.edu> wrote:

> On Thu, Apr 16, 2009 at 10:57:05AM +0930, Rusty Russell wrote:
> > Ingo wants them.  Example:
> > 
> > 	lguest: don't expect linear addresses in gdt pvops
> > 
> > 	Impact: fix guest crash 'lguest: bad read address 0x4800000 len 256'
> > 
> > What's more important in the subject line?  That it fixes a crash, or what it
> > does?
> 
> Well, consider that 2 or 3 months later, when we're trying to find 
> a potential commit (say, because we're trying to find a potential 
> fix that needs to be forward ported to a distro kernel, or some 
> such), the initial summary line is what is going to be visible in 
> gitk or via "git log --oneline" (or "git log --pretty=oneline 
> --abbrev-commit" for older git versions).
> 
> So when I try to create git log messages, I try to make the first 
> line useful for folks who might be sorting through potentially 
> thousands of patches via gitk or git log --oneline.  So I might do 
> something like

Hm, have you seen the very simple git log + grep examples i gave, 
about how the impact lines of the APIC code and the scheduler in 
this cycle can be used to summarize a stability track record at a 
glance, out of a much larger body of commits?

Try:

  git log v2.6.29..v2.6.30-rc1 arch/x86/kernel/apic/ | \
                  grep Impact: | sort | uniq -c | sort -n


and:

  git log v2.6.29..v2.6.30-rc1 kernel/sched.c | \
                   grep Impact: | sort | uniq -c | sort -n

on a recent upstream repo.

Thanks,

	Ingo

