Return-Path: <linux-kernel-owner+w=401wt.eu-S934931AbXJPSCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934931AbXJPSCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934653AbXJPSA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:00:56 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3698 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934676AbXJPSAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:00:54 -0400
Date: Tue, 16 Oct 2007 19:00:37 +0100
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
Message-ID: <20071016180037.GC5670@shadowen.org>
References: <47144B4F.3050108@linux.vnet.ibm.com> <20071016091012.GB24341@elte.hu> <20071016094631.GA10649@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016094631.GA10649@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 11:46:31AM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> > 
> > > While running kernbench with the 2.6.23-git8 following oops is 
> > > produced
> > > 
> > > Unable to handle kernel NULL pointer dereference at 0000000000000010 RIP: 
> > >  [<ffffffff8033f347>] __rb_rotate_left+0x7/0x70
> > 
> > that looks nasty ...
> > 
> > and -git8 should have the v2.6.23 scheduler code in essence.
> 
> ah, this is likely with the recent scheduler commits included as well, 
> right?
> 
> if it's reproducable, could you try with group scheduling disabled, i.e. 
> with:
> 
>   # CONFIG_FAIR_GROUP_SCHED is not set
> 
> as that would be the main suspect for such type of a crash.

Ok, preliminary results with this disabled seem to get us past
kernbench.  I am rerunning with it enabled to confirm it blammo's.

-apw
