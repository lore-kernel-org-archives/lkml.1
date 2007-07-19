Return-Path: <linux-kernel-owner+w=401wt.eu-S965170AbXGSPWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965170AbXGSPWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761886AbXGSPWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:22:25 -0400
Received: from gw.goop.org ([64.81.55.164]:39677 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756905AbXGSPWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:22:24 -0400
Message-ID: <469F8179.2060802@goop.org>
Date: Thu, 19 Jul 2007 08:21:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
References: <20070717114453.GA8212@elte.hu> <469CCF8F.4010107@goop.org> <20070717154934.GA24231@elte.hu> <20070719002231.069ebbdd.akpm@linux-foundation.org> <20070719075152.GB12760@elte.hu> <469F75AF.5080000@goop.org> <20070719143528.GA8278@elte.hu> <469F793E.6030006@goop.org> <20070719145058.GA11971@elte.hu> <469F7D7A.204@goop.org> <20070719150955.GA19373@elte.hu>
In-Reply-To: <20070719150955.GA19373@elte.hu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> Well, my observation is that both softlockup and the scheduler really 
>> want to measure unstolen time, so it seemed to me that sched_clock was 
>> a nice common place to implement that, rather than implementing a 
>> whole new time interface.  At the time that seemed OK, and nobody had 
>> any objections.
>>     
>
> yeah. But then it should not be using sched_clock() but CFS's new 
> rq_clock() method - which does try to construct a globally valid 
> timesource out of sched_clock(). [that fix is not backportable though]
>   

Hm, that doesn't look quite right.  Doesn't rq_clock measure time spent
running?  Unstolen time includes idle time too (it just excludes time in
which a VCPU is runnable but not actually running).

    J
