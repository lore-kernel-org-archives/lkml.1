Return-Path: <linux-kernel-owner+w=401wt.eu-S932974AbXJQJIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974AbXJQJIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 05:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXJQJID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 05:08:03 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2777 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbXJQJIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 05:08:01 -0400
Date: Wed, 17 Oct 2007 10:07:53 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.23-git8 kernel oops at __rb_rotate_left+0x7/0x70
Message-ID: <20071017090753.GH2657@shadowen.org>
References: <47144B4F.3050108@linux.vnet.ibm.com> <20071016091012.GB24341@elte.hu> <20071016094631.GA10649@elte.hu> <20071016180037.GC5670@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016180037.GC5670@shadowen.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 07:00:37PM +0100, Andy Whitcroft wrote:
> On Tue, Oct 16, 2007 at 11:46:31AM +0200, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> > > 
> > > > While running kernbench with the 2.6.23-git8 following oops is 
> > > > produced
> > > > 
> > > > Unable to handle kernel NULL pointer dereference at 0000000000000010 RIP: 
> > > >  [<ffffffff8033f347>] __rb_rotate_left+0x7/0x70
> > > 
> > > that looks nasty ...
> > > 
> > > and -git8 should have the v2.6.23 scheduler code in essence.
> > 
> > ah, this is likely with the recent scheduler commits included as well, 
> > right?
> > 
> > if it's reproducable, could you try with group scheduling disabled, i.e. 
> > with:
> > 
> >   # CONFIG_FAIR_GROUP_SCHED is not set
> > 
> > as that would be the main suspect for such type of a crash.
> 
> Ok, preliminary results with this disabled seem to get us past
> kernbench.  I am rerunning with it enabled to confirm it blammo's.

A rerun with it enabled however ran to completion.  So I think we have
to assume this is at best not 100% reproducible.  Seems that more
directed testing is going on now.

-apw
