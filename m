Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbYECRxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbYECRxT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757580AbYECRxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:53:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757553AbYECRxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:53:03 -0400
Date: Sat, 3 May 2008 10:51:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] posix timers: sigqueue_free: don't free sigqueue if
 it is queued
In-Reply-To: <20080503173553.GA8106@tv-sign.ru>
Message-ID: <alpine.LFD.1.10.0805031039430.5994@woody.linux-foundation.org>
References: <20080503173553.GA8106@tv-sign.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 3 May 2008, Oleg Nesterov wrote:
> 
> Note: I am not sure we shouldn't do the opposite, free sigqueue + cancel the
> pending signal, but this needs some ugly changes. Perhaps we should reconsider
> this change later. See also http://bugzilla.kernel.org/show_bug.cgi?id=10460

You know what, I think there might be an even simple solution.

How about just setting a bit saying it is canceled - and nothing more. 
Then, the dequeue logic can be just taught to ignore those things.

Doesn't that sound like the simple way to cancel signals? Make 
collect_signal() just do a "return 0" if the signal has been flushed..

			Linus
