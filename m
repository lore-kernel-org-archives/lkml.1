Return-Path: <linux-kernel-owner+w=401wt.eu-S934083AbYBUVrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083AbYBUVrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758728AbYBUVrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:47:37 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:16359 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757761AbYBUVrf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:47:35 -0500
Message-Id: <47BDA983.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 21 Feb 2008 14:40:35 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <a.p.zijlstra@chello.nl>, <bill.huey@gmail.com>, <rostedt@goodmis.org>,
       <kevin@hilman.org>, <tglx@linutronix.de>, <cminyard@mvista.com>,
       <dsingleton@mvista.com>, <dwalker@mvista.com>,
       "Moiz Kohari" <MKohari@novell.com>,
       "Peter Morreale" <PMorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, <dsaxena@plexity.net>,
       <ak@suse.de>, <gregkh@suse.de>, <npiggin@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH [RT] 00/14] RFC - adaptive real-time locks
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
 <20080221212420.GA20953@elte.hu>
In-Reply-To: <20080221212420.GA20953@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Thu, Feb 21, 2008 at  4:24 PM, in message <20080221212420.GA20953@elte.hu>,
Ingo Molnar <mingo@elte.hu> wrote: 

> hm. Why is the ticket spinlock patch included in this patchset? It just 
> skews your performance results unnecessarily. Ticket spinlocks are 
> independent conceptually, they are already upstream in 2.6.25-rc2 and 
> -rt will have them automatically once we rebase to .25.

Sorry if it was ambiguous.  I included them because we found the patch series without them can cause spikes due to the newly introduced pressure on the (raw_spinlock_t)lock->wait_lock.  You can run the adaptive-spin patches without them just fine (in fact, in many cases things run faster without them....dbench *thrives* on chaos).  But you may also measure a cyclic-test spike if you do so.  So I included them to present a "complete package without spikes".  I tried to explain that detail in the prologue, but most people probably fell asleep before they got to the end ;)

> 
> and if we take the ticket spinlock patch out of your series, the the 
> size of the patchset shrinks in half and touches only 200-300 lines of 
> code ;-) Considering the total size of the -rt patchset:
> 
>    652 files changed, 23830 insertions(+), 4636 deletions(-)
> 
> we can regard it a routine optimization ;-)

Its not the size of your LOC, but what you do with it :)

> 
> regarding the concept: adaptive mutexes have been talked about in the 
> past, but their advantage is not at all clear, that's why we havent done 
> them. It's definitely not an unambigiously win-win concept.
> 
> So lets get some real marketing-free benchmarking done, and we are not 
> just interested in the workloads where a bit of polling on contended 
> locks helps, but we are also interested in workloads where the polling 
> hurts ... And lets please do the comparisons without the ticket spinlock 
> patch ...

I'm open to suggestion, and this was just a sample of the testing we have done.  We have thrown plenty of workloads at this patch series far beyond the slides I prepared in that URL, and they all seem to indicate a net positive improvement so far.  Some of those results I cannot share due to NDA, and some I didnt share simply because I never formally collected the data like I did for these tests.  If there is something you would like to see, please let me know and I will arrange for it to be executed if at all possible.

Regards,
-Greg

