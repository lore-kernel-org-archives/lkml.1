Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbZGHVdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbZGHVdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbZGHVdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:33:33 -0400
Received: from ru.mvista.com ([213.79.90.228]:47966 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755165AbZGHVdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:33:32 -0400
Date: Thu, 9 Jul 2009 01:33:31 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, a.p.zijlstra@chello.nl,
       oleg@redhat.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] sched: Remove SYSTEM_RUNNING checks from
 cond_resched*()
Message-ID: <20090708213331.GA9346@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090707235812.GA12824@oksana.dev.rtsoft.ru>
 <20090708005000.GA12380@redhat.com>
 <1247034263.9777.24.camel@twins>
 <alpine.LFD.2.01.0907080907210.3210@localhost.localdomain>
 <20090708141024.f8b581c5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090708141024.f8b581c5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 02:10:24PM -0700, Andrew Morton wrote:
> > On Wed, 8 Jul 2009 09:12:30 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > That said, I do agree that maybe SYSTEM_RUNNING isn't the right check. 
> > Testing that the scheduler is initialized may be the more correct one. I 
> > think the SYSTEM_RUNNING one just comes from that being used for other 
> > debug issues.
> 
> Agreed.  system_state is too general.
> 
> If we specifically want to know whether it is safe to call schedule() then
> let's create a global boolean it_is_safe_to_call_schedule and test that,
> rather than testing something which indirectly and unreliably implies "it
> is safe to call schedule".  If that boolean already exists then no-brainer.
> 
> All that being said, I wonder if the netconsole code should be using
> msleep(1) instead.  Spinning on cond_resched() is a bit rude.  But one
> would have to verify that it is safe to call schedule() at this time, and
> for the netconsole caller, this is dubious.

What do you mean by "verify that it is safe"? If it works,
can I assume that it's safe? ;-) It works, fwiw.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
