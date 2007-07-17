Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbXGQEgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbXGQEgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 00:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbXGQEf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 00:35:59 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:45609
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbXGQEf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 00:35:58 -0400
Date: Mon, 16 Jul 2007 21:18:32 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Huang, Ying" <ying.huang@intel.com>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
In-Reply-To: <200707161740.26703.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0707162112180.19248@asgard.lang.hm>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
 <200707161417.50166.rjw@sisk.pl> <1184596950.24143.28.camel@caritas-dev.intel.com>
 <200707161740.26703.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Rafael J. Wysocki wrote:

> On Monday, 16 July 2007 16:42, Huang, Ying wrote:
>> On Mon, 2007-07-16 at 14:17 +0200, Rafael J. Wysocki wrote:
>>>> is this  a matter of running some test to find out, or is this a question
>>>> for the kexec implemantors?
>>>
>>> Actually, I'd like someone to tell me. ;-)
>>>
>>> I've browsed the kexec code, but haven't found anything related to the devices
>>> in it.  Perhaps I didn't know where to look ...
>>
>> There are two stages for kexec. For "normal" kexec, first the
>> sys_kexe_load is called to load the kernel image, then
>> sys_reboot(LINUX_REBOOT_CMD_KEXEC) is called to boot the new kernel.
>
> OK, thanks.  This is the information that I was missing.
>
>> The call chain is as follow:
>>
>> sys_reboot(LINUX_REBOOT_CMD_KEXEC)
>>     kernel_kexec
>>         kernel_restart_prepare
>>             device_shutdown
>>         machine_shutdown
>>         machine_kexec
>>
>> In device_shutdown, the dev->bus->shutdown or dev->driver->shutdown of
>> every device is called to put device in quiescent state. In
>> machine_kexec, the new kernel is booted.
>
> Yes.
>
>> So, for normal kexec, there is no code path for device state saving and
>> restoring.
>
> Exactly.
>
>> State of device can be restore after shutdown? I don't think so.
>
> No, it can't, but we need something like this for hibernation and
> device_shutdown() is not appropriate for this purpose IMO.

is the only reason that device_shutdown() is not appropriate the amount of 
time it takes to shutdown some devices and then start them up again? (I'm 
specificly thinking of drive spin down/up as an example)

if so, it is probably worth implementing a demo with the long times 
involved to hash out any other problems, and then implemnt shortcuts to 
avoid the device_shutdown only where the time involved is excessive.

so, exactly where in the process above does the memory map need to be 
created? is this in the machine_shutdown step or would it need to be in 
the machine_kexec step?

David Lang
