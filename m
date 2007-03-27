Return-Path: <linux-kernel-owner+w=401wt.eu-S933281AbXC0Qyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281AbXC0Qyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933277AbXC0Qyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:54:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933281AbXC0Qyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:54:52 -0400
Message-ID: <46094C02.9050702@redhat.com>
Date: Tue, 27 Mar 2007 12:53:22 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Dan Hecht <dhecht@vmware.com>, Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Chris Lalancette <clalance@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>
Subject: Re: [patch 1/2] Ignore stolen time in the softlockup watchdog
References: <20070327053816.881735237@goop.org> <20070327054106.664262413@goop.org> <46092C9B.4030700@redhat.com> <46094861.7080400@goop.org>
In-Reply-To: <46094861.7080400@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Jeremy Fitzhardinge wrote:
> Prarit Bhargava wrote:
>   
>> I'd like to see this patch implement/fix touch_cpu_softlockup_watchdog
>> and touch_softlockup_watchdog to mimic touch_nmi_watchdog's behaviour.
>>     
>
> Why?  Is that more correct?  It seems to me that you're interested in
> whether a specific CPU has gone and locked up.  If touching the watchdog
>   
> makes it update all CPU timestamps, then you'll hide the fact that other
> CPUs have locked up, won't it?
>
>   
In case of misuse, yes.  But there are cases where we know that all CPUs 
will have softlockup issues, such as when doing a "big" sysrq-t dump.  
When doing the sysrq-t we take the tasklist_lock which prevents all 
other CPUs from scheduling -- this leads to bogus softlockup messages, 
so we need to reset everyone's watchdog just before releasing the 
tasklist_lock.

Another question -- are you going to expose disable/enable_watchdog to 
other subsystems?  Or are you going to expose touch_softlockup_watchdog?

>     J
>   
