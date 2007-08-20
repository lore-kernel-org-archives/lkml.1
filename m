Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbXHTTAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbXHTTAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 15:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbXHTTAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 15:00:23 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:47663 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbXHTTAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 15:00:22 -0400
Message-ID: <46C9E4B9.1080900@linux.vnet.ibm.com>
Date: Tue, 21 Aug 2007 00:30:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: schwidefsky@de.ibm.com
CC: Ingo Molnar <mingo@elte.hu>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
References: <20070812163225.GA11996@elte.hu> <200708141037.48001.borntraeger@de.ibm.com> <20070820154529.GA300@elte.hu> <1187629438.8541.40.camel@localhost>  <20070820180810.GA25160@elte.hu> <1187634782.4028.10.camel@localhost>
In-Reply-To: <1187634782.4028.10.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> On Mon, 2007-08-20 at 20:08 +0200, Ingo Molnar wrote:
>> For sched_clock()'s behavior while the virtual CPU is idle: my current 
>> idea for that is the patch below (a loosely analoguous problem exists 
>> with nohz/dynticks): it makes sched_clock() valid across idle periods 
>> too and uses wall-clock time for that.
> 
> Ok, that would mean that sched_clock can just return the virtual cpu
> time and the two hooks starts and stops the idle periods as far as the
> scheduler is concerned. In this case we can use the patch from Jan with
> the new implementation for sched_clock and add the two hooks to the
> places where the cpu-idle notifiers are done (do_monitor_call and
> default_idle). In fact this could be an idle-notifier. Hmm, I take a
> closer look tomorrow when I'm back at the office.
> 

<snip>

I am partially responsible for the regression. While working on the
CPU accounting change, I for some unknown reason always assumed
that sched_clock() was virtualized. I should have taken a closer look.

Ingo, with this new approach, sched_clock() although not virtualized,
advances as if it is (due to the idle state change accounting).
I have one question though, what if the underlying CPU is forcefully
scheduled out from the virtual CPU?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
