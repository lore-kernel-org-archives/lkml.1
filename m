Return-Path: <linux-kernel-owner+w=401wt.eu-S1761064AbXE2KVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761064AbXE2KVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 06:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbXE2KVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 06:21:08 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:55006 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbXE2KVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 06:21:06 -0400
Date: Tue, 29 May 2007 15:49:47 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, pranith-kumar_d@mentorg.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] CFS scheduler, -v14
Message-ID: <20070529101947.GA12620@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20070523120616.GA23407@elte.hu> <20070524064235.GA2386@linux.vnet.ibm.com> <20070524080959.GA29151@elte.hu> <20070525124652.GA24038@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525124652.GA24038@elte.hu>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo,

> +static clock_t task_utime(struct task_struct *p)
> +{
> +	/*
> +	 * Use CFS's precise accounting, if available:
> +	 */
> +	if (!has_rt_policy(p) && !(sysctl_sched_load_smoothing & 128))
> +		return nsec_to_clock_t(p->sum_exec_runtime);


I wonder if this leads to data truncation, p->sum_exec_runtime is
unsigned long long and clock_t is long (on all architectures from what
my cscope shows me). I have my other patch ready on top of this. I'll
post it out soon.

> +
> +	return cputime_to_clock_t(p->utime);
> +}
> +

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
