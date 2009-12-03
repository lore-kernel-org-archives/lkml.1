Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbZLCCcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbZLCCcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 21:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZLCCcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 21:32:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:59630 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506AbZLCCcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 21:32:32 -0500
Message-ID: <4B1722F0.6030308@kernel.org>
Date: Wed, 02 Dec 2009 18:31:12 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: seperate reserve_early and reserve_early_overlap_check
References: <4B0CF1B3.1050200@kernel.org> <4B17199F.1000804@zytor.com>
In-Reply-To: <4B17199F.1000804@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 11/25/2009 12:58 AM, Yinghai Lu wrote:
>> when the area is from find_e820_area(), it could be overlapped with others.
>>
>> so just add it directly. the new reserve_early()
>>
>> and rename old reserve_early() to reserve_early_overlap_check()
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> Hi Yinghai,
> 
> I had this patch in my queue but it looks like I had overlooked it as it
> arrived during the U.S. holiday; I apologize profusely!
> 
> I'm concerned about several things with this patch, which doesn't mean
> it isn't fulfilling a genuine need:
> 
> 1. Renaming reserve_early() to reserve_early_overlap_check() is most
> likely going to get overlooked, and people will use the "new"
> reserve_early() thinking that they got the old one.
kill reserve_early()
and use
reserve_early_overlap_check()
reserve_early_overlap_not_check()
?
> 
> 2. This creates overlapping ranges in the reservation array itself.

why?

if the range is retrieved from find_e820_area(). that range should be safe.
we could add the early_res directly.

> 
> What it looks to me is what we need is actually a
> reserve_early_clobber() which does what the current reserve_early() does
> except that it ignores the overlap_ok flag on existing reservations.
> 
> I have attached an untested patch to do that.  Note that I don't have
> any callers for reserve_early_clobber(), since one effect of changing
> the semantics of an existing function in the way you did is that the
> patch contains the call sites that *didn't* need modification rather
> than the one that *did* need modification.  The call sites that want the
> new semantics need to be modified.  As such, it's possible that the
> comment I added is completely wrong, I really need some further
> information on this.
> 
> [Note: the function __reserve_early() hasn't actually changed; I just
> moved it ahead of drop_overlaps().]
> 

your patch seems to solve the multiple overlap ok problem.

these overlap check stuff is added by SGI guys to bandit their bios problem. maybe we can kill them at some point.

YH
