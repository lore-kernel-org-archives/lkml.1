Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbYDHRpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbYDHRpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 13:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYDHRpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 13:45:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48583 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbYDHRpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 13:45:25 -0400
Message-ID: <47FBAF13.6000007@zytor.com>
Date: Tue, 08 Apr 2008 10:44:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: bootmem allocator
References: <20080407185613.GD9211@cvg> <20080407190904.GH12292@elte.hu> <87iqytqwl7.fsf@basil.nowhere.org> <20080408080446.GA12308@elte.hu> <20080408081206.GL16647@one.firstfloor.org>
In-Reply-To: <20080408081206.GL16647@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tue, Apr 08, 2008 at 10:04:46AM +0200, Ingo Molnar wrote:
>> * Andi Kleen <andi@firstfloor.org> wrote:
>>
>>>> hm, bootmem allocator is supposed to clear memory. We have a couple 
>>>> of places that rely on that.
>>> I was actually considering to change that for the GB pages hugetlbfs 
>>> patchkit, because memset for 1G is a little slow and not needed (will 
>>> be cleared later anyways) and it might be a problem for very large 
>>> systems with a lot of such pages at boot.
>> changing the default behavior of bootmem alloc to be non-clearing is a 
>> really bad idea that will only cause unrobustness. The proper approach 
>> is to add an _opt-in_ API that does not clear memory 
> 
> I was considering that too, but we have so many weird variants of bootmem
> with opt in and opt out and even combinations of both now that the whole thing 
> is starting to look really pear shaped (I admit I added some of them
> in the past myself but I'm not proud). Would be a great project for
> someone to consolidate that all a bit.
> 

True, but if the gbpages hugetlbfs case is the *only* case which wants a 
nonclearing interface (which it sounds like it is), then it seems like a 
really bad idea to change the default.

hugetlbfs is a pretty special case.

	-hpa
