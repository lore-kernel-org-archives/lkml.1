Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbYE0QNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbYE0QNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758869AbYE0QMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:12:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758863AbYE0QML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:12:11 -0400
Date: Tue, 27 May 2008 09:11:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
In-Reply-To: <20080527154001.GB14296@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.1.10.0805270908250.2958@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <20080527052318.GA28301@martell.zuzino.mipt.ru> <20080527090605.GA146@tv-sign.ru> <alpine.LFD.1.10.0805270746090.2958@woody.linux-foundation.org>
 <20080527154001.GB14296@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 May 2008, Paul E. McKenney wrote:
> 
> But this will only help until preemptible spinlocks arrive, right?

I don't think we will ever have preemptible spinlocks.

If you preempt spinlocks, you have serious issues with contention and 
priority inversion etc, and you basically need to turn them into sleeping 
mutexes. So now you also need to do interrupts as sleepable threads etc 
etc.

And it would break the existing non-preempt RCU usage anyway.

Yeah, maybe the RT people try to do that, but quite frankly, it is insane. 
Spinlocks are *different* from sleeping locks, for a damn good reason.

		Linus
