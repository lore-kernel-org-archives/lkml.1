Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbZFJMRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbZFJMRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbZFJMQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:16:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:30632 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbZFJMQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:16:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,341,1241420400"; 
   d="scan'208";a="152689760"
Date: Wed, 10 Jun 2009 20:16:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler
	in the VM v5
Message-ID: <20090610121645.GC5657@localhost>
References: <20090603846.816684333@firstfloor.org> <20090603184648.2E2131D028F@basil.firstfloor.org> <20090609100922.GF14820@wotan.suse.de> <Pine.LNX.4.64.0906091637430.13213@sister.anvils> <20090610083803.GE6597@localhost> <20090610085939.GE31155@wotan.suse.de> <20090610092010.GA32584@localhost> <20090610110305.GB3876@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610110305.GB3876@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 07:03:05PM +0800, Nick Piggin wrote:
> On Wed, Jun 10, 2009 at 05:20:11PM +0800, Wu Fengguang wrote:
> > On Wed, Jun 10, 2009 at 04:59:39PM +0800, Nick Piggin wrote:
> > > On Wed, Jun 10, 2009 at 04:38:03PM +0800, Wu Fengguang wrote:
> > > > On Wed, Jun 10, 2009 at 12:05:53AM +0800, Hugh Dickins wrote:
> > > > > I think a much more sensible approach would be to follow the page
> > > > > migration technique of replacing the page's ptes by a special swap-like
> > > > > entry, then do the killing from do_swap_page() if a process actually
> > > > > tries to access the page.
> > > > 
> > > > We call that "late kill" and will be enabled when
> > > > sysctl_memory_failure_early_kill=0. Its default value is 1.
> > > 
> > > What's the use of this? What are the tradeoffs, in what situations
> > > should an admin set this sysctl one way or the other?
> > 
> > Good questions.
> > 
> > My understanding is, when an application is generating data A, B, C in
> > sequence, and A is found to be corrupted by the kernel. Does it make
> > sense for the application to continue generate B and C? Or, are there
> > data dependencies between them? With late kill, it becomes more likely
> > that the disk contain new versions of B/C and old version of A, so
> > will more likely create data inconsistency.
> > 
> > So early kill is more safe.
> 
> Hmm, I think that's pretty speculative, and doesn't seem possible for
> an admin (or even kernel programmer) to choose the "right" value.
> 

Agreed. It's not easy to choose if I'm myself an admin ;)

> The application equally may not need to touch the data again, so
> killing it might cause some inconsistency in whatever it is currently
> doing.

Yes, early kill can also be evil. What I can do now is to document the
early kill parameter more carefully.

Thanks,
Fengguang

