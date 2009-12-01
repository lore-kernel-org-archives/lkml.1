Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZLAM5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZLAM5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 07:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbZLAM5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 07:57:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44477 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbZLAM5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 07:57:21 -0500
Date: Tue, 1 Dec 2009 13:55:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sripathi Kodi <sripathik@in.ibm.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [RFC] [PATCH 0/2] Futex fault injection
Message-ID: <20091201125537.GA23382@elte.hu>
References: <20091201141642.398e7b7d@sripathi>
 <20091201103351.GA6685@elte.hu>
 <1259664883.1697.28.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259664883.1697.28.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-12-01 at 11:33 +0100, Ingo Molnar wrote:
> > * Sripathi Kodi <sripathik@in.ibm.com> wrote:
> > 
> > > Hi,
> > > 
> > > This patch set adds fault injection for futex subsystem. It adds 
> > > faults at places where reading/writing from user space can return 
> > > EFAULT. This will be useful in testing any significant change to futex 
> > > subsystem.
> > 
> > Instead of this unacceptably ugly and special-purpose debugfs 
> > interface, please extend perf events to allow event injection. Some 
> > other places in the kernel (which deal with rare events) want/need 
> > this capability too.
> 
> Thing is, he's using the 'normal' fault injection code to do this, I 
> see no objection to doing that.

Yes - but its impact to the futex code is butt-ugly. That some facility 
is in the kernel does not mean it gets a free pass to be applied 
everywhere and anywhere.

An example of that would be tracepoints - there's no free pass to add 
tracepoints in new places and some maintainers elect to use different 
facilities. (or reject all current facilities)

> If you want to redo the fault injection subsystem, then that's another 
> story, but then we need to convert all of its users over.

What i want to see is sane code in futex.c. If we add hooks/callbacks 
i'd like it to be a complete solution helping a lot of usecases not some 
limited approach helping testability only.

Thanks,

	Ingo
