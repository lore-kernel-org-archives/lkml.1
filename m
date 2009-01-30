Return-Path: <linux-kernel-owner+w=401wt.eu-S1760022AbZA3Boz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022AbZA3Boz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 20:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbZA3Bor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 20:44:47 -0500
Received: from gw.goop.org ([64.81.55.164]:39341 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbZA3Boq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 20:44:46 -0500
Message-ID: <49825B8B.2000202@goop.org>
Date: Thu, 29 Jan 2009 17:44:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Seeing "huh, entered softirq 8 ffffffff802682aa preempt_count
 00000100, exited with 00010100?" in tip.git
References: <498229CF.1090007@goop.org> <20090130005953.GD6716@linux.vnet.ibm.com>
In-Reply-To: <20090130005953.GD6716@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Thu, Jan 29, 2009 at 02:12:31PM -0800, Jeremy Fitzhardinge wrote:
>   
>> When I boot my x86-64 tip.git kernel under Xen, I'm seeing:
>>
>> pnp: PnP ACPI: disabled
>> NET: Registered protocol family 2
>> huh, entered softirq 8 ffffffff802682aa preempt_count 00000100, exited with 
>> 00010100?
>> IP route cache hash table entries: 512 (order: 0, 4096 bytes)
>> TCP established hash table entries: 1024 (order: 2, 16384 bytes)
>> [...]
>> XENBUS: Device with no driver: device/console/0
>> Freeing unused kernel memory: 372k freed
>> Red Hat nash version 6.0.19 starting
>> Mounting proc filesystem
>> Mounting sysfs filesystem
>> Creating /dev
>> BUG: scheduling while atomic: swapper/0/0x00010000
>> Modules linked in:
>> Pid: 0, comm: swapper Not tainted 2.6.29-rc3-tip #481
>> Call Trace:
>> [<ffffffff80238c1f>] __schedule_bug+0x62/0x66
>> [<ffffffff80211d2d>] ? retint_restore_args+0x5/0x20
>> [<ffffffff80503921>] __schedule+0x95/0x792
>> [<ffffffff802093aa>] ? _stext+0x3aa/0x1000
>> [<ffffffff802093aa>] ? _stext+0x3aa/0x1000
>> [<ffffffff805040c2>] schedule+0xe/0x22
>> [<ffffffff8020ff04>] cpu_idle+0x70/0x72
>> [<ffffffff804fc3a0>] cpu_bringup_and_idle+0x13/0x15
>> Creating initial device nodes
>> Setting up hotplug.
>>
>>
>> From what I can see, softirq 8 is the RCU softirq.  I don't know if the 
>> "scheduling while atomic" is related or not, but its two new schedulerish 
>> symptoms appearing at once, so I think its likely they're related.
>>     
>
> Hmmm...  Mysterious, as you seem to be using classic RCU, which hasn't
> changed in awhile.  Which branch of the tip tree are you using?
>   

tip/master.  It looks like this appeared since -rc1.  Mu current 
suspicion is the percpu changes, since I'm seeing some other strange 
symptoms.

    J
