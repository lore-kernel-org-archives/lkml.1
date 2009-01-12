Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbZALSIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbZALSIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbZALSHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:07:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:51988 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZALSHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:07:53 -0500
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
In-Reply-To: <496B7ED7.3010601@panasas.com>
References: <1231774622.4371.96.camel@laptop>
	 <alpine.LFD.2.00.0901120802430.6528@localhost.localdomain>
	 <alpine.LFD.2.00.0901120818070.6528@localhost.localdomain>
	 <1231780581.4371.193.camel@laptop>  <496B7ED7.3010601@panasas.com>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 19:07:16 +0100
Message-Id: <1231783636.4371.201.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 19:33 +0200, Boaz Harrosh wrote:

> Which brings me back to my initial reaction to this work. Do we need
> two flavors of Mutex? some program sections need Fairness, some need
> performance. Some need low-latency, some need absolute raw CPU power.

Thing is, its the kernel, we cannot have such knobs per task. So we have
to pick one and stick with it -- the 'best' we can do is what PREEMPT_RT
does and replace the thing whole sale at build time.

> Because at the end of the day spinning in a saturated CPU work-load
> that does not care about latency, eats away cycles that could be spent
> on computation. Think multi-threaded video processing for example. 
> Thing I would like to measure is 
> 1 - how many times we spin and at the end get a lock
> 2 - how many times we spin and at the end sleep.
> 3 - how many times we sleep like before.
> vs. In old case CPU spent on scheduling. Just to see if we are actually loosing
> cycles at the end.

Feel free to do so ;-)

