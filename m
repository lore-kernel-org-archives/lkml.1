Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab0BVWY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 17:24:57 -0500
Received: from relay3.sgi.com ([192.48.152.1]:60073 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754687Ab0BVWY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 17:24:56 -0500
Date: Mon, 22 Feb 2010 16:24:51 -0600
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, rja@sgi.com
Subject: Re: [PATCH] x86: Enable NMI on all cpus on UV
Message-ID: <20100222222451.GA14040@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20100217165049.GA26331@sgi.com> <20100222103853.GA14522@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222103853.GA14522@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 11:38:53AM +0100, Ingo Molnar wrote:
> 
> * Russ Anderson <rja@sgi.com> wrote:
> 
> > Index: linux/arch/x86/kernel/smpboot.c
> > ===================================================================
> > --- linux.orig/arch/x86/kernel/smpboot.c	2010-02-17 10:21:55.000000000 -0600
> > +++ linux/arch/x86/kernel/smpboot.c	2010-02-17 10:32:20.000000000 -0600
> > @@ -320,6 +320,8 @@ notrace static void __cpuinit start_seco
> >  	unlock_vector_lock();
> >  	ipi_call_unlock();
> >  	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
> > +	if (is_uv_system())
> > +		uv_nmi_init();
> 
> Instead of cramming it into the init sequence open-coded, shouldnt this be 
> done via the x86_platform driver mechanism?

OK, I'm working on it.

> Thanks,
> 
> 	Ingo

Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
