Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbYJRAJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbYJRAJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 20:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756512AbYJRAJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 20:09:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756508AbYJRAJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 20:09:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/linus
Cc: prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <jason.wessel@windriver.com>, <avi@qumranet.com>,
       <richardj_moore@uk.ibm.com>
Subject: Re: [RFC Patch 6/9] Use virtual debug registers in process/thread
 handling code
In-Reply-To: Alan Stern's message of  Thursday, 16 October 2008 10:27:03 -0400 <Pine.LNX.4.44L0.0810161014270.2487-100000@iolanthe.rowland.org>
References: <20081016014407.81BDA1544CB@magilla.localdomain>
	<Pine.LNX.4.44L0.0810161014270.2487-100000@iolanthe.rowland.org>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20081018000829.519111544CB@magilla.localdomain>
Date: Fri, 17 Oct 2008 17:08:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There's a problem with moving the switch_to_thread_hw_breakpoint() call 
> before current is updated. [...]

I got this.  I'm just saying let's look for ways to do this better.

Hmm.  The 64-bit version of __switch_to does the current change much
earlier, before __switch_to_xtra and math_state_restore.  I wonder if the
32-bit version could change to match.  I can't see what in __switch_to_xtra
would care either way, though I may be overlooking something.  Ingo?

If this does not change, then __switch_to_xtra can pass prev,next to
switch_hw_breakpoint.  You can always do some slightly different
bookkeeping in there to know that prev->next is the switch happening,
so if there is a hit when current still == prev you can filter it out.


Thanks,
Roland
