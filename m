Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbYC1O5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbYC1O5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 10:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbYC1O51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 10:57:27 -0400
Received: from rtr.ca ([76.10.145.34]:2903 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbYC1O50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 10:57:26 -0400
Message-ID: <47ED0754.5000902@rtr.ca>
Date: Fri, 28 Mar 2008 10:57:24 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, jkosina@suse.cz,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
       Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.25-rc7:  Ugh.
References: <Pine.LNX.4.44L0.0803281027510.4447-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803281027510.4447-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Thu, 27 Mar 2008, Mark Lord wrote:
> 
>> Same thing happens when I rmmod usbhid, and then rmmod ehci_hcd.
>> The rmmod ehci_hcd hangs.
>>
>> But since the rest of the system is still alive, including the non-USB touchpad(!),
>> here is the alt-sysrq-t from syslog:
>>
>> rmmod         D f74c2ddc     0  4538   4492
>>        f6d3b200 00000086 f74c2c90 f74c2ddc c281e840 00000001 c01131be 00000000 
>>        00000001 c0324a00 c0324a00 00000000 00000001 7fffffff 7fffffff f653cea8 
>>        00000002 c02906f8 00000000 00000012 c038f6aa 00000086 c011aa05 00000000 
>> Call Trace:
>>  [__wake_up_common+46/88] __wake_up_common+0x2e/0x58
>>  [schedule_timeout+19/134] schedule_timeout+0x13/0x86
>>  [wake_up_klogd+43/45] wake_up_klogd+0x2b/0x2d
>>  [wait_for_common+205/308] wait_for_common+0xcd/0x134
>>  [default_wake_function+0/8] default_wake_function+0x0/0x8
>>  [__cancel_work_timer+237/312] __cancel_work_timer+0xed/0x138
>>  [wq_barrier_func+0/8] wq_barrier_func+0x0/0x8
>>  [<f889f684>] usb_remove_hcd+0x63/0xd7 [usbcore]
>>  [<f88a858e>] usb_hcd_pci_remove+0x15/0x68 [usbcore]
>>  [pci_device_remove+22/53] pci_device_remove+0x16/0x35
>>  [__device_release_driver+88/118] __device_release_driver+0x58/0x76
>>  [driver_detach+122/182] driver_detach+0x7a/0xb6
>>  [bus_remove_driver+96/126] bus_remove_driver+0x60/0x7e
>>  [pci_unregister_driver+30/95] pci_unregister_driver+0x1e/0x5f
>>  [sys_delete_module+388/445] sys_delete_module+0x184/0x1bd
>>  [remove_vma+49/54] remove_vma+0x31/0x36
>>  [do_page_fault+506/1232] do_page_fault+0x1fa/0x4d0
>>  [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
>>  =======================
>>
>> If nothing else, this should point to where USB is getting deadlocked.
>>
>> ??
> 
> rmmod is hanging up in a call to cancel_work_sync(), which means the
> real problem is in the workqueue.  It's quite understandable that you
> wouldn't want to go any further into debugging this, but in case you
> don't mind, the workqueue task is ksuspend_usbd.
> 
> On the other hand, I don't understand how problems with the RTC 
> configuration could cause this sort of result.
..

Yeah, me neither.   It's not clear whether simply changing the kernel
config made a race condition "go away" for now, or whether it really
fixed things for real.

My system is working with the current config, that's all I know right now.
Gotta fix VMware modules again, but that's de-rigour with new kernels.

Cheers

