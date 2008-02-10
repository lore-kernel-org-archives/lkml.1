Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbYBJJT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbYBJJT5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 04:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbYBJJTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 04:19:41 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:32191 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbYBJJTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 04:19:38 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/5] CPA: Make advised protection check truly advisory
References: <20080208536.837219990@suse.de>
	<20080208163614.DF4FC1B41AA@basil.firstfloor.org>
	<alpine.LFD.1.00.0802091602260.3145@apollo.tec.linutronix.de>
	<200802091756.06553.ak@suse.de>
	<alpine.LFD.1.00.0802091809480.3145@apollo.tec.linutronix.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 10 Feb 2008 10:19:35 +0100
In-Reply-To: <alpine.LFD.1.00.0802091809480.3145@apollo.tec.linutronix.de>
Message-ID: <87myq9i2xk.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Feb 2008 09:13:15.0000 (UTC) FILETIME=[2ABFC780:01C86BC5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> 2) I care about RO as much as I care about the NX correctness. That's
> the same logic and the same problem. If we have overlapping regions,
> then we need to split large pages. Otherwise both protections are
> useless to a certain degree.

That's laudable of you if you care about that so deeply, but then please just
fix try_preserve_large_page() to do that correctly.

But I suspect you will need some sort of range check for this anyways 
so applying  my patchkit as the foundation for your fix is probably
not a bad idea. I hope we can agree on the simple fact that without
ranges large pages cannot be handled correctly.
 
> 3) For correctness reasons I even ponder to make the NX/RO mandatory.

That might make sense for cpa, but is not a good idea for 
sharing these checks with init_memory_mapping() which was the main goal
for my patchkit. I plan to do some further changes in that 
area, but that first requires sharing of that code.

There you don't want to get into the mess of handling 4K pages for these 
boundaries because they are later split up anyways by cpa for the DEBUG_RODATA
case. You've previously complained about other code reimplementing
pageattr code and doing fine grained 4K splits in init_memory_mapping()
would be exactly that so I assume you wouldn't like that either.

That is why I only wanted to apply the required checks there,
to leave the exact work for later.

You have not previously commented on that aspect so I assume
it's ok for you.

-Andi
