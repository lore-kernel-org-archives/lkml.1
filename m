Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYAQCIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYAQCIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 21:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYAQCII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 21:08:08 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:63473 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYAQCIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:08:07 -0500
Date: Wed, 16 Jan 2008 21:07:36 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc7-rt2
In-Reply-To: <200801151810.28279.m.kozlowski@tuxland.pl>
Message-ID: <Pine.LNX.4.58.0801162106070.19540@gandalf.stny.rr.com>
References: <1200336080.318.8.camel@localhost.localdomain>
 <200801142316.39330.m.kozlowski@tuxland.pl> <Pine.LNX.4.58.0801141730150.3109@gandalf.stny.rr.com>
 <200801151810.28279.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 15 Jan 2008, Mariusz Kozlowski wrote:
> Ok. It works.
>
> I found this in dmesg:
>
> BUG: swapper:0 task might have lost a preemption check!
> Pid: 0, comm: swapper Not tainted 2.6.24-rc7-rt2 #3
>  [<c010386b>] show_trace_log_lvl+0x1d/0x3b
>  [<c01042f3>] show_trace+0x12/0x14
>  [<c0104a2f>] dump_stack+0x6a/0x70
>  [<c0115419>] preempt_enable_no_resched+0x5c/0x5e

This is really really strange. cpu_idle calls __preempt_enable_no_resched
and not preempt_enable_no_resched (notice the prefixed underscores).
So I don't know how you got that output. Did you get any strance rejects
in applying this patch?

-- Steve


>  [<c0100e35>] cpu_idle+0x6d/0x82
>  [<c0323b6e>] rest_init+0x66/0x68
>  [<c043aba6>] start_kernel+0x20c/0x276
>  [<00000000>] 0x0
>  =======================
> ---------------------------
> | preempt count: 00000000 ]
> | 0-level deep critical section nesting:
> ----------------------------------------
>
> Box runs fine though.
>
> Regards,
>
> 	Mariusz
> -
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
