Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbYDDSE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbYDDSE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 14:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbYDDSEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 14:04:43 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60553 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbYDDSEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 14:04:42 -0400
Date: Fri, 4 Apr 2008 11:04:22 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Nish Aravamudan <nish.aravamudan@gmail.com>,
       Gurudas Pai <gurudas.pai@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlbpage.txt: correct overcommit caveat [Was Re:
	[BUG]:2.6.25-rc7 memory leak with hugepages.]
Message-ID: <20080404180422.GA19896@us.ibm.com>
References: <47EB4E2A.1040507@oracle.com> <20080327083849.GF15626@elte.hu> <47EB75C5.20207@oracle.com> <29495f1d0804032040h56f39051lcd5f707660d3c06c@mail.gmail.com> <20080404171638.GA17915@shadowen.org> <20080404173125.GE30117@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080404173125.GE30117@us.ibm.com>
X-Operating-System: Linux 2.6.25-rc3 (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.04.2008 [10:31:25 -0700], Nishanth Aravamudan wrote:
> On 04.04.2008 [18:16:38 +0100], Andy Whitcroft wrote:
> > On Thu, Apr 03, 2008 at 08:40:41PM -0700, Nish Aravamudan wrote:
> > 
> > > Hrm, fio is using SHM_HUGETLB. Does ipcs indicate maybe fio is not
> > > cleaning up the shared memory segment? FWIW, it seems like each run is
> > > using 400 hugepages in the SHM_HUGETLB segment, and then when you try
> > > to force the pool to shrink, it converts those 800 (since you ran fio
> > > twice) hugepages from static pool pages to dynamic (or overcommit)
> > > pages.
> > > 
> > > On another note, it is odd that we're using the dynamic pool, when it
> > > is initially disabled...I'll have to think about that.
> > > 
> > > I'll try and look at this later this evening or early tomorrow.
> > 
> > Yes that is an expected result.  We have no way to force the pool to
> > shrink when pages are in-use.  When a request is made to redoce the pool
> > below the number of in-use pages, we move the pages to surplus.  While
> > this does temporarily violate the overcommit cap, it does provide the
> > most utility as those pages will be returned to the buddy at the
> > earliest oppotunity.
> > 
> > I suspect the documenation could do with a little clarification.
> 
> 
> As shown by Gurudas Pai recently, we can put hugepages into the surplus
> state (by echo 0 > /proc/sys/vm/nr_hugepages), even when
> /proc/sys/vm/nr_overcommit_hugepages is 0. This is actually correct, to
> allow the original goal (shrink the static pool to 0) to succeed when it
> is possible for it two (we are converting hugepages to surplus because

s/when it is possible for it two//

Will fix in my copy.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
