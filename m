Return-Path: <linux-kernel-owner+w=401wt.eu-S2992443AbXCOXmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992443AbXCOXmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 19:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992432AbXCOXmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 19:42:35 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:46093 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992443AbXCOXme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 19:42:34 -0400
Date: Fri, 16 Mar 2007 01:42:26 +0200
From: Dan Aloni <da-x@monatomic.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: thread stacks and strict vm overcommit accounting
Message-ID: <20070315234225.GA5509@localdomain>
References: <20070313163320.GA28104@localdomain> <20070315110621.9a9defaf.akpm@linux-foundation.org> <Pine.LNX.4.64.0703152021130.21129@blonde.wat.veritas.com> <20070315233343.662b019c@lxorguk.ukuu.org.uk> <20070315153613.3d2eaf10.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315153613.3d2eaf10.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-PopBeforeSMTPSenders: da-x@monatomic.org
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 03:36:13PM -0700, Andrew Morton wrote:
> 
> > > > > Is this the intended behaviour?
> > > > 
> > > > That sounds like a bug to me.
> > > 
> > > I'm suspecting it's an oddity rather than a bug.
> > 
> > It is intended behaviour.
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

Perhaps it makes a lot of sense if you regard stack growth at 
the same sense that you regard heap growth by the means of brk(). 

Just by the fact that the stack is limited on default and RLIMIT_DATA 
is unlimited, doesn't mean the we need to account for the maximum
stack size. 

Perhaps for embedded systems where you want to have overcommit_memory=2 
overcommit_ratio=100 and no swap (for design constraints), just to make
sure that allocations fail *always before* OOM gets triggered (and 
therefore OOM never gets triggered, thankfully), it would have been
useful to look at Commited_AS to realize how much the system is close 
to the maximum memory utilization potential.

Learning about this 'oddity' in Commited_AS, I'd guess it would be 
better for me not to rely on it for measurements and perhaps tweak 
smaller values of RSS_STACK for processes on that embedded system.

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
