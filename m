Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbXLDT2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbXLDT2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXLDT2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:28:32 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36100 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750914AbXLDT2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:28:32 -0500
Date: Tue, 4 Dec 2007 14:28:31 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jarek Poplawski <jarkao2@gmail.com>
cc: Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Need lockdep help
In-Reply-To: <4755A457.5080405@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0712041424270.13516-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007, Jarek Poplawski wrote:

> Alan Stern wrote, On 12/04/2007 04:17 PM:
> ...
> 
> > Furthermore, in this case deadlock isn't really impossible -- it could 
> > occur if there were a bug somewhere else in the kernel.  So lockdep was 
> > correct to warn that deadlock might occur.
> 
> 
> Alan, if the scenario was like you described at the beginning, there was
> no deadlock possible, unless some errors in the notifier.

Or errors in the notifier's caller.

> These #1-#3
> threads were only helpful to guess what lockdep could 'think', but I
> guess notifier doesn't use 2 rivaling threads for a wake, so, lockdep
> probably needed additional information. And you really can't consider
> any hypothetical kernel bugs here because then each lock is vulnerable.

But you have to consider hypothetical kernel bugs.  That's exactly what 
lockdep is for -- to warn you about possible deadlocks that could be 
caused by bugs.

As a simple example, if thread #1 does "lock(A); lock(B)" and thread 
#2 does "lock(B); lock(A)" then there's a possible bug.  Lockdep should 
warn about you, and it does -- even if those two threads can never run 
at the same time.

If lockdep warned about deadlocks only when they actually happened, it 
wouldn't be nearly so useful.

Alan Stern

