Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbXI1VSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbXI1VSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbXI1VR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:17:57 -0400
Received: from rtr.ca ([76.10.145.34]:4325 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbXI1VR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:17:56 -0400
Message-ID: <46FD6F83.8070801@rtr.ca>
Date: Fri, 28 Sep 2007 17:17:55 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch 0/2] suspend/resume regression fixes
References: <20070922220347.586903979@linutronix.de>	 <alpine.LFD.0.999.0709221546250.16478@woody.linux-foundation.org>	 <46FD639D.9030301@rtr.ca> <1191011610.18681.94.camel@chaos>
In-Reply-To: <1191011610.18681.94.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 2007-09-28 at 16:27 -0400, Mark Lord wrote:
..
>> On a closely related note:  I just now submitted a patch to fix SMP-poweroff,
>> by having it do disable_nonboot_cpus before doing poweroff.
>>
>> Which has led me to thinking..
>> ..are similar precautions perhaps necessary for *all* ACPI BIOS calls?
>>
>> Because one never knows what the other CPUs are doing at the same time,
>> and what the side effects may be on the ACPI BIOS functions.
>>
>> And also, I wonder if at a minimum we should be guaranteeing ACPI BIOS calls
>> only ever happen from CPU#0 (or the "boot" CPU)?   Or do we do that already?
> 
> The ACPI calls are serialized in the kernel, AFAICT. But the fragile
> situations (suspend, resume, shutdown, reboot) are probably those, where
> some BIOS implementation expect that certain things are not called or
> not active.

Mmm.. *do* we actually do this for reboot?  I don't see it there.
And how about for kexec?

I'm probably just missing seeing it.  Right?

Cheers
