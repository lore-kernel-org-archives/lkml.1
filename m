Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbZKUQzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbZKUQzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 11:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbZKUQzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 11:55:16 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:41436 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbZKUQzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 11:55:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAL6lB0tGGN1W/2dsb2JhbACBTdILhDwE
Date: Sat, 21 Nov 2009 11:55:20 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ashwin Tanugula <ashwin.tanugula@broadcom.com>
Cc: "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>,
       Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org
Subject: Re: MIPS TSC synchronization
Message-ID: <20091121165520.GH12100@Krystal>
References: <66E4AD309580E34AA457975F33D2A747414F45316D@IRVEXCHCCR01.corp.ad.broadcom.com> <20091117215352.GA30569@Krystal> <66E4AD309580E34AA457975F33D2A747414F171989@IRVEXCHCCR01.corp.ad.broadcom.com> <20091118215944.GB19773@Krystal> <20091118221858.GA22209@Krystal> <66E4AD309580E34AA457975F33D2A747414F17198C@IRVEXCHCCR01.corp.ad.broadcom.com> <20091119165244.GC16094@Krystal> <66E4AD309580E34AA457975F33D2A747414F45387E@IRVEXCHCCR01.corp.ad.broadcom.com> <20091120143842.GB5765@Krystal> <66E4AD309580E34AA457975F33D2A747414F453B06@IRVEXCHCCR01.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <66E4AD309580E34AA457975F33D2A747414F453B06@IRVEXCHCCR01.corp.ad.broadcom.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:46:14 up 95 days,  3:35,  3 users,  load average: 0.10, 0.14,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ashwin Tanugula (ashwin.tanugula@broadcom.com) wrote:
>  
> 
> 
> > > However, I was only able to view two out of 10 traces generated.
> > > 
> 
> > These errors seem to be caused by the fact that you run a SMP mips system with frequency scaling (either dynamic freq. scaling., or halting the clock in idle).
> 
> > You might wait to try to disable the freq. scaling and see if it works better.
> 
> 
> Hi Mathieu,
> 
> 1)	With the patch on thop of 177, HAVE_UNSYNCHRONIZED_TSC was disabled and test_tsc_synchronization (arch/mips/kerne
> l/smp.c) was never called. So, we never knew if there was any TSC offset between the CPUs.

(adding Ralf and LKML in CC)

test_tsc_synchronization() is introduced by the LTTng tree. So in
mainline you would have never known that there was such a TSC offset
between your cores.

> 
> 
> 2)	With HAVE_UNSYNCHRONIZED_TSC enabled, TSC offset between the CPUs was  huge.
> 
> Boot messages:
> 
> checking TSC synchronization across all online CPUs:
> Measured 152179143 cycles TSC offset between CPUs, turning off TSC clock.
> 
> I think this happened because of the stub function for synchronise_count_master in arch/mips/include/asm/r4k-timer.h
> 
> 
> 3)	With HAVE_UNSYNCHRONIZED_TSC and enabled SYNC_R4K, arch/mips/kernel/sync-r4k.c gets compiled and I don't see any offset.
> 
> 
> Boot Messages:
> 
> checking TSC synchronization across all online CPUs: passed.
> 
> And I can view my traces on lttv without any problem.
> 

Great !

> 
> 
> I guess arch/mips/kernel/sync-r4k.c is buggy on SMTC.

I see that SYNC_R4K is only selected by MIPS_CMP usually. Maybe a select
for it should be added to your kind of board ?

> 
> 
> Can you please confirm if this is right or not?

Given I am not a MIPS expert, I added some people in CC. They might help
confirming this if you provide information about:

- Number of CPUs
- Threads per CPUs (seems to be one, given CONFIG_MIPS_MT_SMTC is not
  set in your configuration)
- your .config

Thanks,

Mathieu

> 
> Thanks,
> Ashwin
> 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
