Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbZCTSbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbZCTSbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 14:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbZCTSbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 14:31:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47492 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbZCTSbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 14:31:32 -0400
Date: Fri, 20 Mar 2009 19:30:58 +0100
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
Message-ID: <20090320183058.GB31629@elte.hu>
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
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Stern <stern@rowland.harvard.edu> wrote:

> > + * Kernel breakpoints grow downwards, starting from HB_NUM
> > + * 'hbkpt_kernel_pos' denotes lowest numbered breakpoint register occupied for
> > + * kernel-space request
> > + */
> > +unsigned int hbkpt_kernel_pos;
> 
> This doesn't make much sense.  All you need to know is which 
> registers are in use; all others are available.
> 
> For example, suppose the kernel allocated breakpoints 3, 2, and 1, 
> and then deallocated 2.  Then bp 2 would be available for use, 
> even though 2 > 1.

it's a high/low watermark mechanism. Yes, it's not an allocator that 
can allocate into a debug registrs 'hole', but it is a simple one 
that matches current hardware breakpoint usages and enables the 
kernel to utilize them as well - and keeps all the code simple.

	Ingo
