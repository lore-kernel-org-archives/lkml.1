Return-Path: <linux-kernel-owner+w=401wt.eu-S1759750AbXEJAFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759750AbXEJAFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 20:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbXEJAFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 20:05:24 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:35300 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754973AbXEJAFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 20:05:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=cGQMb8VG5vDJIaZgkoQ6mAE6AAUkGVxeEdN4wxTtAEnX2sLnh0n6c58tPE+bdDGJ1zhDp7Joi/vcjpZis56hEkq+7bvqYf1lyM96BGOjcPyesSPQhsBfLBapMsrAajM5mgqMkYm6lcUIMxaIxVL5IdxavP0BjaLZxtMvKcZCSQo=  ;
X-YMail-OSG: j3M6wi0VM1n8Qvq_Fsfjhh0Ev_EyHzMBURQgw2j9zVfzEavKgO.LwS3SHf8QYFwFtFAyMjgZ8w--
Message-ID: <464261B5.6030809@yahoo.com.au>
Date: Thu, 10 May 2007 10:05:09 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: swap-prefetch: 2.6.22 -mm merge plans
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <200705042210.15953.kernel@kolivas.org> <200705051842.32328.kernel@kolivas.org> <200705100928.34056.kernel@kolivas.org>
In-Reply-To: <200705100928.34056.kernel@kolivas.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:

> Well how about that? That was the difference with a swap _file_ as I said, but 
> I went ahead and checked with a swap partition as I used to have. I didn't 
> notice, but somewhere in the last few months, swap prefetch code itself being 
> unchanged for a year, seems to have been broken by other changes in the vm 
> and it doesn't even start up prefetching often and has stale swap entries in 
> its list. Once it breaks like that it does nothing from then on. So that 
> leaves me with a quandry now.
> 
> 
> Do I:
> 
> 1. Go ahead and find whatever breakage was introduced and fix it with 
> hopefully a trivial change
> 
> 2. Do option 1. and then implement support for yet another kernel feature 
> (cpusets) that will be used perhaps never with swap prefetch [No Nick I don't 
> believe you that cpusets have anything to do with normal users on a desktop 
> ever; if it's used on a desktop it will only be by a kernel developer testing 
> the cpusets code].
> 
> or
> 
> 3. Dump swap prefetch forever and ignore that it ever worked and was helpful 
> and was a lot of work to implement and so on.
> 
> 
> Given that even if I do 1 and/or 2 it'll still be blocked from ever going to 
> mainline I think the choice is clear.
> 
> Nick since you're personally the gatekeeper for this code, would you like to 
> make a call? Just say 3 and put me out of my misery please.


I'm not the gatekeeper and it is completely up to you whether you want
to work on something or not... but I'm sure you understand where I was
coming from when I suggested it doesn't get merged yet.

You may not believe this, but I agree that swap prefetching (and
prefetching in general) has some potential to help desktop workloads :).
But it still should go through the normal process of being tested and
questioned and having a look at options for first improving existing
code in those problematic cases.

Once that process happens and it is shown to work nicely, etc., then I
would not be able to (or want to) keep it from getting merged.

As far as cpusets goes... if your code goes in last, then you have to
make it work with what is there, as a rule. People are using cpusets
for memory resource control, which would have uses on a desktop system.
It is just a really bad precedent to set, having different parts of the
VM not work correctly together. Even if you made them mutually
exclusive CONFIG_ options, that is still not a very nice solution.

-- 
SUSE Labs, Novell Inc.
