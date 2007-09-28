Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbXI1U1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbXI1U1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 16:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbXI1U1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 16:27:12 -0400
Received: from rtr.ca ([76.10.145.34]:4050 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbXI1U1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 16:27:11 -0400
Message-ID: <46FD639D.9030301@rtr.ca>
Date: Fri, 28 Sep 2007 16:27:09 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch 0/2] suspend/resume regression fixes
References: <20070922220347.586903979@linutronix.de> <alpine.LFD.0.999.0709221546250.16478@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709221546250.16478@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 22 Sep 2007, Thomas Gleixner wrote:
>> My final enlightment was, when I removed the ACPI processor module,
>> which controls the lower idle C-states, right before resume; this
>> worked fine all the time even without all the workaround hacks.
>>
>> I really hope that this two patches finally set an end to the "jinxed
>> VAIO heisenbug series", which started when we removed the periodic
>> tick with the clockevents/dyntick patches.
> 
> Ok, so the patches look fine, but I somehow have this slight feeling that 
> you gave up a bit too soon on the "*why* does this happen?" question.

On a closely related note:  I just now submitted a patch to fix SMP-poweroff,
by having it do disable_nonboot_cpus before doing poweroff.

Which has led me to thinking..
..are similar precautions perhaps necessary for *all* ACPI BIOS calls?

Because one never knows what the other CPUs are doing at the same time,
and what the side effects may be on the ACPI BIOS functions.

And also, I wonder if at a minimum we should be guaranteeing ACPI BIOS calls
only ever happen from CPU#0 (or the "boot" CPU)?   Or do we do that already?

-ml
