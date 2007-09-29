Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbXI2RHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbXI2RHy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 13:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbXI2RHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 13:07:48 -0400
Received: from main.gmane.org ([80.91.229.2]:40244 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705AbXI2RHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 13:07:47 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [patch 0/2] suspend/resume regression fixes
Date: Sat, 29 Sep 2007 13:12:57 -0400
Message-ID: <46FE8799.3090108@tmr.com>
References: <20070922220347.586903979@linutronix.de> <alpine.LFD.0.999.0709221546250.16478@woody.linux-foundation.org> <46FD639D.9030301@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
X-Gmane-NNTP-Posting-Host: pool-70-109-100-63.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <46FD639D.9030301@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Linus Torvalds wrote:
>>
>> On Sat, 22 Sep 2007, Thomas Gleixner wrote:
>>> My final enlightment was, when I removed the ACPI processor module,
>>> which controls the lower idle C-states, right before resume; this
>>> worked fine all the time even without all the workaround hacks.
>>>
>>> I really hope that this two patches finally set an end to the "jinxed
>>> VAIO heisenbug series", which started when we removed the periodic
>>> tick with the clockevents/dyntick patches.
>>
>> Ok, so the patches look fine, but I somehow have this slight feeling 
>> that you gave up a bit too soon on the "*why* does this happen?" 
>> question.
> 
> On a closely related note:  I just now submitted a patch to fix 
> SMP-poweroff,
> by having it do disable_nonboot_cpus before doing poweroff.
> 
> Which has led me to thinking..
> ..are similar precautions perhaps necessary for *all* ACPI BIOS calls?
> 
> Because one never knows what the other CPUs are doing at the same time,
> and what the side effects may be on the ACPI BIOS functions.
> 
> And also, I wonder if at a minimum we should be guaranteeing ACPI BIOS 
> calls
> only ever happen from CPU#0 (or the "boot" CPU)?   Or do we do that 
> already?
> 
Boot CPU, and AFAIK suspend is the only place which does it.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

