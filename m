Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbYEOEIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbYEOEIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 00:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbYEOEIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 00:08:30 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:44530 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750877AbYEOEI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 00:08:29 -0400
Date: Thu, 15 May 2008 13:06:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Nur Hussein <nurhussein@gmail.com>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, arjan@infradead.org, akpm@linux-foundation.org,
       mingo@elte.hu, a.p.zijlstra@chello.nl, kyle@parisc-linux.org,
       schwidefsky@de.ibm.com
Subject: Re: Taint kernel after WARN_ON(condition) v2
Message-ID: <20080515040635.GA2164@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Nur Hussein <nurhussein@gmail.com>, linux-kernel@vger.kernel.org,
	randy.dunlap@oracle.com, arjan@infradead.org,
	akpm@linux-foundation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
	kyle@parisc-linux.org, schwidefsky@de.ibm.com
References: <20080213142740.GA4895@gandalf.middleearth> <20080213155520.681e7c06@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213155520.681e7c06@dhcp-252-066.norway.atmel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 03:55:20PM +0100, Haavard Skinnemoen wrote:
> On Wed, 13 Feb 2008 22:27:40 +0800
> Nur Hussein <nurhussein@gmail.com> wrote:
> 
> > This does not work on architectures where WARN_ON has its own definition. 
> > These archs are:
> > 	1. s390
> > 	2. superh
> > 	3. avr32
> > 	4. parisc
> 
> Hmm. Relying on the generic code in lib/bug.c qualifies as "own
> definition" these days? I think the patch below should take care of all
> four...unless I've misunderstood something.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> 
> diff --git a/lib/bug.c b/lib/bug.c
> index 530f38f..0d67419 100644
> --- a/lib/bug.c
> +++ b/lib/bug.c
> @@ -35,6 +35,7 @@
>  
>      Jeremy Fitzhardinge <jeremy@goop.org> 2006
>   */
> +#include <linux/kernel.h>
>  #include <linux/list.h>
>  #include <linux/module.h>
>  #include <linux/bug.h>
> @@ -149,6 +150,7 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
>  			       (void *)bugaddr);
>  
>  		show_regs(regs);
> +		add_taint(TAINT_WARN);
>  		return BUG_TRAP_TYPE_WARN;
>  	}
>  

I was just about to submit the exact same patch, so it looks like this
slipped through the cracks. Andrew, please apply.

Acked-by: Paul Mundt <lethal@linux-sh.org>
