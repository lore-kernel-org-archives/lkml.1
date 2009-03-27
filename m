Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbZC0FBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbZC0FBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 01:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbZC0FBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 01:01:19 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:60357 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775AbZC0FBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 01:01:18 -0400
Message-ID: <49CC5C7A.9070505@cosmosbay.com>
Date: Fri, 27 Mar 2009 05:56:26 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Question about PRIVATE_FUTEX
References: <28c262360903261912n4ce235c6wf2f75b2be7faf0f4@mail.gmail.com>
In-Reply-To: <28c262360903261912n4ce235c6wf2f75b2be7faf0f4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 27 Mar 2009 05:56:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim a écrit :
> Hi, Peter and Eric.
> 
> I am not expert about futex.
> I am sorry if this is dumb question.
> 
> If we use private futex, get_futex_key don't call get_user_pages_fast
> which pins page at page table.
> Then, get_futex_value_locked calls __cpy_from_user_inatomic with
> pagefault_disable.
> 
> Who make sure the user page is mapped at app's page table ?
> 

Nothing makes sure user page is mapped, as we dont have to (for private futexes
at least, since the 'key' is a combination of the futex virtual address (not
depending on the underlying physical page) and the task mm (sort of a static
offset per task)

If no page is mapped, a normal error should be returned to user, since
access to futex location will trigger a fault.


