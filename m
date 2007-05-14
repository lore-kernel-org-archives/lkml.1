Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbXENG36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbXENG36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 02:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758107AbXENG3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 02:29:51 -0400
Received: from www.osadl.org ([213.239.205.134]:40256 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752342AbXENG3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 02:29:51 -0400
Subject: Re: [PATCH] x86-64 highres/dyntick support
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200705140217.11515.s0348365@sms.ed.ac.uk>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <200705140217.11515.s0348365@sms.ed.ac.uk>
Content-Type: text/plain
Date: Mon, 14 May 2007 08:33:04 +0200
Message-Id: <1179124384.22481.292.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair,

On Mon, 2007-05-14 at 02:17 +0100, Alistair John Strachan wrote:
> I've noticed a few problems with this patch series, which I manually (without 
> difficulty) ported to 2.6.22-rc1.

There are a couple of fixups pending. I'm going to push out a new queue
today.

> Only 195 timer interrupts? I only see this on an AMD Opteron, it doesn't occur 
> on an Intel Core 2 Duo. Mainline reports this counter regularly increasing 
> with or without the acpi_pm clocksource loaded.

We stop the PIT when we switch to the local APICs. On your Intel box you
might have deeper C-states which switch the system back to broadcast
mode via PIT.

> Secondly, /proc/cpuinfo seems to be broken:
> 
> alistair@damocles:~$ cat /proc/cpuinfo | grep MHz
> cpu MHz         : 210779.550
> cpu MHz         : 210779.550
> 
> Unless my CPU is just under 80 times faster than it used to be, these numbers 
> are incorrect. I expect 2700.50, or something similar. cpufreq isn't compiled 
> in.

Hmm. It seems the new TSC calibration routine is hosed.

> Finally, and possibly related, the dmesg timestamps seem to be totally broken. 
> Apparently my machine booted in less than 1 second, with the last messages 
> as:
> 
> [    0.607862] bridge: topology change detected, propagating
> [    0.607862] bridge: port 2(lan-sky) entering forwarding state
> [    0.830472] Linux agpgart interface v0.102 (c) Dave Jones

Hey, you have a really fast box :)

	tglx


