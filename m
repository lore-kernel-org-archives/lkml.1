Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbYHOMQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbYHOMQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYHOMQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:16:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbYHOMQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:16:29 -0400
Date: Fri, 15 Aug 2008 08:16:14 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, jvillalo@redhat.com
Subject: Re: [PATCH] perfctr: don't use CCCR_OVF_PMI1 on Pentium 4Ds
Message-ID: <20080815121614.GT7154@redhat.com>
References: <20080814203133.GS7154@redhat.com> <20080815115928.GD32726@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815115928.GD32726@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
> > Currently, setup_p4_watchdog() use CCCR_OVF_PMI1 to enable the counter 
> > overflow interrupts to the second logical core. But this bit doesn't 
> > work on Pentium 4 Ds (model 4, stepping 4) and this patch avoids its 
> > use on these processors. [...]
> 
> btw., what was the effect - an oops on bootup, or a non-working 
> watchdog?
it just won't work at boot time - the second logic unit will be stuck:

Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 5586.12 BogoMIPS (lpj=2793063)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM1)
              Intel(R) Pentium(R) D CPU 2.80GHz stepping 04
Brought up 2 CPUs
testing NMI watchdog ... <4>WARNING: CPU#1: NMI appears to be stuck (0->0)!

-- 
Aristeu

