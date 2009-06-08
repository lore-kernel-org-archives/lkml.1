Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbZFHHjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbZFHHjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 03:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbZFHHi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 03:38:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42754 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbZFHHi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 03:38:57 -0400
Date: Mon, 8 Jun 2009 09:38:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v5] x86: MCE: Re-implement MCE log ring buffer as
	per-CPU ring buffer
Message-ID: <20090608073845.GA32745@elte.hu>
References: <1244445115.8361.576.camel@yhuang-dev.sh.intel.com> <20090608072030.GA6732@elte.hu> <1244446222.8361.584.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244446222.8361.584.camel@yhuang-dev.sh.intel.com>
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

> On Mon, 2009-06-08 at 15:20 +0800, Ingo Molnar wrote:
> > * Huang Ying <ying.huang@intel.com> wrote:
> > 
> > > Re-implement MCE log ring buffer as per-CPU ring buffer for better 
> > > scalability.
> > 
> > this should be done using the generic ring-buffer code - see 
> > include/linux/ring_buffer.h. Having a private implementation in 
> > architecture code is not really acceptable.
> 
> MCE log ring buffer need to be NMI-safe, while current generic 
> ring-buffer code is not NMI safe. [...]

Then please work with Steve to make it NMI safe (or do so yourself) 
- i've Cc:-ed him - that way we help the core kernel: one of its 
essential facilities will get one more user. We dont put private, 
open-coded ring-buffer facilities into architecture code.

	Ingo
