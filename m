Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYLNWih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYLNWih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 17:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYLNWi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 17:38:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46747 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbYLNWiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 17:38:25 -0500
Date: Sun, 14 Dec 2008 23:37:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
       Vince Weaver <vince@deater.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v3
Message-ID: <20081214223756.GA21808@elte.hu>
References: <20081211155230.GA4230@elte.hu> <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy> <1229070345.12883.12.camel@twins> <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com> <1229073834.12883.41.camel@twins> <7c86c4470812120942x607a74f7w9f823adecbd73b85@mail.gmail.com> <1229167048.13566.119.camel@twins> <18756.23327.478759.5970@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18756.23327.478759.5970@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Peter Zijlstra writes:
> 
> > On Fri, 2008-12-12 at 18:42 +0100, stephane eranian wrote:
> > > In fact, I know tools which do not even need a library. 
> > 
> > By your own saying, the problem solved by libperfmon is a hard problem
> > (and I fully understand that).
> > 
> > Now you say there is software out there that doesn't use libperfmon,
> > that means they'll have to duplicate that functionality.
> > 
> > And only commercial software has a clear gain by wastefully duplicating
> > that effort. This means there is an active commercial interest to not
> > make perfmon the best technical solution there is, which is contrary to
> > the very thing Linux is about.
> > 
> > What is worse, you defend that:
> > 
> > > Go ask end-users what they think of that?
> > > 
> > > You don't even need a library. All of this could be integrated into the tool.
> > > New processor, just go download the updated version of the tool.
> > 
> > No! what people want is their problem fixed - no matter how. That is one
> > of the powers of FOSS, you can fix your problems in any way suitable.
> > 
> > Would it not be much better if those folks duped into using a binary
> > only product only had to upgrade their FOSS kernel, instead of possibly
> > forking over more $$$ for an upgrade?
> > 
> > You have just irrevocably proven to me this needs to go into the kernel,
> > as the design of perfmon is little more than a GPL circumvention device
> > - independent of whether you are aware of that or not.
> 
> I'm sorry, but that is a pretty silly argument.
> 
> By that logic, the kernel module loader should include an in-kernel copy 
> of gcc and binutils, and the fact that it doesn't proves that the module 
> loader is little more than a GPL circumvention device - independent of 
> whether you are aware of that or not.  8-)

i'm not sure how your example applies: the kernel module loader is not an 
application that needs to be updated to new versions of syscalls. Nor is 
it a needless duplication of infrastructure - it runs in a completely 
different protection domain - just to name one of the key differences.

Applications going to complex raw syscalls and avoiding a neutral hw 
infrastructure library that implements a non-trivial job is quite typical 
for FOSS-library-shy bin-only apps. The "you cannot infringe what you do 
not link to at all" kind of defensive thinking.

	Ingo
