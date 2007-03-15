Return-Path: <linux-kernel-owner+w=401wt.eu-S932330AbXCOXIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbXCOXIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 19:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbXCOXIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 19:08:43 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:62854 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbXCOXIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 19:08:42 -0400
X-AuditID: d80ac287-a246cbb000000de9-27-45f9d1fa45db 
Date: Thu, 15 Mar 2007 23:08:40 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dan Aloni <da-x@monatomic.org>,
       linux-kernel@vger.kernel.org
Subject: Re: thread stacks and strict vm overcommit accounting
In-Reply-To: <20070315153613.3d2eaf10.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703152258530.9602@blonde.wat.veritas.com>
References: <20070313163320.GA28104@localdomain> <20070315110621.9a9defaf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703152021130.21129@blonde.wat.veritas.com>
 <20070315233343.662b019c@lxorguk.ukuu.org.uk> <20070315153613.3d2eaf10.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 15 Mar 2007 23:08:41.0662 (UTC) FILETIME=[DF6C65E0:01C76756]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Andrew Morton wrote:
> On Thu, 15 Mar 2007 23:33:43 +0000
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > Stack RSS should certainly be included in Committed_AS,
> > > but RLIMIT_STACK merely limits how big the stack vma may grow to:
> > > at any moment the stack vma is probably very much smaller,
> > > and only its current size is accounted in Committed_AS.
> > 
> > With a typical size as a fuzz factor preaccounted in later kernels.
> 
> Where's that done?

I don't know what Alan is referring to there.

> 
> > > > > Is this the intended behaviour?
> > > > 
> > > > That sounds like a bug to me.
> > > 
> > > I'm suspecting it's an oddity rather than a bug.
> > 
> > It is intended behaviour.

Intended in the way the different stacks are implemented,
but odd enough for us to wonder at the difference.

> 
> Each instance of
> 
> main()
> {
> 	sleep(100);
> }
> 
> appears to increase Committed_AS by around 200kb.  But we've committed to
> providing it with 8MB for stack.
> 
> How come this is correct?

We've no more committed to providing each instance with 8MB of stack,
than we've committed to providing each instance with RLIMIT_AS of
address space.  The rlimits are limits, not commitments, surely?

Hugh
