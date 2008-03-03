Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbYCCMcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbYCCMcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYCCMb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:31:59 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:22551 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbYCCMb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:31:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kFGuDKkwpIJ7ixChgHP/bQoM2A/jeRjrmlY26Os1stVzVDrNBExhoVsAHW4Y5hVDOHtEmBlfz1sNVFfB+qBvoIaP7GTckowbCTlDwwcgHFuZivNw/hsWn9+r7iukR3zWvq1/ZaKQLT/ncqssG1mYy2RQP+wEMExeRHiOsnOmDDM=
Message-ID: <cfd18e0f0803030431n69df391dw53843d5079d906dd@mail.gmail.com>
Date: Mon, 3 Mar 2008 13:31:54 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: SCHED_IDLE documentation
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Christoph Hellwig" <hch@lst.de>,
       cbe-oss-dev@ozlabs.org, "Jeremy Kerr" <jk@ozlabs.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080303092422.GA18281@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203376368.275756.252634247263.1.gpush@pokey>
	 <200803030612.28039.arnd@arndb.de> <20080303051719.GA26102@lst.de>
	 <200803030721.52869.arnd@arndb.de> <20080303073311.GB5934@elte.hu>
	 <cfd18e0f0803030040l667dd2b7v6298e78c5b21bfec@mail.gmail.com>
	 <20080303092422.GA18281@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

> > * What's the difference between SCHED_IDLE and SCHED_BATCH?
>
> SCHED_BATCH can still have nice levels from -20 to +19, it is a modified
> SCHED_OTHER/SCHED_NORMAL for "throughput oriented" workloads.

So, suppose we have two CPU intensive jobs, one SCHED_OTHER and the
other SCHED_BATCH.  If they have the same nice value, will/should the
scheduler favour one over the other?

I've done some testing on 2.6.25-rc2, x86-32 for this case, and it
appears that the two jobs are treated the same by the scheduler (each
gets 50% of CPU).  Is that expected behavior?  If it is, can you give
an example where scheduling SCHED_OTHER versus SCHED_BATCH should show
a difference in the amount of CPU received by each process?

> SCHED_IDLE overrides the nice settings and it means a "super idle"
> workload.

Tested on 2.6.25-rc2, x86-32.  Two CPU intensive jobs, one
SCHED_OTHER, nice=+19, the other SCHED_IDLE.  The SCHED_OTHER job gets
~88% of CPU.  So SCHED_IDLE does indeed give a "super low nice"
effect.

Cheers,

Michael

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
