Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0CEPw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:52:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534Ab0CEPwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:52:22 -0500
Date: Fri, 5 Mar 2010 12:51:50 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Add multiple event support to perf report V2
Message-ID: <20100305155150.GB20213@ghostprotocols.net>
References: <cover.1267630395.git.ebmunson@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1267630395.git.ebmunson@us.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 03, 2010 at 03:38:22PM +0000, Eric B Munson escreveu:
> Currently perf report is unable to handle multiple events even though
> perf record is capable of capturing such a stream.  For instance if we run
> 'perf record -e dtlb-misses -e cache-misses sleep 5'
> today and then ask report to show the results we get:
> 
> # Samples: 18866
> #
> # Overhead  Command      Shared Object  Symbol
> # ........  .......  .................  ......
> #
>     47.52%    sleep  [kernel.kallsyms]  [k] page_fault
>     32.93%    sleep  [kernel.kallsyms]  [k] locks_remove_posix
>      8.52%    sleep  [kernel.kallsyms]  [k] acl_permission_check
>      3.46%    sleep  [kernel.kallsyms]  [k] __wake_up_bit
>      3.31%    sleep  [kernel.kallsyms]  [k] vfs_read
>      3.23%    sleep  [kernel.kallsyms]  [k] kmem_cache_alloc
>      0.56%    sleep  [kernel.kallsyms]  [k] get_page_from_freelist
>      0.15%    sleep  [kernel.kallsyms]  [k] pipe_read
>      0.13%    sleep  [kernel.kallsyms]  [k] pipe_lock_nested
>      0.13%    sleep  [kernel.kallsyms]  [k] mm_alloc
>      0.06%    sleep  [kernel.kallsyms]  [k] mm_init
> #
> # (For a higher level overview, try: perf report --sort comm,dso)
> #
> 
> Worse than only reporting on one of the events, perf report has
> summed the two events. i.e. There is no distinguishing between
> dtlb-misses and cache-misses.
> 
> This set of patches addresses this problem and now when perf report
> is run with the same event stream that produced the above report, the
> output is this:

Thanks a lot, pulled and pushed out!

- Arnaldo
