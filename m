Return-Path: <linux-kernel-owner+w=401wt.eu-S1751963AbXCOUhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbXCOUhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXCOUhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:37:32 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:12579 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbXCOUhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:37:31 -0400
X-AuditID: d80ac287-9e3d5bb000000de9-1d-45f9ae8a9306 
Date: Thu, 15 Mar 2007 20:37:29 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dan Aloni <da-x@monatomic.org>, linux-kernel@vger.kernel.org
Subject: Re: thread stacks and strict vm overcommit accounting
In-Reply-To: <20070315110621.9a9defaf.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703152021130.21129@blonde.wat.veritas.com>
References: <20070313163320.GA28104@localdomain> <20070315110621.9a9defaf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 15 Mar 2007 20:37:30.0191 (UTC) FILETIME=[C067C5F0:01C76741]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Andrew Morton wrote:
> > On Tue, 13 Mar 2007 18:33:20 +0200 Dan Aloni <da-x@monatomic.org> wrote:
> > 
> > This question is relevent to 2.6.20.
> > 
> > I noticed that if the RSS for the stack size is say, 8MB, running

I think you meant to say RLIMIT_STACK rather than RSS, didn't you, Dan?

> > a single-threaded process doesn't incur an increase of 8MB to
> > Committed_AS (/proc/meminfo).

Stack RSS should certainly be included in Committed_AS,
but RLIMIT_STACK merely limits how big the stack vma may grow to:
at any moment the stack vma is probably very much smaller,
and only its current size is accounted in Committed_AS.

> > 
> > However, on multi-threaded apps linked with pthread (on Debian
> > Etch with 2.6.20 vanilla x86_64), every thread will incur the
> > the specified maximum stack size RSS (assuming that you use
> > the default attr). In other words, it appears that vm accounting
> > works differently in that case.

I'm guessing that the pthread stacks are mmap'ed as greatest extents
(probably because that's the easiest way to keep them apart), rather
than as small MAP_GROWSDOWN areas to be expanded later on fault.
If so, then those would indeed account the maximum in Committed_AS.

> > 
> > Is this the intended behaviour?
> 
> That sounds like a bug to me.

I'm suspecting it's an oddity rather than a bug.

Hugh
