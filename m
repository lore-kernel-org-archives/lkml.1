Return-Path: <linux-kernel-owner+w=401wt.eu-S1757976AbYFKWp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbYFKWp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 18:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbYFKWpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 18:45:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:32162 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbYFKWpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 18:45:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ASH83ixepplK1tyVBoB3plqEdKBC6pYIMymiK+kt0zuoxOqz8qbwgyW40dAIldjew9
         Juo2QZoEsnLI6yONS2Iie8HnZWOZ8Mn+21VvuHLY/nPKOEYBSq6eFtPL0FMuH6NBCjmh
         zMGs+LO3Z6bwCM8k6KV8+DNfBiHkvvMj9FMt4=
Message-ID: <c384c5ea0806111545g6e6128bek519ce6022a301339@mail.gmail.com>
Date: Thu, 12 Jun 2008 00:45:13 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: 7eggert@gmx.de
Subject: Re: sched_yield() on 2.6.25
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Jakub Jozwicki" <jozwicki@aster.pl>, linux-kernel@vger.kernel.org,
       "Robert Hancock" <hancockr@shaw.ca>
In-Reply-To: <20080611152807.0682218F62@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <aCBfw-3Cv-23@gated-at.bofh.it> <aCBfw-3Cv-21@gated-at.bofh.it>
	 <aCJd6-3IF-11@gated-at.bofh.it> <aCRaM-8cM-33@gated-at.bofh.it>
	 <20080611152807.0682218F62@be1.lrz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 11, 2008 at 5:28 PM, Bodo Eggert <7eggert@gmx.de> wrote:
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> On Mon, 2008-06-09 at 08:37 +0200, Jakub Jozwicki wrote:
>
>>> From the man sched_yield:
>>>
>>> A  process  can  relinquish  the  processor  voluntarily without blocking by
>>> calling sched_yield().  The process will then be moved to the  end  of  the
>>> queue  for  its static priority and a new process gets to run.
>>>
>>> and also IEEE/Open Group:
>>> http://www.opengroup.org/onlinepubs/000095399/functions/sched_yield.html
>>
>> Yeah, except that is for Real-Time scheduling classes, SCHED_OTHER
>> doesn't have static priority queues.
>>
>> SCHED_OTHER doesn't have a specified implementation - so relying on it
>> to do anything specific is well outside the scope of definition.
>
> OTOH, it's sane not to schedule exactly the thread which just tried
> to say "I can't do any sane work, please run another thread.
>
That's not the definition of sched_yield(). See the earlier emails,
and the quote above.

As the code after sched_yield() has to be executed the thread will be
rescheduled soon (or even immediately) anyway.

The users not understanding the limited scope where sched_yield()
behaves deterministicly, seem to think that _yield() will yield() AND
lower the thread's dynamic priority for SCHED_OTHER. Is downgrading
the dynamic priority a behavioral option?

On the other hand, I don't think anything should encourage the use of
sched_yield() outside of the rare SCHED_FIFO/RR case.

Regards,
-- 
Leon
