Return-Path: <linux-kernel-owner+w=401wt.eu-S1752471AbYAQRLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbYAQRLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 12:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYAQRLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 12:11:40 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3498 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYAQRLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 12:11:39 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 2.6.24-rc7-rt2
Date: Thu, 17 Jan 2008 18:11:33 +0100
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <1200336080.318.8.camel@localhost.localdomain> <200801151810.28279.m.kozlowski@tuxland.pl> <Pine.LNX.4.58.0801162106070.19540@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0801162106070.19540@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801171811.34641.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > I found this in dmesg:
> >
> > BUG: swapper:0 task might have lost a preemption check!
> > Pid: 0, comm: swapper Not tainted 2.6.24-rc7-rt2 #3
> >  [<c010386b>] show_trace_log_lvl+0x1d/0x3b
> >  [<c01042f3>] show_trace+0x12/0x14
> >  [<c0104a2f>] dump_stack+0x6a/0x70
> >  [<c0115419>] preempt_enable_no_resched+0x5c/0x5e
> 
> This is really really strange. cpu_idle calls __preempt_enable_no_resched
> and not preempt_enable_no_resched (notice the prefixed underscores).
> So I don't know how you got that output. Did you get any strance rejects
> in applying this patch?

Nope. Your rt patch applied cleanly to vanilla 2.6.24-rc7.

Regards,

	Mariusz

> >  [<c0100e35>] cpu_idle+0x6d/0x82
> >  [<c0323b6e>] rest_init+0x66/0x68
> >  [<c043aba6>] start_kernel+0x20c/0x276
> >  [<00000000>] 0x0
> >  =======================
> > ---------------------------
> > | preempt count: 00000000 ]
> > | 0-level deep critical section nesting:
> > ----------------------------------------
> >
> > Box runs fine though.
