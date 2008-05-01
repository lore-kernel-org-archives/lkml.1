Return-Path: <linux-kernel-owner+w=401wt.eu-S1765641AbYEAWfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765641AbYEAWfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYEAWfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:35:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:43003 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932673AbYEAWfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:35:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,423,1204531200"; 
   d="scan'208";a="240773512"
Date: Thu, 1 May 2008 15:35:15 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       venkatesh.pallipadi@intel.com, davem@davemloft.net,
       trini@kernel.crashing.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Message-ID: <20080501223515.GA11366@linux-os.sc.intel.com>
References: <20080430013108.GA18207@linux-os.sc.intel.com> <20080429.212833.192304794.davem@davemloft.net> <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com> <20080501215633.GU29330@cs181133002.pp.htv.fi> <20080501152051.4eb4bad3.akpm@linux-foundation.org> <alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 03:27:26PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 1 May 2008, Andrew Morton wrote:
> > > 
> > > I see only the following choices:
> > > - remove __weak and replace all current usages
> > > - move all __weak functions into own files, and ensure that also happens
> > >   for future usages
> > > - #error for gcc 4.1.{0,1}
> > 
> > Can we detect the {0,1}?  __GNUC_EVEN_MORE_MINOR__?
> 
> It's __GNUC_PATCHLEVEL__, I believe.
> 
> So yes, we can distinguish 4.1.2 (good, and very common) from 4.1.{0,1} 
> (bad, and rather uncommon).
> 
> And yes, considering that 4.1.1 (and even more so 4.1.0) should be rare to 
> begin with, I think it's better to just not support it.
> 

Not sure whether #error on gcc 4.1.{0.1} is the right thing as I found atleast
one distro gcc which says itself as 4.1.1, do not exhibit the problem as it
most likely has fix backported.

Putting all weak functions in one file is something Suresh and I considered
before sending this patch. But, looking at various users of __weak, that
single file did not look very appropriate.

Thanks,
Venki
