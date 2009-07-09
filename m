Return-Path: <linux-kernel-owner+w=401wt.eu-S1761112AbZGIQLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761112AbZGIQLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 12:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759397AbZGIQLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 12:11:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52402 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759771AbZGIQLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 12:11:40 -0400
Date: Thu, 9 Jul 2009 12:10:59 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Joao Correia <joaomiguelcorreia@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 1/3] Increase lockdep limits: MAX_STACK_TRACE_ENTRIES
Message-ID: <20090709161059.GA2909@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Joao Correia <joaomiguelcorreia@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	=?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>
References: <a5d9929e0907070825j1dda6584t93196e2730dedc5c@mail.gmail.com> <1246980836.9777.5.camel@twins> <a5d9929e0907070838q7ed3306du3bb7880e47d7207b@mail.gmail.com> <1246981444.9777.11.camel@twins> <a5d9929e0907070850v72cd4da4y1cbbb10fddebd575@mail.gmail.com> <1246982101.9777.15.camel@twins> <20090708172248.GB2521@redhat.com> <1247078164.16156.18.camel@laptop> <20090709043931.GA11391@redhat.com> <1247126556.9777.323.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247126556.9777.323.camel@twins>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 10:02:36AM +0200, Peter Zijlstra wrote:
 > On Thu, 2009-07-09 at 00:39 -0400, Dave Jones wrote:
 > > On Wed, Jul 08, 2009 at 08:36:04PM +0200, Peter Zijlstra wrote:
 > >  > Looking at a lockdep dump hch gave me I can see that that is certainly
 > >  > possible, I see tons of very deep callchains.
 > >  > 
 > >  > /me wonders if we're getting significantly deeper..
 > > 
 > > Looking at /proc/lockdep, I'm curious..
 > > Take a look at http://davej.fedorapeople.org/lockdep
 > > scroll down to c12c0924
 > > 
 > > What's up with all those old_style_spin_init's ?
 > 
 > What kernel are you running?

.31rc2

 > Does your lib/dma_debug.c:dma_debug_init()
 > have spin_lock_init() in that HASH_SIZE loop?

it's doing it by hand..

 717         for (i = 0; i < HASH_SIZE; ++i) {
 718                 INIT_LIST_HEAD(&dma_entry_hash[i].list);
 719                 dma_entry_hash[i].lock = SPIN_LOCK_UNLOCKED;
 720         }


	Dave
 
