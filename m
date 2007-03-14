Return-Path: <linux-kernel-owner+w=401wt.eu-S1030869AbXCNU0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030869AbXCNU0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030873AbXCNU0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:26:14 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:44618 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030869AbXCNU0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:26:14 -0400
Message-ID: <45F85A62.8050001@vmware.com>
Date: Wed, 14 Mar 2007 13:26:10 -0700
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: dwalker@mvista.com, cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, paulus@au.ibm.com,
       schwidefsky@de.ibm.com, Rik van Riel <riel@redhat.com>
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org>	 <1173816769.22180.14.camel@localhost>	<45F70A71.9090205@goop.org> <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org> <45F74515.7010808@vmware.com> <45F77C27.8090604@goop.org> <45F846AB.6060200@vmware.com> <45F84E39.7030507@goop.org>
In-Reply-To: <45F84E39.7030507@goop.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2007 20:26:13.0242 (UTC) FILETIME=[027FCDA0:01C76677]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>>> How is cpustat->steal used?  How does it get out to usermode?
>>>
>> Via /proc/stat, used by modern 'top', maybe other utilities.  It is
>> useful to users who want to see where the time is really going from
>> inside a guest when running on a (para)virtual machine.
>>
>> I believe previous set of xen paravirt-ops patches already handled
>> cases #2 and #3 (but no longer do since switching to clockevents), and
>> the old vmitime code did also.  Obviously, we need revamp this stuff
>> to make it fit in with the new clockevents/hrtimer way of doing things.
> 
> I added stolen time accounting to xen-pv_ops last night.  For Xen, at
> least, it wasn't hard to fit into the clockevent infrastructure.  I just
> update the stolen time accounting for each cpu when it gets a timer
> tick; they seem to get a tick every couple of seconds even when idle.
> 

Sounds good.  I don't see this in your patchset you sent yesterday 
though; did you add it after sending out those patches?  if so, could 
you forward the new patch?  does it explicitly prevent stolen time from 
getting accounted as  user/system time or does it just rely on NO_HZ 
mode sort of happening to work that way (since the one shot timer is 
skipped ahead for missed ticks)?

thanks,
Dan
