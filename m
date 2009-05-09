Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbZEIK2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbZEIK2a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 06:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbZEIK2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 06:28:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48583 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbZEIK2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 06:28:20 -0400
Date: Sat, 9 May 2009 12:27:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [patch] tracing/mm: add page frame snapshot trace
Message-ID: <20090509102751.GA15726@elte.hu>
References: <20090508105320.316173813@intel.com> <20090508111031.020574236@intel.com> <20090508114742.GB17129@elte.hu> <20090508124433.GB15949@localhost> <20090509062758.GB21354@elte.hu> <20090509091325.GA7994@localhost> <20090509100137.GC20941@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509100137.GC20941@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > 2) support concurrent object iterations
> >    For example, a huge 1TB memory space can be split up into 10
> >    segments which can be queried concurrently (with different options).
> 
> this should already be possible. If you lseek the trigger file, 
> that will be understood as an 'offset' by the patch, and then 
> write a (decimal) value into the file, that will be the count.
> 
> So it should already be possible to fork off nr_cpus helper 
> threads, one bound to each CPU, each triggering trace output of a 
> separate segment of the memory map - and each reading that CPU's 
> trace_pipe_raw file to recover the data - all in parallel.

And note that trace_pipe_raw supports splice(), while 
/proc/{kpageflags|kpagecount} does not, so the output side might 
probably be a bit faster than the /proc method.

	Ingo
