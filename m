Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbYE0RG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbYE0RG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757643AbYE0RGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:06:18 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:58246 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887AbYE0RGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:06:17 -0400
Date: Tue, 27 May 2008 10:06:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Message-ID: <20080527170611.GD14296@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <20080527052318.GA28301@martell.zuzino.mipt.ru> <20080527090605.GA146@tv-sign.ru> <alpine.LFD.1.10.0805270746090.2958@woody.linux-foundation.org> <20080527154001.GB14296@linux.vnet.ibm.com> <alpine.LFD.1.10.0805270908250.2958@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805270908250.2958@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 09:11:33AM -0700, Linus Torvalds wrote:
> On Tue, 27 May 2008, Paul E. McKenney wrote:
> > 
> > But this will only help until preemptible spinlocks arrive, right?
> 
> I don't think we will ever have preemptible spinlocks.
> 
> If you preempt spinlocks, you have serious issues with contention and 
> priority inversion etc, and you basically need to turn them into sleeping 
> mutexes. So now you also need to do interrupts as sleepable threads etc 
> etc.

Indeed, all of these are required in that case.

> And it would break the existing non-preempt RCU usage anyway.

Yes, preemptable spinlocks cannot work without preemptable RCU.

> Yeah, maybe the RT people try to do that, but quite frankly, it is insane. 
> Spinlocks are *different* from sleeping locks, for a damn good reason.

Well, I guess I never claimed to be sane...

Anyway, will look at a preemptable RCU that waits for preempt-disable
sections of code.

						Thanx, Paul
