Return-Path: <linux-kernel-owner+w=401wt.eu-S1761661AbXHUHBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761661AbXHUHBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 03:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbXHUHBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 03:01:37 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:38934 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbXHUHBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 03:01:36 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: schwidefsky@de.ibm.com
Subject: Re: [accounting regression since rc1]  scheduler updates
Date: Tue, 21 Aug 2007 09:00:54 +0200
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
References: <20070812163225.GA11996@elte.hu> <20070820180810.GA25160@elte.hu> <1187634782.4028.10.camel@localhost>
In-Reply-To: <1187634782.4028.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708210900.54549.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 20. August 2007 schrieb Martin Schwidefsky:
> On Mon, 2007-08-20 at 20:08 +0200, Ingo Molnar wrote:
> Ok, that would mean that sched_clock can just return the virtual cpu
> time and the two hooks starts and stops the idle periods as far as the
> scheduler is concerned. In this case we can use the patch from Jan with
> the new implementation for sched_clock and add the two hooks to the
> places where the cpu-idle notifiers are done (do_monitor_call and
> default_idle). In fact this could be an idle-notifier. Hmm, I take a
> closer look tomorrow when I'm back at the office.
> 
> > If a virtual CPU is idle then i think the "real = steal, virtual = 0" 
> > way of thinking about idle looks a bit unnatural to me - wouldnt it be 
> > better to think in terms of "steal = 0, virtual = real" ? Basically a 
> > virtual CPU can idle at "perfect speed", without the host "stealing" any 
> > cycles from it. And with that way of thinking, if s390 passed in the 
> > real-idle-time value to the new callbacks below it would all fall into 
> > place. Hm?

Martin,

I think we already do something like this. If you look at cpustat in 2.6.22 
and earlier we already have steal increase = 0, idle increase = 100 % on an 
idle cpu, even on s390. So while from the hardware perspective steal is 
growing, we do the right thing in Linux, no?

Chrisian
