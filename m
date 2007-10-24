Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbXJXQIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbXJXQIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbXJXQIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:08:46 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:47259 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbXJXQIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:08:45 -0400
Message-ID: <471F6DFE.3040304@linux.vnet.ibm.com>
Date: Wed, 24 Oct 2007 21:38:30 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: apw@shadowen.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.23-git18 Kernel oops in sg helpers
References: <471E110C.20404@linux.vnet.ibm.com> <20071023184419.GD14671@kernel.dk> <20071024115436.GT32058@shadowen.org> <20071024214014C.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20071024214014C.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Wed, 24 Oct 2007 12:54:36 +0100
> Andy Whitcroft <apw@shadowen.org> wrote:
> 
>> On Tue, Oct 23, 2007 at 08:44:20PM +0200, Jens Axboe wrote:
>>> On Tue, Oct 23 2007, Kamalesh Babulal wrote:
>>>> Hi,
>>>>
>>>> Kernel oops is triggered while running fsx-linux test, followed by cpu softlock
>>>> over the AMD box
>>>>
>>>> Unable to handle kernel NULL pointer dereference at 0000000000000018 RIP: 
>>>>  [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
>>>> PGD 10185b067 PUD 10075b067 PMD 0 
>>>> Oops: 0002 [1] SMP 
>>>> CPU 3 
>>>> Modules linked in:
>>>> Pid: 18676, comm: fsx-linux Not tainted 2.6.23-git18-autokern1 #1
>>>> RIP: 0010:[<ffffffff8021f2f6>]  [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
>>>> RSP: 0000:ffff810181edf948  EFLAGS: 00010002
>>> Can you check where gart_map_sg+0x26c is at? Make sure you have
>>> CONFIG_DEBUG_INFO defined, then do:
>>>
>>> $ gdb vmlinux
>>> $ l *gart_map_sg+0x26c
>> Ok, this problem still seems to be about in 2.6.24-rc1.  Here is the gdb
>> output from that version, the panic (also below) seems the same:
>>
>> (gdb) l *gart_map_sg+0x26c
>> 0xffffffff8022011e is in gart_map_sg (arch/x86/kernel/pci-gart_64.c:433).
>> 428                     goto error;
>> 429             out++;
>> 430             flush_gart();
>> 431             if (out < nents) {
>> 432                     sgmap = sg_next(sgmap);
>> 433                     sgmap->dma_length = 0;
>> 434             }
>> 435             return out;
>> 436
>> 437     error:
>>
>> So it seems sg_next has returned 0.
> 
> Have you tried this?
> 
> http://marc.info/?l=linux-kernel&m=119317981406073&w=2
> -
Hi,
Thanks, this patch solves the kernel oops.
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
