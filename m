Return-Path: <linux-kernel-owner+w=401wt.eu-S933608AbYBMQ6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608AbYBMQ6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759292AbYBMQ6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:58:34 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58936
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838AbYBMQ6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:58:33 -0500
Message-ID: <47B3217D.7040903@qumranet.com>
Date: Wed, 13 Feb 2008 18:57:33 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Marcelo Tosatti <marcelo@kvack.org>
CC: Jiri Kosina <jkosina@suse.cz>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Qemu & KVM bug
References: <c4e36d110802130638i5057b49by280ab0b2c415064a@mail.gmail.com> <Pine.LNX.4.64.0802131621440.7699@twin.jikos.cz> <20080213160905.GA8559@dmt>
In-Reply-To: <20080213160905.GA8559@dmt>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Tosatti wrote:
> On Wed, Feb 13, 2008 at 04:24:53PM +0100, Jiri Kosina wrote:
>   
>> On Wed, 13 Feb 2008, Zdenek Kabelac wrote:
>>
>>     
>>> I get this bug in my log whenever I start qemu-kvm - I do not use kqemu 
>>> module - so it's with plain kernel modules. If more details are needed - 
>>> just ask. (Cpu; C2D)
>>> BUG: sleeping function called from invalid context at kernel/rwsem.c:48
>>> in_atomic():1, irqs_disabled():0
>>> INFO: lockdep is turned off.
>>> Pid: 26600, comm: qemu-kvm Not tainted 2.6.25-rc1 #29
>>>       
>> This has been obviously caused by Marcelo's (added to CC) commit 
>> 10589a4699b, which added down_write(mmap_sem) to alloc_apic_access_page(), 
>> which is called with preempt disabled from vmx_create_vcpu().
>>     
>
> alloc_apic_access_page() called mutex_lock, so the warning would trigger
> before that change.
>
> I think it's fine to allocate the APIC page after put_cpu(), since no vcpu 
> state is required.
>
>   


Looks right, but wants a changelog and signoff, of course.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

