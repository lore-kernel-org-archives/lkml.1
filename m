Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbYE3S5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbYE3S5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 14:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYE3S5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 14:57:03 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:39211 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbYE3S45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 14:56:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=lw1yYmX7b+RvizEj9XvMDjC2DqmyT42lFO3nW5gik5+Yj/C2NUmw6QSQaZjn1SrJyJfV1Q5vYJqrqvtRDJLeej3qfNGY5irTgekdFrFciqUb7zLJeiXL1p2XnfucZ7wAh8eF5DhOs1Osj5geApB8HvPOoUuNMrHYZfnEqsBFSzg=
Date: Fri, 30 May 2008 22:52:44 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc1-$sha1: RIP __d_lookup+0x8c/0x160
Message-ID: <20080530185244.GA4776@martell.zuzino.mipt.ru>
References: <20080505055940.GA4950@martell.zuzino.mipt.ru> <20080505065830.GA539@linux.vnet.ibm.com> <20080509092247.GA10927@martell.zuzino.mipt.ru> <20080509101238.GC29205@linux.vnet.ibm.com> <20080530055406.GA774@martell.zuzino.mipt.ru> <20080530065427.GC4943@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080530065427.GC4943@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 11:54:27PM -0700, Paul E. McKenney wrote:
> On Fri, May 30, 2008 at 09:54:06AM +0400, Alexey Dobriyan wrote:
> > On Fri, May 09, 2008 at 03:12:38AM -0700, Paul E. McKenney wrote:
> > > On Fri, May 09, 2008 at 01:22:47PM +0400, Alexey Dobriyan wrote:
> > > > On Sun, May 04, 2008 at 11:58:30PM -0700, Paul E. McKenney wrote:
> > > > > On Mon, May 05, 2008 at 09:59:40AM +0400, Alexey Dobriyan wrote:
> > > > > > Workload is build all arm defconfigs and all powerpc defconfigs and
> > > > > > something else in parallel from one source tree using O= and with
> > > > > > empty .ccache on ext2/noatime partition.
> > > > > > 
> > > > > > PREEMPT_RCU was again in use to do final check of Jens's patch (see URL)
> > > > > > 
> > > > > > Kernel is afa26be86b65a7183ceac29bdf1f51d6fc6932f0 + CFQ fixlet
> > > > > > http://marc.info/?l=linux-kernel&m=120946003120291&w=2 .
> > > > > > 
> > > > > > Oops, disassembly and .config (DEBUG_INFO was turned off) below.
> > > > > > 
> > > > > > Should we add PREEMPT_RCU to oops reports, BTW?
> > > > > 
> > > > > Given that you see it with PREEMPT_RCU, but not classic RCU, that would
> > > > > make sense...
> > > > > 
> > > > > I presume that this version of the kernel has the fixes from this thread
> > > > > applied?
> > > > > 
> > > > > 	http://lkml.org/lkml/2008/4/19/85
> > > > 
> > > > I recall two fixes from this thread: list.h one and text_poke() one. And
> > > > they were applied before 2.6.26-rc1. Were there anything else?
> > > 
> > > Those are the two I am aware of.
> > 
> > Triggered second time with 2.6.24-rc4.
> > 
> > FWIW, workload was LTP in infinite loop + parallel compiling on 170 configs
> > with make O=../ on ext2
> > Core 2 Duo, 4G RAM, PREEMPT/PREEMPT_RCU, HZ=1000
> 
> Thank you for the info!
> 
> So you have 170 concurrent "make O=../" builds running, with them all
> putting their .o files in a common directory?

No, of course, not. :-) It's like this:

	src
	build/config-1/
	build/config-2/
		...
	.ccache/
		[.ccache stuff]
all in one ext2/noatime disk.

So the command line is like O=../build/$TARGET

> Are you using 170 specific configurations, or are the all running randconfig?

Very specific but this shouldn't matter. Some are fat (sparc64 allmodconfig),
some are nimble (arm defconfigs). loadavg is around 210 at the start.

