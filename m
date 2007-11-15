Return-Path: <linux-kernel-owner+w=401wt.eu-S932524AbXKOSsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524AbXKOSsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764441AbXKOSsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:48:24 -0500
Received: from ns2.suse.de ([195.135.220.15]:39253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763475AbXKOSsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:48:23 -0500
Date: Thu, 15 Nov 2007 10:48:10 -0800
From: Greg KH <gregkh@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: EIP is at device_shutdown+0x32/0x60
Message-ID: <20071115184810.GA14750@suse.de>
References: <20071115091158.GB6216@localhost.sw.ru> <20071115014446.f943d835.akpm@linux-foundation.org> <20071115213345.B3C1.Y-GOTO@jp.fujitsu.com> <20071115163435.GC24087@suse.de> <473C7CE4.5000702@rtr.ca> <20071115182310.GF24531@suse.de> <473C8FF0.4050702@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473C8FF0.4050702@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 01:29:04PM -0500, Mark Lord wrote:
> Greg KH wrote:
>> On Thu, Nov 15, 2007 at 12:07:48PM -0500, Mark Lord wrote:
> ..
>>> Greg, I don't know if this is relevant or not,
>>> but x86 has bugs in the halt/reboot code for SMP.
>>>
>>> Specifically, in native_smp_send_stop() the code now uses
>>> spin_trylock() to "lock" the shared call buffers,
>>> but then ignores the result.
>>>
>>> This means that multiple CPUs can/will clobber each other
>>> in that code.
>>>
>>> The second bug, is that this code does not wait for the
>>> target CPUs to actually stop before it continues.
>>>
>>> This was the real cause of the failure-to-poweroff problems
>>> I was having with 2.6.23, which we fixed by using CPU hotplug
>>> to disable_nonboot_cpus() before the above code ever got run.
>> I have noticed that the shutdown path is quite weird, shutting down
>> sysdev devices differently depending on the type of shutdown, which is
>> probably not good.
>> But what change are you talking about for the poweroff problem?  I have
>> a _lot_ of people reporting that 2.6.22 is not powering off for them and
>> I can't seem to figure it out.  Do you have a changeset for something
>> that went in to fix this issue?
> ..
>
> Well, the real bugs that cause the problem are described by me above.
> I don't have a fix for those, but the workaround is in 2.6.23
> under git 4047727e5ae33f9b8d2b7766d1994ea6e5ec2991 Fix SMP poweroff hangs.
>
> With that workaround, there's no more hanging on halt,
> though there could still be a hang on reboot.
>
> A problem with that workaround is that it has no effect unless
> the CPU hotplug code is configured (CONFIG_PM_SLEEP_SMP and pals).

Hm, that's not going to be a fix for 2.6.22 as we already do a call to
that function in that call when shutting down, something in the
2.6.23-rc series must have changed that logic to make it required again.

Oh well, thanks anyway, I'll keep trying to track this down.

greg k-h
