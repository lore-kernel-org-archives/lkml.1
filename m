Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbZIANer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbZIANer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbZIANer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:34:47 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:49609 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531AbZIANeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:34:46 -0400
X-Trace: 255454216/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.116.211/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.116.211
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEAKe/nEpQKXTT/2dsb2JhbACBU9pyhBsF
X-IronPort-AV: E=Sophos;i="4.44,312,1249254000"; 
   d="scan'208";a="255454216"
Date: Tue, 1 Sep 2009 14:34:09 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Eric B Munson <ebmunson@us.ibm.com>
cc: Arnd Bergman <arnd@arndb.de>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, linux-man@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@gmail.com>, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/3] Add MAP_HUGETLB for mmaping pseudo-anonymous huge
 page regions
In-Reply-To: <20090901130801.GB7995@us.ibm.com>
Message-ID: <Pine.LNX.4.64.0909011418490.8674@sister.anvils>
References: <cover.1251282769.git.ebmunson@us.ibm.com>
 <1c66a9e98a73d61c611e5cf09b276e954965046e.1251282769.git.ebmunson@us.ibm.com>
 <1721a3e8bdf8f311d2388951ec65a24d37b513b1.1251282769.git.ebmunson@us.ibm.com>
 <Pine.LNX.4.64.0908312036410.16402@sister.anvils> <20090901094635.GA7995@us.ibm.com>
 <Pine.LNX.4.64.0909011128530.16601@sister.anvils> <20090901130801.GB7995@us.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Sep 2009, Eric B Munson wrote:
> On Tue, 01 Sep 2009, Hugh Dickins wrote:
> > 
> > That is explained by you #defining MAP_HUGETLB in include/asm-generic/
> > mman-common.h to a number which is already being used for other MAP_s
> > on some architectures.  That's a separate bug which needs to be fixed
> > by distributing the MAP_HUGETLB definition across various asm*/mman.h.
> 
> Would it be okay to keep the define in include/asm-generic/mman.h
> if a value that is known free across all architectures is used?
> 0x080000 is not used by any arch and, AFAICT would work just as well.

That's a very sensible suggestion, but departs from how we have
assigned new numbers up until now: so include/asm-generic/mman-common.h
isn't actually where we'd expect to find a Linux-specific MAP_ define.

I'd say, yes, do that for now, so as not to hit this conflict while
testing in mmotm.  But whether it should stay that way, or later the
arch/*/include/asm/mman.h's be updated as I'd imagined, I don't know.

Arnd, Michael, do you have any views on this?

Thanks,
Hugh
