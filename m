Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbXGNQ0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbXGNQ0d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 12:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991AbXGNQ00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 12:26:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42108 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbXGNQ0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 12:26:25 -0400
Date: Sat, 14 Jul 2007 17:26:19 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net
Subject: Re: [patch 5/8] Immediate Values - kprobe header fix
Message-ID: <20070714162619.GC13831@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	prasanna@in.ibm.com, ananth@in.ibm.com,
	anil.s.keshavamurthy@intel.com, davem@davemloft.net
References: <20070714012439.285079881@polymtl.ca> <20070714012624.150971859@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714012624.150971859@polymtl.ca>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 09:24:44PM -0400, Mathieu Desnoyers wrote:
> Since the immediate values depend on the same int3 handler as kprobes implements
> for i386, we have to get architecture specific defines available for the kprobes
> trap handler (especially restore_interrupts()) wven when CONFIG_KPROBES is not
> selected.
> 
> That kind of ifdef around a whole header does not make sense in the first place
> anyway.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: prasanna@in.ibm.com
> CC: ananth@in.ibm.com
> CC: anil.s.keshavamurthy@intel.com
> CC: davem@davemloft.net
> ---
>  include/linux/kprobes.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/include/linux/kprobes.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/kprobes.h	2007-07-13 18:47:57.000000000 -0400
> +++ linux-2.6-lttng/include/linux/kprobes.h	2007-07-13 18:48:45.000000000 -0400
> @@ -36,9 +36,9 @@
>  #include <linux/spinlock.h>
>  #include <linux/rcupdate.h>
>  
> -#ifdef CONFIG_KPROBES
>  #include <asm/kprobes.h>

but this one isn't available on architectures that don't have kprobes,
so you can't include linux/kprobes.h in generic code without ifdef
protection anymore.

I'd say move the code to asm/kdebug.h if it's need by more than just
kprobes.

