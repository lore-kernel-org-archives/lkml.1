Return-Path: <linux-kernel-owner+w=401wt.eu-S1760117AbZCTSdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117AbZCTSdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 14:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbZCTSdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 14:33:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42500 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758131AbZCTSdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 14:33:15 -0400
Date: Fri, 20 Mar 2009 19:32:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 01/11] Introducing generic hardware breakpoint handler
	interfaces
Message-ID: <20090320183210.GC31629@elte.hu>
References: <20090319234804.GB10517@in.ibm.com> <Pine.LNX.4.44L0.0903201006120.2686-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903201006120.2686-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Stern <stern@rowland.harvard.edu> wrote:

> > +	/* Check that the virtual address is in the proper range */
> > +	if (tsk) {
> > +		if (!arch_check_va_in_userspace(bp->info.address, tsk))
> > +			return -EFAULT;
> > +	} else {
> > +		if (!arch_check_va_in_kernelspace(bp->info.address))
> > +			return -EFAULT;
> > +	}
> 
> Roland pointed out that these checks need to take into account the 
> length of the breakpoint.  For example, in 
> arch_check_va_in_userspace() it isn't sufficient for the start of 
> the breakpoint region to be a userspace address; the end of the 
> breakpoint region must also be in userspace.

i pointed it out - but yes, this needs to be fixed.

	Ingo
