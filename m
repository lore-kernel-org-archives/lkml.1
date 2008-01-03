Return-Path: <linux-kernel-owner+w=401wt.eu-S1759878AbYACCDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878AbYACCDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 21:03:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYACCCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 21:02:54 -0500
Received: from waste.org ([66.93.16.53]:56488 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbYACCCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 21:02:53 -0500
Subject: Re: [patch 1/3] move WARN_ON() out of line
From: Matt Mackall <mpm@selenic.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <477C32DA.5060905@linux.intel.com>
References: <477C32DA.5060905@linux.intel.com>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 19:59:29 -0600
Message-Id: <1199325569.4497.116.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-03 at 01:56 +0100, Arjan van de Ven wrote:
> Subject: move WARN_ON() out of line
> From: Arjan van de Ven <arjan@linux.intel.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Andrew Morton <akpm@linux-foundation.org>
> 
> A quick grep shows that there are currently 1145 instances of WARN_ON
> in the kernel. Currently, WARN_ON is pretty much entirely inlined,
> which makes it hard to enhance it without growing the size of the kernel
> (and getting Andrew unhappy).
> 
> This patch moves WARN_ON() out of line entirely. I've considered keeping
> the test inline and moving only the slowpath out of line, but I decided
> against that: an out of line test reduces the pressure on the CPUs
> branch predictor logic and gives smaller code, while a function call
> to a fixed location is quite fast. Likewise I've considered doing something
> similar to BUG() (eg use a trapping instruction) but that's not really
> better (it needs the test inline again and recovering from an invalid
> instruction isn't quite fun).
> 
> The code size reduction of this patch was about 6.5Kb (on a distro style
> .config):
> 
>     text	   data	    bss	    dec	    hex	filename
> 3096493	 293455	2760704	6150652	 5dd9fc	vmlinux.before
> 3090006	 293455	2760704	6144165	 5dc0a5	vmlinux.after
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

I hate the do_foo naming scheme (how about __warn_on?), but otherwise:

Acked-by: Matt Mackall <mpm@selenic.com>

> +		printk(KERN_WARNING "WARNING: at %s:%d %s()\n",
> +			__FILE__, __LINE__, __FUNCTION__);
> +		dump_stack();

While we're here, I'll mention that dump_stack probably ought to take a
severity level argument.

-- 
Mathematics is the supreme nostalgia of our time.

