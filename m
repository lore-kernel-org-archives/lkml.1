Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbZHKQXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbZHKQXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZHKQXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:23:34 -0400
Received: from bar.sig21.net ([80.81.252.164]:38164 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbZHKQXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:23:33 -0400
Date: Tue, 11 Aug 2009 18:23:13 +0200
From: Johannes Stezenbach <js@sig21.net>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:perfcounters/urgent] perf_counter, x86: Fix/improve apic
 fallback
Message-ID: <20090811162313.GA8325@sig21.net>
References: <new-submission>
 <tip-83f19150242ee57730a4331b6ae9a9b90ccc718c@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-83f19150242ee57730a4331b6ae9a9b90ccc718c@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -4.1 (----)
X-Spam-21-Report: No, score=-4.1 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.250,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 11:34:21AM +0000, tip-bot for Ingo Molnar wrote:
> Commit-ID:  83f19150242ee57730a4331b6ae9a9b90ccc718c
> Gitweb:     http://git.kernel.org/tip/83f19150242ee57730a4331b6ae9a9b90ccc718c
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Tue, 11 Aug 2009 10:40:08 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 11 Aug 2009 13:19:07 +0200
> 
> perf_counter, x86: Fix/improve apic fallback
> 
> Johannes Stezenbach reported that his Pentium-M based
> laptop does not have the local APIC enabled by default,
> and hence perfcounters do not get initialized.
> 
> Add a fallback for this case: allow non-sampled counters
> and return with an error on sampled counters. This allows
> 'perf stat' to work out of box - and allows 'perf top'
> and 'perf record' to fall back on a hrtimer based sampling
> method.
> 
> ( Passing 'lapic' on the boot line will allow hardware
>   sampling to occur - but if the APIC is disabled
>   permanently by the hardware then this fallback still
>   allows more systems to use perfcounters. )
> 
> Also decouple perfcounter support from X86_LOCAL_APIC.

Seems to work.  From dmesg:

   Performance Counters: 
   no APIC, boot with the "lapic" boot parameter to force-enable it.
   no hardware sampling interrupt available.
   p6 PMU driver.
   ... version:                 0
   ... bit width:               32
   ... generic counters:        2
   ... value mask:              00000000ffffffff
   ... max period:              000000007fffffff
   ... fixed-purpose counters:  0
   ... counter mask:            0000000000000003
   CPU: Intel(R) Pentium(R) M processor 1.80GHz stepping 06

However:

   oprofile: using timer interrupt.

I tried "perf top", "perf stat -a sleep 1", "perf stat java foo",
it all looks good to my untrained eye.


Thanks,
Johannes
