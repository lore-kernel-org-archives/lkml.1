Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbYFSNC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbYFSNC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 09:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbYFSNCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 09:02:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbYFSNCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 09:02:19 -0400
Date: Thu, 19 Jun 2008 09:01:58 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
In-Reply-To: <20080618.233713.87158879.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0806190845300.6330@engineering.redhat.com>
References: <Pine.LNX.4.64.0806182318170.27388@engineering.redhat.com>
 <20080618.205948.107681537.davem@davemloft.net>
 <Pine.LNX.4.64.0806190041080.31418@engineering.redhat.com>
 <20080618.233713.87158879.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008, David Miller wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Thu, 19 Jun 2008 01:17:39 -0400 (EDT)
>
>> I see ... the callee writes arguments into caller's stack frame, if it has
>> variable number of arguments. That it misdesign, the callee should write
>> registers arguments into it's own frame like on AMD64 (then this space
>> would be allocated only if needed).
>
> The callee can do this even for non-variable argument lists.
>
> It's like a set of pre-allocated stack slots for those incoming
> argument registers when reloading under register pressure.
>
> In my opinion it is better to put this onus on the callee because only
> the callee knows if it needs to pop these values onto the stack to
> alleviate register pressure.
>
> I think it might be possible for the compiler to only use 176 bytes.
> I'll take a look at the gcc sparc backend and the ABI specification
> to see if this is the case.

Yes, it could be shrunk to 176 bytes. Maybe there could be some 
performance problems if the spills are cacheline-unaligned. Or better --- 
make special -mkernel-abi function to gcc that will drop this area at all 
and make 128-byte frames. In kernel it wouldn't matter that ABI is 
incompatible.

Mikulas
