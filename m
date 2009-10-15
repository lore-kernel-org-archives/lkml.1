Return-Path: <linux-kernel-owner+w=401wt.eu-S1763343AbZJOXox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763343AbZJOXox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 19:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763325AbZJOXox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 19:44:53 -0400
Received: from ozlabs.org ([203.10.76.45]:41073 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763256AbZJOXow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 19:44:52 -0400
Date: Fri, 16 Oct 2009 10:41:26 +1100
From: Anton Blanchard <anton@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, paulus@samba.org, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: perf report fractal output issue
Message-ID: <20091015234126.GI4808@kryten>
References: <20091014225726.GF4808@kryten> <20091015122839.GA4960@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015122839.GA4960@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> > It looks like callchain__fprintf_graph() only prints the callchain if we
> > have at least one rb entry at the top. In my case all the associated
> > backtraces are identical so I assume we dont have to do any splitting.
>
> Hmm, could you please send me a perf.data where you can see that?
> Does that only happen on powerpc?

I can replicate this on x86 by taking a perf.data and truncating it
after the first sample+backtrace:


# wget http://samba.org/~anton/perf_truncated.test


# perf report -i perf_truncated.test -g fractal
...
   100.00%     perf  [kernel]       [k] native_write_msr_safe


# perf report -i perf_truncated.test -g flat
...
   100.00%     perf  [kernel]       [k] native_write_msr_safe
           100.00%
                native_write_msr_safe
                intel_pmu_enable_all
                hw_perf_enable
                perf_enable
                __perf_counter_enable
                smp_call_function_single
                task_oncpu_function_call
                perf_counter_enable
                perf_counter_for_each_child
                perf_ioctl
                vfs_ioctl
                do_vfs_ioctl
                sys_ioctl
                system_call_fastpath
                0x7f00c1857537
