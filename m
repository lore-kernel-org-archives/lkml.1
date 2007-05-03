Return-Path: <linux-kernel-owner+w=401wt.eu-S1031303AbXECNa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031303AbXECNa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031307AbXECNa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:30:59 -0400
Received: from rex.snapgear.com ([203.143.235.140]:47789 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031303AbXECNa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:30:58 -0400
Message-ID: <4639E40D.6030809@snapgear.com>
Date: Thu, 03 May 2007 23:30:53 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: linux-2.6.21-uc0 (MMU-less updates)
References: <46382055.8030203@snapgear.com> <200705030655.36957.rgetz@blackfin.uclinux.org> <4639C164.5070908@snapgear.com> <200705030735.36879.rgetz@blackfin.uclinux.org>
In-Reply-To: <200705030735.36879.rgetz@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Getz wrote:
> On Thu 3 May 2007 07:03, Greg Ungerer pondered:
>> Robin Getz wrote:
>>> On Wed 2 May 2007 07:32, Greg Ungerer pondered:
>>>> Robin Getz wrote:
>>>>> I was trying to understand why we don't want to do the same checking on
>>>>> noMMU?
>>>> The problem is on systems that have RAM mapped at high physical
>>>> addresses. TASK_SIZE may well be a numerically smaller number
>>>> than the address range that RAM sits in. So this test fails when
>>>> it shouldn't.
>>> So, then this is a problem only on one or two architectures, not all
>>> noMMU platforms?
>> Its not an architecture problem. It can effect any board that
>> has RAM mapped at a large numerical addresses (larger than TASK_SIZE).
>> So it can effect any non-MMU platform.
> 
> Depending on how TASK_SIZE is defined - it looks like everyone else forces it 
> to end of memory, except 68k[nommu].
> 
> asm-arm/memory.h:#define TASK_SIZE              (CONFIG_DRAM_SIZE)
> asm-blackfin/processor.h:#define TASK_SIZE      (memory_end)
> asm-frv/mem-layout.h:#define TASK_SIZE                  __UL(0xFFFFFFFFUL)
> 
> asm-m68k/processor.h:#define TASK_SIZE  (0xF0000000UL)
> asm-m68k/processor.h:#define TASK_SIZE  (0x0E000000)
> asm-m68k/processor.h:#define TASK_SIZE  (0x0E000000UL)
> asm-m68knommu/processor.h:#define TASK_SIZE     (0xF0000000UL)

Probably too:

asm-sh/processor.h:#define TASK_SIZE    0x7c000000UL

which has some parts with MMU.

There have been others out of tree that have it like this to.


> I'm happy to learn we are doing something wrong, but I think that we just 
> copied the arm/frv setup.

That is one way to handle it. Have you followed all the other
uses of TASK_SIZE and verified it is not a problem?

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
