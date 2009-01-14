Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbZANWfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbZANWfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbZANWe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:34:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737AbZANWez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:34:55 -0500
Date: Wed, 14 Jan 2009 23:34:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl, paulmck@linux.vnet.ibm.com, ghaskins@novell.com,
       matthew@wil.cx, andi@firstfloor.org, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-btrfs@vger.kernel.org, tglx@linutronix.de, npiggin@suse.de,
       pmorreale@novell.com, SDietrich@novell.com, dmitry.adamushko@gmail.com,
       hannes@cmpxchg.org
Subject: Re: [GIT PULL] adaptive spinning mutexes
Message-ID: <20090114223408.GA19173@elte.hu>
References: <20090114105300.66bd014d.akpm@linux-foundation.org> <20090114190008.GA13203@elte.hu> <20090114113638.c818fcf8.akpm@linux-foundation.org> <20090114201435.GA6519@elte.hu> <20090114123017.9acf42d7.akpm@linux-foundation.org> <20090114205122.GC6519@elte.hu> <20090114130642.cf2b18b2.akpm@linux-foundation.org> <20090114211458.GD6519@elte.hu> <20090114214158.GA9992@elte.hu> <ac3eb2510901141350x16c0f67cp46376e57062eaef9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510901141350x16c0f67cp46376e57062eaef9@mail.gmail.com>
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


* Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Wed, Jan 14, 2009 at 22:41, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> > You just disproved your own case :(
> >>
> >> how so? 80% is not enough? I also checked Fedora and it has
> >> SCHED_DEBUG=y in its kernel rpms.
> >
> > Ubuntu has CONFIG_SCHED_DEBUG=y as well in their kernels.
> 
> $ cat /etc/SuSE-release
> openSUSE 11.1 (x86_64)
> VERSION = 11.1
> 
> $ uname -a
> Linux nga 2.6.27.7-9-default #1 SMP 2008-12-04 18:10:04 +0100 x86_64
> x86_64 x86_64 GNU/Linux
> 
> $ zgrep SCHED_DEBUG /proc/config.gz
> CONFIG_SCHED_DEBUG=y
> 
> $ zgrep DEBUG_MUTEX /proc/config.gz
> # CONFIG_DEBUG_MUTEXES is not set

Fedora has mutex debugging disabled too:

   # CONFIG_DEBUG_MUTEXES is not set

So the 3 main Linux distros, generating ~95% of the kerneloops.org 
feedback traffic, all have SCHED_DEBUG=y, and at least two have 
!DEBUG_MUTEXES. (possibly Ubuntu has that disabled it too)

	Ingo
