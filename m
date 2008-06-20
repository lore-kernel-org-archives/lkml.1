Return-Path: <linux-kernel-owner+w=401wt.eu-S933437AbYFTUrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437AbYFTUrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765008AbYFTUeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:34:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765001AbYFTUe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:34:28 -0400
Date: Fri, 20 Jun 2008 16:34:23 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
In-Reply-To: <20080620.102601.06998427.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0806201624280.3668@engineering.redhat.com>
References: <Pine.LNX.4.64.0806171954060.2560@engineering.redhat.com>
 <20080617.210159.141238856.davem@davemloft.net>
 <Pine.LNX.4.64.0806201143110.8789@engineering.redhat.com>
 <20080620.102601.06998427.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 Jun 2008, David Miller wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Fri, 20 Jun 2008 11:47:12 -0400 (EDT)
>
>> I took another few traces (to track the whole stack content) and there is
>> another problem: nested interrupts. Does Sparc64 limit them somehow?
>
> Two levels should be the deepest you will ever see, and this is
> equivalent to what you get on other platforms.
>
> That path occurs when softirq processing re-enabled HW interrupts when
> returning from the top-level interrupt.

And what if network softirq happened here? How much stack does it consume?

The whole overflowed stack trace has 75 functions, I was able to get rid 
of 9 by avoiding bio_endio recursion and 10 by turning simple functions 
into inlines. --- so is it enough or not enough for possible networking 
calls?

Maybe a good thing would be to add a check for stack size to __do_softirq 
and handing the softirq to ksoftirqd if there's not enough space.

Mikulas
