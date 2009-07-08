Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZGHRXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZGHRXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 13:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbZGHRW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 13:22:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55920 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbZGHRW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 13:22:59 -0400
Date: Wed, 8 Jul 2009 13:22:48 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Joao Correia <joaomiguelcorreia@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 1/3] Increase lockdep limits: MAX_STACK_TRACE_ENTRIES
Message-ID: <20090708172248.GB2521@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Joao Correia <joaomiguelcorreia@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	=?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
References: <a5d9929e0907070825j1dda6584t93196e2730dedc5c@mail.gmail.com> <1246980836.9777.5.camel@twins> <a5d9929e0907070838q7ed3306du3bb7880e47d7207b@mail.gmail.com> <1246981444.9777.11.camel@twins> <a5d9929e0907070850v72cd4da4y1cbbb10fddebd575@mail.gmail.com> <1246982101.9777.15.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246982101.9777.15.camel@twins>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 05:55:01PM +0200, Peter Zijlstra wrote:
 > On Tue, 2009-07-07 at 16:50 +0100, Joao Correia wrote:
 > 
 > > >> Yes. Anything 2.6.31 forward triggers this immediatly during init
 > > >> process, at random places.
 > > >
 > > > Not on my machines it doesn't.. so I suspect its something weird in
 > > > your .config or maybe due to some hardware you have that I don't that
 > > > triggers different drivers or somesuch.
 > > 
 > > I am not the only one reporting this, and it happens, for example,
 > > with a stock .config from a Fedora 11 install.
 > > 
 > > It may, of course, be a funny driver interaction yes, but other than
 > > stripping the box piece by piece, how would one go about debugging
 > > this otherwise?
 > 
 > One thing to do is stare (or share) at the output
 > of /proc/lockdep_chains and see if there's some particularly large
 > chains in there, or many of the same name or something.

I don't see any long chains, just lots of them.
29065 lines on my box that's hitting MAX_STACK_TRACE_ENTRIES 

 > /proc/lockdep_stats might also be interesting, mine reads like:
 
 lock-classes:                         1518 [max: 8191]
 direct dependencies:                  7142 [max: 16384]
 indirect dependencies:               97905
 all direct dependencies:            753706
 dependency chains:                    6201 [max: 32768]
 dependency chain hlocks:             16665 [max: 163840]
 in-hardirq chains:                    1380
 in-softirq chains:                     589
 in-process chains:                    4232
 stack-trace entries:                262144 [max: 262144]
 combined max dependencies:      3449006070
 hardirq-safe locks:                   1008
 hardirq-unsafe locks:                  364
 softirq-safe locks:                    838
 softirq-unsafe locks:                  322
 irq-safe locks:                       1043
 irq-unsafe locks:                      364
 hardirq-read-safe locks:                 0
 hardirq-read-unsafe locks:              48
 softirq-read-safe locks:                 0
 softirq-read-unsafe locks:              48
 irq-read-safe locks:                     0
 irq-read-unsafe locks:                  48
 uncategorized locks:                   104
 unused locks:                            0
 max locking depth:                       9
 max recursion depth:                    10
 debug_locks:                             0


	Dave

