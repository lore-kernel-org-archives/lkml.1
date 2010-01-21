Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570Ab0AUNUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab0AUNUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164Ab0AUNUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:20:23 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:58414 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab0AUNUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:20:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ebd12Rg2akQG9aQmnRWKUgx6app13hy5eSBM7pVshR+JXAcqYtl/oEZKX84AMTBZAN
         M7GiaN7PmoaPDjQoKIN9anKQdgIJeusCe7034FiP+WV6ixQZ947+6IQ1TlE4Bkj6PfI5
         Gn73UimW9pr3S8Kjs/53wUEFzXz3iPOjdE5gc=
Date: Thu, 21 Jan 2010 14:20:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Fix inconsistency between IP and callchain
	sampling
Message-ID: <20100121132014.GH5017@nowhere>
References: <20100118054707.GT12666@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118054707.GT12666@kryten>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 04:47:07PM +1100, Anton Blanchard wrote:
> 
> When running perf across all cpus with backtracing (-a -g), sometimes we
> get samples without associated backtraces:
> 
>     23.44%         init  [kernel]                     [k] restore
>     11.46%         init                       eeba0c  [k] 0x00000000eeba0c
>      6.77%      swapper  [kernel]                     [k] .perf_ctx_adjust_freq
>      5.73%         init  [kernel]                     [k] .__trace_hcall_entry
>      4.69%         perf  libc-2.9.so                  [.] 0x0000000006bb8c
>                        |          
>                        |--11.11%-- 0xfffa941bbbc
> 
> It turns out the backtrace code has a check for the idle task and the IP
> sampling does not. This creates problems when profiling an interrupt
> heavy workload (in my case 10Gbit ethernet) since we get no backtraces
> for interrupts received while idle (ie most of the workload).
> 
> Right now x86 and sh check that current is not NULL, which should never
> happen so remove that too.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>



I'm queuing it. Thanks.

