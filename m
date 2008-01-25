Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbYAYH75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbYAYH75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760800AbYAYHnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:43:10 -0500
Received: from gw.goop.org ([64.81.55.164]:47824 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762267AbYAYHnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:43:09 -0500
Message-ID: <4799930B.40006@goop.org>
Date: Thu, 24 Jan 2008 23:43:07 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: trim ram need to check if mtrr is there v2
References: <47993F1A.5070408@goop.org> <4799400C.1060102@zytor.com> <200801241947.55223.yinghai.lu@sun.com>
In-Reply-To: <200801241947.55223.yinghai.lu@sun.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> [PATCH] x86: trim ram need to check if mtrr is there v2
>
>   
>>> Jeremy Fitzhardinge wrote:
>>> When booting a current x86.git kernel under kvm, I get this:
>>>
>>> (qemu) Linux version 2.6.24-rc8 (jeremy@ezr) (gcc version 4.1.2 20070925 
>>> (Red Hat 4.1.2-33)) #1928 SMP PREEMPT Thu Jan 24 17:09:04 PST 2008
>>> early_ioremap_init()
>>> BIOS-provided physical RAM map:
>>> BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>>> BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>>> BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
>>> BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
>>> BIOS-e820: 000000001fff0000 - 0000000020000000 (ACPI data)
>>> BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
>>> console [earlyser0] enabled
>>> 0MB HIGHMEM available.
>>> 511MB LOWMEM available.
>>> Scan SMP from c0000000 for 1024 bytes.
>>> Scan SMP from c009fc00 for 1024 bytes.
>>> Scan SMP from c00f0000 for 65536 bytes.
>>> Scan SMP from c009fc00 for 1024 bytes.
>>> ***************
>>> **** WARNING: likely BIOS bug
>>> **** MTRRs don't cover all of memory, trimmed 131056 pages
>>> ***************
>>>       
>> H. Peter Anvin wrote:
>> Looks like the code doesn't check that the CPU *has* MTRRs...
>>     
>
> so check it mtrr is there, also check if mem less 4G and is AMD as early
>   

Thanks, this gets me to usermode under kvm.

    J
