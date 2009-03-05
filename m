Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbZCETls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbZCETls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbZCETlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:41:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35303 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbZCETlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:41:39 -0500
Date: Thu, 5 Mar 2009 20:41:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Paul Mackerras <paulus@samba.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perfcounters: IRQ and NMI support on AMD CPUs
Message-ID: <20090305194127.GA2039@elte.hu>
References: <1236273633.5187.286.camel@laptop> <1236277959.3316.3.camel@localhost.localdomain> <1236278730.5187.378.camel@laptop> <1236279393.3316.13.camel@localhost.localdomain> <1236281661.5187.432.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236281661.5187.432.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2009-03-06 at 00:26 +0530, Jaswinder Singh Rajput wrote:
> 
> > But kerneltop is still not working and I am not getting any NMI Interrupts.
> 
> Does the below work for you?
> 
> The BKGD suggests its 48 for all existing machines (it 
> certainly is for mine).

Yeah, this did the trick on AMD/Barcelona!

NMI:      11310      14932      11729      12705      11207      
13454      13378      10714      14526      11986      10973      
10765      12669      12093      13430       9661   Non-maskable 
interrupts

KernelTop works just fine:

------------------------------------------------------------------------------
 KernelTop:    1019 irqs/sec  kernel:27.9% [NMI, 1000000 CPU 
cycles],  (all, 16 CPUs)
------------------------------------------------------------------------------

             events         RIP          kernel function
  ______     ______   ________________   _______________

            5260.00 - ffffffff8037e420 : clear_page_c
            1065.00 - ffffffff805811a0 : page_fault
             699.00 - ffffffff8037e690 : copy_user_generic_string!
             669.00 - ffffffff80294ed8 : get_page_from_freelist
             575.00 - ffffffff804cd033 : acpi_pm_read
             551.00 - ffffffff8025fd1b : generic_exec_single
             416.00 - ffffffff80580c9c : _spin_lock
             413.00 - ffffffff802a32ad : unmap_vmas
             392.00 - ffffffff80580fc2 : _spin_lock_irqsave

Thanks!

	Ingo
