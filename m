Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbZEIK6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbZEIK6s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 06:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbZEIK6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 06:58:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:59669 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbZEIK6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 06:58:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,320,1239001200"; 
   d="scan'208";a="141000818"
Date: Sat, 9 May 2009 18:57:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [patch] tracing/mm: add page frame snapshot trace
Message-ID: <20090509105742.GA8398@localhost>
References: <20090508105320.316173813@intel.com> <20090508111031.020574236@intel.com> <20090508114742.GB17129@elte.hu> <20090508124433.GB15949@localhost> <20090509062758.GB21354@elte.hu> <20090509091325.GA7994@localhost> <20090509100137.GC20941@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509100137.GC20941@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 06:01:37PM +0800, Ingo Molnar wrote:
> 
> * Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > 2) support concurrent object iterations
> >    For example, a huge 1TB memory space can be split up into 10
> >    segments which can be queried concurrently (with different options).
> 
> this should already be possible. If you lseek the trigger file, that 
> will be understood as an 'offset' by the patch, and then write a 
> (decimal) value into the file, that will be the count.
> 
> So it should already be possible to fork off nr_cpus helper threads, 
> one bound to each CPU, each triggering trace output of a separate 
> segment of the memory map - and each reading that CPU's 
> trace_pipe_raw file to recover the data - all in parallel.

How will this work out in general? More examples, when walking pages
by file/process, is it possible to divide the files/processes into N
sets, and dump their pages concurrently? When walking the (huge) inode
lists of different superblocks, is it possible to fork one thread for
each superblock?

In the above situations, they would demand concurrent instances with
different filename/pid/superblock options.
