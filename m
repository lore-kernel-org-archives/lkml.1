Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbZGHVL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbZGHVL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbZGHVLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:11:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755206AbZGHVLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:11:52 -0400
Date: Wed, 8 Jul 2009 14:10:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: a.p.zijlstra@chello.nl, oleg@redhat.com, avorontsov@ru.mvista.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] sched: Remove SYSTEM_RUNNING checks from
 cond_resched*()
Message-Id: <20090708141024.f8b581c5.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.01.0907080907210.3210@localhost.localdomain>
References: <20090707235812.GA12824@oksana.dev.rtsoft.ru>
	<20090708005000.GA12380@redhat.com>
	<1247034263.9777.24.camel@twins>
	<alpine.LFD.2.01.0907080907210.3210@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 8 Jul 2009 09:12:30 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:
> That said, I do agree that maybe SYSTEM_RUNNING isn't the right check. 
> Testing that the scheduler is initialized may be the more correct one. I 
> think the SYSTEM_RUNNING one just comes from that being used for other 
> debug issues.

Agreed.  system_state is too general.

If we specifically want to know whether it is safe to call schedule() then
let's create a global boolean it_is_safe_to_call_schedule and test that,
rather than testing something which indirectly and unreliably implies "it
is safe to call schedule".  If that boolean already exists then no-brainer.

All that being said, I wonder if the netconsole code should be using
msleep(1) instead.  Spinning on cond_resched() is a bit rude.  But one
would have to verify that it is safe to call schedule() at this time, and
for the netconsole caller, this is dubious.
