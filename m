Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbZLaSsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbZLaSsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 13:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbZLaSsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 13:48:13 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:38168 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbZLaSsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 13:48:12 -0500
Date: Fri, 1 Jan 2010 00:18:04 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Patch 1/1] Introduce register_user_hbp_by_pid() and
	unregister_user_hbp_by_pid()
Message-ID: <20091231184804.GA3676@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20091217172010.GB5457@in.ibm.com> <20091217172253.GC5457@in.ibm.com> <20091218204744.GC5004@nowhere> <20091221184631.GB24535@in.ibm.com> <20091230222837.GI6322@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091230222837.GI6322@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 11:28:39PM +0100, Frederic Weisbecker wrote:
> On Tue, Dec 22, 2009 at 12:16:31AM +0530, K.Prasad wrote:
> > On Fri, Dec 18, 2009 at 09:47:48PM +0100, Frederic Weisbecker wrote:
> 
> > > And this function needs rcu too.
> > > 
> > > I don't see any in-kernel user for this new feature.
> > > That would be required to integrate it.
> > >
> > 
> > The proposed interfaces, as obvious, are mere wrappers over existing
> > (un)register_user_* interfaces, and don't do anything vastly different
> > in order to demonstrate them separately.
> > 
> > I can get a sample kernel module ready - that consumes pid and user-space
> > address to track write accesses, if you prefer it.
> 
> 
> Ok. The code looks good and useful.
> 
> But the usual philosophy in the kernel is to not add code
> that is left unused upstream. And samples don't substitute a user.
> I'm not sure this is a good idea to merge this.
>

Back to the old trick!...How about an ftrace plugin that accepts pid,
user-space address and memory access type and traces all the IP
addresses that caused access?

echo <pid>:<user_addr><access_type>  >  usym_trace_filter
echo 567:0x1234567:rw- > usym_trace_filter

Breakpoint	IP
------------	---------
567:0x1234567	0x0abcdef

I'm unsure if it sounds interesting at all, but I suspect it wouldn't be
as easy as above to gather the shown information through any existing
tools.

Thanks,
K.Prasad

