Return-Path: <linux-kernel-owner+w=401wt.eu-S1751812AbZL3FPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbZL3FPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 00:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbZL3FPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 00:15:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:31731 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZL3FPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 00:15:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="227701634"
Date: Wed, 30 Dec 2009 13:15:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [RFC][PATCH] Disabling read-ahead makes I/O of large reads
	small
Message-ID: <20091230051540.GA16308@localhost>
References: <20091225000717.GA26949@yahoo-inc.com> <87aax18xms.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aax18xms.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Wed, Dec 30, 2009 at 02:04:43AM +0800, Andi Kleen wrote:
> Quentin Barnes <qbarnes+nfs@yahoo-inc.com> writes:
> 
> cc fengguang who is Mr.Readahead. The full description+patch
> is in the archives.

Thank you for the CC.

> > In porting some application code to Linux, its performance over
> > NFSv3 on Linux is terrible.  I'm posting this note to LKML since
> > the problem was actually tracked back to the VFS layer.
> [...]
> > I have no idea if my patch is the appropriate fix.  I'm well out of
> > my area in this part of the kernel.  It solves this one problem, but
> > I have no idea how many boundary cases it doesn't cover or even if
> > it is the right way to go about addressing this issue.
> >
> > Is this behavior of shorting I/O of read(2) considered a bug?  And
> > is this approach for a fix approriate?
> 
> It sounds like a (performance) bug to me.

Yes it's a bug. It hit my mind in some early days.. I should be blamed
to lose track of it.

> >From a quick look your fix looks reasonable to me.

Yes, it's reasonable to directly call force_page_cache_readahead() in
this case.

However the ra_pages=0 trick in fadvise also asks for fix. We'd better
let it set a readahead flag, because ra_pages=0 is used in many other
places to really disable the (heuristic|force) readahead. See the
second patch's description for more details.

Thanks,
Fengguang
