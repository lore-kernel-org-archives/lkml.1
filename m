Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZGLC3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZGLC3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 22:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZGLC3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 22:29:13 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:29143 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZGLC3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 22:29:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Bdixk/93klruHNljvzfAByHgOn+6CAvyIXtoGd/FkTWZ+Rv60gpy7ObR6w81P20R5m
         vGoi29jH0BMZnc9PrRpAPuYYGwilHzdKMcUyLhzLmMx6dbntAZlBU93A4bBpIO9BQIrE
         99w14nvcwt1GGSfLYm8jvT3SvwPD9vcQMCq4c=
MIME-Version: 1.0
In-Reply-To: <20090711210902.GB6641@nowhere>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
	 <20090711004339.GA6125@nowhere>
	 <d82e647a0907102025s655a82bg11af0eb901349c31@mail.gmail.com>
	 <20090711210902.GB6641@nowhere>
Date: Sun, 12 Jul 2009 10:29:11 +0800
Message-ID: <d82e647a0907111929u72ebe4b5t7cf638568e195adc@mail.gmail.com>
Subject: Re: [RESEND PATCH 0/11] kernel:lockdep:replace DFS with BFS
From: Ming Lei <tom.leiming@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/12 Frederic Weisbecker <fweisbec@gmail.com>:
> On Sat, Jul 11, 2009 at 11:25:29AM +0800, Ming Lei wrote:
>> 2009/7/11 Frederic Weisbecker <fweisbec@gmail.com>:

>> >>     3,The shortest path can be obtained by BFS if the target is
>> >>     found, but can't be got by DFS. By the shortest path, we can
>> >>     shorten the lock dependency chain and help to troubleshoot lock
>> >>     problem easier than before.
>> >
>> >
>> > But there I don't understand your argument.
>> > The shortest path finding doesn't seem to me a need.
>> > Example:
>> >
>> > Task 1 acquires: A B C
>> > And Later:
>> > Task 2 acquires: C B A
>> >
>> > DFS will probably report a circular lock dependency
>> > with A and C.
>> > BFS will probably report a circular lock dependency
>> > with B and C.
>> >
>> > Which one is the most important? Both dependencies must be fixed
>> > anyway. Once the developer will fix one of those, the remaining one
>> > will be reported and so on...
>> >
>> > Or am I missing something else?
>>
>> Yes, you are right.  By BFS, we can always find the shortest circle, but we
>> find a random circle by DFS.   No one can say which circle is the most
>> important from the point of deadlock.
>>
>> But it is easier to start troubleshooting from the shortest circle
>> than a random circle , then from the next shortest circle if other
>> circle still exists .
>>
>> Right?
>
>
> I don't have a strong opinion on this. I just don't think the shortest path is
> the most important if there are many many paths.
> Whatever AB-BA is encountered, all of them must be fixed.
> What might give a degree of importance for such bad circle is the window
> in which it triggers.

The shortest path is just a characteristic of BFS, and we do not need
to pay extra
work for it.  So finding the shortest circle have not any bad effect at least.

IMHO, troubleshooting from the shortest circle is easier than from other circle.

-- 
Lei Ming
