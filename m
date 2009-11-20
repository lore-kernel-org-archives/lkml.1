Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbZKTR71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbZKTR71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbZKTR7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:59:25 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59093 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850AbZKTR7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:59:23 -0500
X-Greylist: delayed 2212 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 12:58:46 EST
Date: Fri, 20 Nov 2009 17:25:42 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: rostedt@goodmis.org, Nicholas Mc Guire <der.herr@hofr.at>,
       zhangfx@lemote.com, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH v9 10/10] tracing: make function graph tracer work with
	-mmcount-ra-address
Message-ID: <20091120172542.GJ6869@linux-mips.org>
References: <cover.1258719323.git.wuzhangjin@gmail.com> <7f3448d0d795a7f60dc9731e95123ae9e0f4d56a.1258719323.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f3448d0d795a7f60dc9731e95123ae9e0f4d56a.1258719323.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 08:34:38PM +0800, Wu Zhangjin wrote:

> That thread "MIPS: Add option to pass return address location to
> _mcount" from "David Daney <ddaney@caviumnetworks.com>" have added a new
> option -mmcount-ra-address to gcc(4.5) for MIPS to transfer the location
> of the return address to _mcount.
> 
> Benefit from this new feature, function graph tracer on MIPS will be
> easier and safer to hijack the return address of the kernel function,
> which will save some overhead and make the whole thing more reliable.
> 
> In this patch, at first, try to enable the option -mmcount-ra-address in
> arch/mips/Makefile with cc-option, if gcc support it, it will be
> enabled, otherwise, no side effect.
> 
> and then, we need to support this new option of gcc 4.5 and also support
> the old gcc versions.
> 
> with _mcount in the old gcc versions, it's not easy to get the location
> of return address(tracing: add function graph tracer support for MIPS),
>    so, we do it in a C function: ftrace_get_parent_addr(ftrace.c), but
>    with -mmcount-ra-address, only several instructions need to get what
>    we want, so, I put into asm(mcount.S). and also, as the $12(t0) is
>    used by -mmcount-ra-address for transferring the localtion of return
>    address to _mcount, we need to save it into the stack and restore it
>    when enabled dynamic function tracer, 'Cause we have called
>    "ftrace_call" before "ftrace_graph_caller", which may destroy
>    $12(t0).
> 
> (Thanks to David for providing that -mcount-ra-address and giving the
>  idea of KBUILD_MCOUNT_RA_ADDRESS, both of them have made the whole
>  thing more beautiful!)
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>

Queued for 2.6.33 but due to patch 3/3 I won't propagate this series
immediately to linux-next.

Thanks!

  Ralf
