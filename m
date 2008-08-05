Return-Path: <linux-kernel-owner+w=401wt.eu-S1761656AbYHEQPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761656AbYHEQPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757279AbYHEQPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:15:03 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40978 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218AbYHEQPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:15:01 -0400
Date: Tue, 5 Aug 2008 09:14:56 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: schwidefsky@de.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       agl@us.ibm.com
Subject: Re: s390 hugetlb oops with libhugetlbfs test-suite
Message-ID: <20080805161456.GA7812@us.ibm.com>
References: <20080725211035.GA19738@us.ibm.com> <20080726033254.GA3810@us.ibm.com> <20080726034127.GA8338@us.ibm.com> <1217352163.4829.25.camel@localhost.localdomain> <20080729214638.GA20641@us.ibm.com> <1217951372.5032.21.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217951372.5032.21.camel@localhost.localdomain>
X-Operating-System: Linux 2.6.26-rc9-00132-g9df2fe9 (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.08.2008 [17:49:32 +0200], Gerald Schaefer wrote:
> On Tue, 2008-07-29 at 14:46 -0700, Nishanth Aravamudan wrote:
> > Beyond the counters case, I saw one other issue on s390 (haven't
> > confirmed if it happens anywhere else), the icache-hygiene test, when
> > run manually a few times, will fail every so often claiming that one of
> > the mmap()s returned ENOMEM. I haven't had time to track that down yet,
> > but it might be because of the address space layout and the size of the
> > hugepage on s390.
> 
> I have posted a patch that will fix the counters oops.

I'm guessing you've tested it, but I will go ahead and do so and
confirm.

> So far, I could not reproduce the icache-hygiene problem, did you use
> hardware large page support or software emulation?

It was the same box that produce the counters oops, so I'm guessing
software emulation?

> But I probably noticed a similar one:
> 
> map_high_truncate_2 (32):       FAIL    mmap() 1: Cannot allocate memory
> 
> That one should be because of the 31-bit address space layout on s390,
> as it tries to mmap too much (1.5GB).

Ah, that could easily be.

> I also noticed that task-size-overrun (64) seems to hang up on my
> system, I can only continue after ctrl+c, can you verify that?

I think that happens, yes, because of how many mmap's it takes to run
into the topmost mapping. I'll check it out.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
