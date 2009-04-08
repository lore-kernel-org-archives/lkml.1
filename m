Return-Path: <linux-kernel-owner+w=401wt.eu-S1761404AbZDHMry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761404AbZDHMry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbZDHMrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:47:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48845 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbZDHMrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:47:41 -0400
Date: Wed, 8 Apr 2009 14:46:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dipankar@in.ibm.com, niv@us.ibm.com,
       manfred@colorfullife.com, peterz@infradead.org, lethal@linux-sh.org,
       kernel@wantstofly.org, andi@firstfloor.org, kyle@mcmartin.ca,
       deller@gmx.de, davem@davemloft.net, ralf@linux-mips.org, jes@sgi.com,
       benh@kernel.crashing.org, paulus@samba.org, anton@samba.org
Subject: Re: [PATCH -tip] Convert CONFIG_SMP=y powerpc defconfigs to
	TREE_RCU.
Message-ID: <20090408124623.GH18581@elte.hu>
References: <3181463559098978317@unknownmsgid> <625fc13d0904040621g7b89cd2cq9681ce80635a65c4@mail.gmail.com> <20090404163149.GC6893@linux.vnet.ibm.com> <20090405101756.GA10490@elte.hu> <20090405164420.GI6893@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090405164420.GI6893@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Sun, Apr 05, 2009 at 12:17:56PM +0200, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > On Sat, Apr 04, 2009 at 09:21:58AM -0400, Josh Boyer wrote:
> > > > On Fri, Apr 3, 2009 at 8:27 PM, Paul E. McKenney
> > > > <paulmck@linux.vnet.ibm.com> wrote:
> > > > > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > 
> > > > Why would one want to do this?  The commit log doesn't explain the
> > > > switch and why it's great.  Mostly because the commit log doesn't
> > > > exist.  (I'll stop channeling Andrew now)
> > > 
> > > Indeed, I am sure that I will get the hang the relevant git 
> > > commands at some point, but clearly am not yet there.
> > > 
> > > The thing that is great about this patch is that it is a step on 
> > > the way to retiring Classic RCU entirely.
> > 
> > I'd suggest you dont do these dozens of defconfig updates at all - 
> > arch maintainers can do this themselves, once the core kernel 
> > default has been flipped.
> 
> I am of course personally quite happy with this approach in the 
> short term, as I would only need to worry about one patch.
> 
> My one concern would be that we cannot retire Classic RCU until 
> all the arch maintainers remove CONFIG_CLASSIC_RCU=y from their 
> defconfig files. However, given that the attached script suffices, 
> I am not too worried about that.

ah, that's not a real concern. Most defconfigs are stale all the 
time, and arch maintainers typically refresh them at around rc7.
(if at all) Kconfig will warn about (and ignore) stale entries.

So no, there's no requirement to touch defconfigs - to the contrary: 
it has way too wide of a cross section with other trees to be really 
practical to carry in the RCU tree.

	Ingo
