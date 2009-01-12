Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbZALReA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbZALReA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZALRdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:33:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48032 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbZALRdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:33:45 -0500
Message-ID: <496B7EBC.6020208@redhat.com>
Date: Mon, 12 Jan 2009 19:32:44 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
References: <1231774622.4371.96.camel@laptop>  <496B6C23.8000808@redhat.com> <1231780388.4371.185.camel@laptop>
In-Reply-To: <1231780388.4371.185.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Spinlocks can use 'pure' MCS locks.
>   

How about this, then.  In mutex_lock(), keep wait_lock locked and only 
release it when scheduling out.  Waiter spinning naturally follows.  If 
spinlocks are cache friendly (are they today?) we inherit that.  If 
there is no contention on the mutex, then we don't need to reacquire the 
wait_lock on mutex_unlock() (not that the atomic op is that expensive 
these days).

-- 
error compiling committee.c: too many arguments to function

