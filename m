Return-Path: <linux-kernel-owner+w=401wt.eu-S1752340AbZFXM0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbZFXM0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 08:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZFXM0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 08:26:34 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57320 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbZFXM0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 08:26:33 -0400
Date: Wed, 24 Jun 2009 21:25:33 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: register_timer_hook use in arch/sh/oprofile
Message-ID: <20090624122533.GA9510@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Paul Mackerras <paulus@samba.org>
References: <20090624131104.705c828d@skybase> <20090624112929.GB2079@linux-sh.org> <20090624121750.GB20564@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624121750.GB20564@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 02:17:50PM +0200, Ingo Molnar wrote:
> 
> * Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > In practice oprofile has never been a good fit for these sorts of 
> > counters, so this has fairly limited use. If there's a way to 
> > wiggle these types of counters in to the new perf_counter API, 
> > then I'll convert that over and just kill the old oprofile driver 
> > off completely. Barring that, I'll just end up converting it over 
> > to hrtimers as well, so don't let that stop you from ripping out 
> > the timer hook bits.
> > 
> > Most of this code predates hrtimers anyways, and it also predates 
> > the timer hook, which is only something that we converted to some 
> > years back.
> 
> Note, the current initial upstream SH support for perfcounters:
> 
>  arch/sh/include/asm/perf_counter.h:#define set_perf_counter_pending()	do { } while (0)
>  arch/sh/include/asm/unistd_32.h:#define __NR_perf_counter_open	336
>  arch/sh/include/asm/unistd_64.h:#define __NR_perf_counter_open	364
>  arch/sh/kernel/syscalls_32.S:	.long sys_perf_counter_open
>  arch/sh/kernel/syscalls_64.S:	.long sys_perf_counter_open
> 
> Should already give you hrtimers straight away.
> 
> To test it, could you try to run 'perf top' after:
> 
> 	cd tools/perf/
> 	make install
> 
> It should display a hrtimer driven kernel profile already. You can 
> increase/decrease the frequency of sampling by using -F option - say 
> 'perf top -F 10000' should sample at 10 KHz.
> 
> Please let me know if any of this does not work as expected.
> 
Yes, that all works fine. My comment was more in reference to the
hardware performance counters that don't have IRQs of their own, which
still need to be tied in to the perf_counter API.
