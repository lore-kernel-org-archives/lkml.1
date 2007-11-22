Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbXKVUaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbXKVUaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 15:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbXKVUaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 15:30:12 -0500
Received: from www.tglx.de ([62.245.132.106]:33404 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbXKVUaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 15:30:11 -0500
Date: Thu, 22 Nov 2007 21:29:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: nohz and strange sleep latencies
In-Reply-To: <20071122185238.GA1821@elf.ucw.cz>
Message-ID: <alpine.LFD.0.9999.0711222121500.25057@localhost.localdomain>
References: <20071119203152.GA1772@elf.ucw.cz> <20071119205555.GA28696@elte.hu> <20071119211142.GA1857@elf.ucw.cz> <20071120085704.GA19950@elte.hu> <20071120105458.GA1597@elf.ucw.cz> <20071120205454.GD10008@elte.hu> <alpine.LFD.0.9999.0711202345520.25057@localhost.localdomain>
 <20071120225246.GA24380@elte.hu> <20071122185238.GA1821@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007, Pavel Machek wrote:
> > but perhaps somehow we miss this fact and fail to turn off the lapic 
> > clockevents drivers?
> 
> Ok, I guess I'm lost. If I offline second CPU, I immediately get
> 1000Hz timer tick... is that expected?

Hmm. No. I have no idea why this is happening.

34196 total events, 55.083 events/sec
echo 0 >/sys/devices/system/cpu/cpu1/online
36073 total events, 54.679 events/sec

> I'm trying to decide when system is idle (lets say that means "no user
> task is scheduled to wakeup within 10 seconds)... I added some
> instrumentation to nohz subsystem, but it does not behave like I'd
> expect: even if I run "while true; do sleep .01; done" loop, I see
> nohz preparing for 5 seconds sleep... while it seems obvious that it
> can only be 10msec sleep, and with max_cstate=1, it works that
> way... Plus, nte->start_pid seems to contain some random numbers :-(.
> 
> What am I doing wrong?
> 
> (Patch for illustration, I can generate full diff against vanilla,
> but...)

Just to make sure what we are hunting: Do you have the same problem
with an non-pavel-tainted 2.6.24-rc3 ?

     tglx
