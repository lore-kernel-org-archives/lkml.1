Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbYG2VrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbYG2VrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 17:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbYG2VrC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 17:47:02 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55722 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbYG2VrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 17:47:00 -0400
Date: Tue, 29 Jul 2008 14:46:38 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: schwidefsky@de.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       agl@us.ibm.com
Subject: Re: s390 hugetlb oops with libhugetlbfs test-suite
Message-ID: <20080729214638.GA20641@us.ibm.com>
References: <20080725211035.GA19738@us.ibm.com> <20080726033254.GA3810@us.ibm.com> <20080726034127.GA8338@us.ibm.com> <1217352163.4829.25.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217352163.4829.25.camel@localhost.localdomain>
X-Operating-System: Linux 2.6.26-rc9-00132-g9df2fe9 (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.07.2008 [19:22:43 +0200], Gerald Schaefer wrote:
> On Fri, 2008-07-25 at 20:41 -0700, Nishanth Aravamudan wrote:
> > Odd, this is the same kernel as last time, which wasn't tainted. The reason for
> > the taint is the following:
> > 
> > ------------[ cut here ]------------
> > Badness at drivers/s390/cio/qdio_main.c:1361
> 
> Hi,
> 
> This was fixed by our qdio developer recently, but the fix is not yet
> upstream. However, I doubt that this is related to the hugetlbfs problem.

Yeah, it didn't seem related, and the first dump I posted didn't trigger
that badness.

> I was able to reproduce the "Bad page state", with the current libhugetlbfs
> development snapshot and your patch for s390. It only happened on machines
> with software large page emulation, but we certainly have a problem there.
> Thanks for reporting this bug and adding s390 support to libhugetlbfs, I
> will look into this problem.

Just FYI, I've merged up the patch that adds support and it is in the
latest development snapshot of libhugetlbfs:
http://libhugetlbfs.ozlabs.org/snapshots/libhugetlbfs-dev-20080729.tar.gz.
Beyond the counters case, I saw one other issue on s390 (haven't
confirmed if it happens anywhere else), the icache-hygiene test, when
run manually a few times, will fail every so often claiming that one of
the mmap()s returned ENOMEM. I haven't had time to track that down yet,
but it might be because of the address space layout and the size of the
hugepage on s390.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
