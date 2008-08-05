Return-Path: <linux-kernel-owner+w=401wt.eu-S1761489AbYHEPuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761489AbYHEPuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbYHEPuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:50:00 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:24462 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbYHEPt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:49:59 -0400
Subject: Re: s390 hugetlb oops with libhugetlbfs test-suite
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: schwidefsky@de.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       agl@us.ibm.com
In-Reply-To: <20080729214638.GA20641@us.ibm.com>
References: <20080725211035.GA19738@us.ibm.com>
	 <20080726033254.GA3810@us.ibm.com> <20080726034127.GA8338@us.ibm.com>
	 <1217352163.4829.25.camel@localhost.localdomain>
	 <20080729214638.GA20641@us.ibm.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 17:49:32 +0200
Message-Id: <1217951372.5032.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 14:46 -0700, Nishanth Aravamudan wrote:
> Beyond the counters case, I saw one other issue on s390 (haven't
> confirmed if it happens anywhere else), the icache-hygiene test, when
> run manually a few times, will fail every so often claiming that one of
> the mmap()s returned ENOMEM. I haven't had time to track that down yet,
> but it might be because of the address space layout and the size of the
> hugepage on s390.

I have posted a patch that will fix the counters oops. So far, I could
not reproduce the icache-hygiene problem, did you use hardware large page
support or software emulation? But I probably noticed a similar one:

map_high_truncate_2 (32):       FAIL    mmap() 1: Cannot allocate memory

That one should be because of the 31-bit address space layout on s390,
as it tries to mmap too much (1.5GB).

I also noticed that task-size-overrun (64) seems to hang up on my system,
I can only continue after ctrl+c, can you verify that?

Thanks,
Gerald


