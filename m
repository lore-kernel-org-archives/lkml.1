Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbZGLCmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbZGLCmv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 22:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZGLCmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 22:42:44 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:46632 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbZGLCmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 22:42:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r3UJcsmS2rbZdCAUebNT9PNt53aY3tFpCSNp9bWWPD+eN59GelsWoQlD8InpViSlfv
         GMrJXD76A9KTvD3xS6gSbdT3/ci9zGHtQjnCH53LfuzgfZ4IrKmxb0V/8aAzfavLnz0O
         52C416JSfPk/863F0PhVHgFGLkF9g2kVrRunM=
MIME-Version: 1.0
In-Reply-To: <20090711213028.GC6641@nowhere>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
	 <1246201486-7308-2-git-send-email-tom.leiming@gmail.com>
	 <20090711213028.GC6641@nowhere>
Date: Sun, 12 Jul 2009 10:42:42 +0800
Message-ID: <d82e647a0907111942o1cf22batb204c38bfbd43c03@mail.gmail.com>
Subject: Re: [RESEND PATCH 01/11] kernel:lockdep:print the shortest dependency 
	chain if finding a circle
From: Ming Lei <tom.leiming@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/12 Frederic Weisbecker <fweisbec@gmail.com>:
> On Sun, Jun 28, 2009 at 11:04:36PM +0800, tom.leiming@gmail.com wrote:
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> Currently lockdep will print the 1st circle detected if it exists when
>> acquiring a new (next) lock.
>>
>> This patch prints the shortest path from the next lock to be acquired to
>> the previous held lock if a circle is found.
>>
>> The patch still uses the current method to check circle, and once the
>> circle is found, breadth-first search algorithem is used to compute the
>> shortest path from the next lock to the previous lock in the forward
>> lock dependency graph.
>>
>> Printing the shortest path will shorten the dependency chain, and make
>> troubleshooting for possible circular locking easier.
>
>
>
> Oh! That looks fairly different from what I was thinking about...

If you continue to review the following patches, you will find it is the same
from what you are thinking about.

The patch is a middle patch and just a start point. It is  this patch that
checking circle by BFS comes to my mind.

Maybe I should rearrange the patch set, I really want to get more suggestions
and comments to do it.

Thanks for your review.

>
> If I understand well, lets imagine the following:
>
> Task 1 acquires: A B F
> Task 2 acquires: A B C D E F
> Task 3 acquires: F B
>
> Before your patch, DFS would report the BF - FB wicked dependency
> by reporting the Task 2 dependency snapshot, which is cluttered by
> the other locks C, D and E (that would be reported in the dependency chain
> if I'm not wrong) whereas BFS would be smarter by finding the shortest
> snapshot found in Task 3: just F B.
>
> Correct me if I misunderstand this patch.

You are correct, BFS will always find the shortest circle if there is circle.

>
> I suggest you to provide an example along this patch, that would make
> it easier to demonstrate its importance.

No, as you said, the shortest circle is not very important, and it is just a
byproduct and we have no reason to reject it.

-- 
Lei Ming
