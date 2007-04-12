Return-Path: <linux-kernel-owner+w=401wt.eu-S1030678AbXDLS10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030678AbXDLS10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 14:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030683AbXDLS10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 14:27:26 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:49581 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030678AbXDLS1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 14:27:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=To44aJ21IVHHSaNJ8Y98+VhgcGdYVQT8xxZtVQ/mNtTWjlppn3eK0TUqFN+L1LD7zrEjuGyQe+7FL2NjmPzNbizmzfjLbQDtbRiBz7b14Sq4Y4LbRnK3Om8hXYDxadbZrBuHuFodzAaEARP5YgoWKJa+/x2lCB1fp75K61ASWIc=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Mattia Dongili <malattia@linux.it>
Subject: Re: Linux 2.6.21-rc6
Date: Thu, 12 Apr 2007 21:26:44 +0300
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070412151402.GA3216@inferi.kami.home>
In-Reply-To: <20070412151402.GA3216@inferi.kami.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704122126.45032.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2007 18:14:02 Mattia Dongili wrote:
> On Thu, Apr 05, 2007 at 07:50:11PM -0700, Linus Torvalds wrote:
> ...
> > Maxim Levitsky (1):
> >       Add suspend/resume for HPET
> 
> This one breaks resume for me (from STR) on a vaio SZ. Reverting this
> commit allows resuming again but leaves me with some periodic and unpleasant:
> 
> [  155.232000] BUG: soft lockup detected on CPU#1!
> [  155.232000]  [<c0104cf2>] show_trace_log_lvl+0x1a/0x2f
> [  155.232000]  [<c0105344>] show_trace+0x12/0x14
> [  155.232000]  [<c01053c8>] dump_stack+0x16/0x18
> [  155.232000]  [<c0147240>] softlockup_tick+0xa7/0xb6
> [  155.232000]  [<c01284d3>] run_local_timers+0x12/0x14
> [  155.232000]  [<c012887a>] update_process_times+0x3e/0x63
> [  155.232000]  [<c0137656>] tick_sched_timer+0x50/0x95
> [  155.232000]  [<c01340e0>] hrtimer_interrupt+0x10b/0x18b
> [  155.232000]  [<c01137b7>] smp_apic_timer_interrupt+0x6c/0x7e
> [  155.232000]  [<c0104840>] apic_timer_interrupt+0x28/0x30
> [  155.232000]  [<c0102318>] cpu_idle+0x1b/0xc7
> [  155.232000]  [<c011297a>] start_secondary+0x32b/0x333
> [  155.232000]  [<00000000>] run_init_process+0x3fefed10/0x19
> [  155.232000]  =======================
> 
> FWIW: I hit the same BUG() in -rc5.
> full boot+suspend+resume log: http://oioio.altervista.org/linux/kern-2.6.21-rc6.log
> .config: http://oioio.altervista.org/linux/config-2.6.21-rc6-1
> 
> I'm available to test more patches or to provide other info.

Strange,strange...


First of all try to boot with clocksource=acpi_pm
(I want to test whenever HPET working as clocksource is a problem)

Then try to boot with hpet=disable or unset CONFIG_HPET_TIMER
(This will disable hpet both as clock source and clockevent)

Please send also contents of  /proc/timer_list 
(I want to know whenever APIC timer is enabled there or not)


Best regards,
	Maxim Levitsky

