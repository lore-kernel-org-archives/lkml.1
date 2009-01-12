Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbZALKon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbZALKon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZALKoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:44:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55790 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbZALKod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:44:33 -0500
Date: Mon, 12 Jan 2009 11:44:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, Mike Travis <travis@sgi.com>,
       linuxppc-dev@ozlabs.org, linux-next@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: origin tree build failure
Message-ID: <20090112104402.GD10405@elte.hu>
References: <20090112104837.69feedec.sfr@canb.auug.org.au> <1231719015.22571.4.camel@pasglop> <20090112090552.GD26750@elte.hu> <1231753791.8959.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231753791.8959.7.camel@localhost>
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


* Michael Ellerman <michael@ellerman.id.au> wrote:

> On Mon, 2009-01-12 at 10:05 +0100, Ingo Molnar wrote:
> > * Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> > 
> > > On Mon, 2009-01-12 at 10:48 +1100, Stephen Rothwell wrote:
> > > > Hi Linus,
> > > > 
> > > > Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> > > > 
> > > > arch/powerpc/platforms/pasemi/cpufreq.c: In function 'pas_cpufreq_cpu_init':
> > > > arch/powerpc/platforms/pasemi/cpufreq.c:216: error: incompatible types in assignment
> > > > arch/powerpc/platforms/powermac/cpufreq_64.c: In function 'g5_cpufreq_cpu_init':
> > > > arch/powerpc/platforms/powermac/cpufreq_64.c:365: error: incompatible types in assignment
> > > > arch/powerpc/platforms/cell/cbe_cpufreq.c: In function 'cbe_cpufreq_cpu_init':
> > > > arch/powerpc/platforms/cell/cbe_cpufreq.c:121: error: incompatible types in assignment
> > > > 
> > > > Caused by commit 835481d9bcd65720b473db6b38746a74a3964218 ("cpumask:
> > > > convert struct cpufreq_policy to cpumask_var_t") which missed updating
> > > > all the powerpc (at least) cpufreq drivers.
> > > 
> > > Yeah, it only updates x86 it seems ... 
> > 
> > Yeah - and that build bug was stupid too - when touching a generic file 
> > that is called include/linux/cpufreq.h and changing a key data field one 
> > should at minimum get the idea that it's generic for a reason and should 
> > start grepping the tree ...
> > 
> > It slipped through because it didnt get caught in build tests because 
> > cpufreq isnt enabled in the powerpc defconfig.
> 
> Which defconfig?
>
> powerpc(master) $ git grep CPU_FREQ=y arch/powerpc/configs/ppc64_defconfig
> arch/powerpc/configs/ppc64_defconfig:CONFIG_CPU_FREQ=y

ah, indeed - you are right.

	Ingo
