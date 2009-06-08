Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbZFHIxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbZFHIxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZFHIxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:53:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55249 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZFHIxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:53:13 -0400
Date: Mon, 8 Jun 2009 10:52:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v5] x86: MCE: Re-implement MCE log ring buffer as
	per-CPU ring buffer
Message-ID: <20090608085259.GF6372@elte.hu>
References: <1244445115.8361.576.camel@yhuang-dev.sh.intel.com> <20090608072030.GA6732@elte.hu> <1244446222.8361.584.camel@yhuang-dev.sh.intel.com> <20090608073845.GA32745@elte.hu> <1244449602.8361.587.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244449602.8361.587.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang Ying <ying.huang@intel.com> wrote:

> On Mon, 2009-06-08 at 15:38 +0800, Ingo Molnar wrote:
> > * Huang Ying <ying.huang@intel.com> wrote:
> > 
> > > On Mon, 2009-06-08 at 15:20 +0800, Ingo Molnar wrote:
> > > > * Huang Ying <ying.huang@intel.com> wrote:
> > > > 
> > > > > Re-implement MCE log ring buffer as per-CPU ring buffer for better 
> > > > > scalability.
> > > > 
> > > > this should be done using the generic ring-buffer code - see 
> > > > include/linux/ring_buffer.h. Having a private implementation in 
> > > > architecture code is not really acceptable.
> > > 
> > > MCE log ring buffer need to be NMI-safe, while current generic 
> > > ring-buffer code is not NMI safe. [...]
> > 
> > Then please work with Steve to make it NMI safe (or do so yourself) 
> > - i've Cc:-ed him - that way we help the core kernel: one of its 
> > essential facilities will get one more user. We dont put private, 
> > open-coded ring-buffer facilities into architecture code.
> 
> Steve have said he has a NMI-safe solution, but it is under patent 
> application. It seems that patent application will take very long 
> time, so we decide to enhance mce log buffer instead of waiting.

Nah - if patent applications held up releases of code and products 
up to the point where a patent issues then Intel wouldnt be able to 
release a new CPU for a decade or so ;-)

Anyway, i'll let Steve clarify the status of the NMI-safe ringbuffer 
patches.

	Ingo
