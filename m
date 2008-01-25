Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbYAYTjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbYAYTjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 14:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYAYTjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 14:39:36 -0500
Received: from gw.goop.org ([64.81.55.164]:41165 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbYAYTjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 14:39:35 -0500
Message-ID: <479A3AF5.2040701@goop.org>
Date: Fri, 25 Jan 2008 11:39:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: trim ram need to check if mtrr is there v3
References: <47993F1A.5070408@goop.org> <200801241947.55223.yinghai.lu@sun.com>	 <4799930B.40006@goop.org> <200801250042.53074.yinghai.lu@sun.com>	 <20080125110935.GA20026@elte.hu> <479A30A3.7050305@goop.org>	 <20080125185923.GA2518@elte.hu> <479A3222.30008@goop.org>	 <20080125190418.GA7817@elte.hu> <479A3823.7000009@goop.org> <86802c440801251132s463f5aceif33dbe46b6ff77a2@mail.gmail.com>
In-Reply-To: <86802c440801251132s463f5aceif33dbe46b6ff77a2@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Jan 25, 2008 11:27 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>   
>> Ingo Molnar wrote:
>>     
>>> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>>
>>>
>>>       
>>>> I was referring to:
>>>>
>>>> commit 6a4544a9c8b54b82893044cb53695502cc386f00
>>>> Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
>>>> Date:   Fri Jan 25 00:15:29 2008 +0100
>>>>
>>>>    x86_32: trim memory by updating e820 v3
>>>>
>>>> but you've answered the question...
>>>>
>>>>         
>>> yeah, i guess what i've pushed out just now is v3++. Does it work for
>>> you?
>>>
>>>       
>> Yes, it does.  And for the record:
>>
>> [root@qemu ~]# cat /proc/mtrr
>> [root@qemu ~]#
>>     
>
> so the boot msg say:
> WARNING: strange, CPU MTRRs all blank?
>   

Yes.

WARNING: strange, CPU MTRRs all blank?
------------[ cut here ]------------
WARNING: at /home/jeremy/hg/xen/paravirt/linux/arch/x86/kernel/cpu/mtrr/main.c:710 mtrr_trim_uncached_memory+0xf8/0x17b()
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.24 #1938
 [<c012804c>] warn_on_slowpath+0x41/0x51
 [<c01285d4>] ? __call_console_drivers+0x4e/0x5a
 [<c03c3e85>] ? _spin_unlock_irqrestore+0xf/0x2f
 [<c03c3e91>] ? _spin_unlock_irqrestore+0x1b/0x2f
 [<c012880c>] ? release_console_sem+0x1a0/0x1a8
 [<c0128c1f>] ? vprintk+0x294/0x2ee
 [<c0128c2b>] ? vprintk+0x2a0/0x2ee
 [<c04e811b>] ? __alloc_bootmem_core+0x100/0x27a
 [<c0128c8e>] ? printk+0x15/0x17
 [<c0128c8e>] ? printk+0x15/0x17
 [<c04de51e>] mtrr_trim_uncached_memory+0xf8/0x17b
 [<c04de7ae>] ? mtrr_bp_init+0x20d/0x215
 [<c04dc79b>] setup_arch+0x283/0x3c2
 [<c0128c8e>] ? printk+0x15/0x17
 [<c04d6689>] start_kernel+0x60/0x311
 =======================

	J


