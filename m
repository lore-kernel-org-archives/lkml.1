Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbYCKLKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbYCKLKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 07:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbYCKLJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 07:09:49 -0400
Received: from www.tglx.de ([62.245.132.106]:49502 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbYCKLJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 07:09:48 -0400
Date: Tue, 11 Mar 2008 12:09:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jike Song <albcamus@gmail.com>
cc: Chr <chunkeey@web.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com, Ingo Molnar <mingo@elte.hu>,
       len.brown@intel.com
Subject: Re: endless loop in native_flush_tlb_others in smp_64.c
In-Reply-To: <df9815e70803110255s1c8323a8xf05b132ecc406bd0@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0803111205250.3781@apollo.tec.linutronix.de>
References: <200803102316.54457.chunkeey@web.de> <df9815e70803110255s1c8323a8xf05b132ecc406bd0@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008, Jike Song wrote:
> >  Most of them happend in X.org so at first I thought it had something to do
> >  with the NVIDIA module... BUT, one time it froze "a way before" the module
> >  could get loaded (and desynced my raid.......).
> >
> >  ---
> >  SYSRQ-P revealed that the CPU were looping inside:
> >
> >  smp_64.c native_flush_tlb_others:
> >  assembler code:
> >  < 1ee:   f3 90                   pause
> >  < 1f0:   f6 45 00 03             testb  $0x3,0x0(%rbp)
> >  < 1f4:   75 f8                   jne    1ee <native_flush_tlb_others+0x5f>
> >
> >  also known as: (in C)
> >
> >  while (!cpus_empty(f->flush_cpumask))
> >         cpu_relax();
> >
> >  So... has anyone a good idea what's happening here exactly? Or is there
> >  already another topic or even a patch available?

Any chance that you can capture SYSRQ-T output via serial or
netconsole, so we can see the stacktrace and what the other CPUs are
doing, if they are doing anything.

Thanks,
	tglx
