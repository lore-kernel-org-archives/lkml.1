Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbZB0T1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbZB0T1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 14:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbZB0T07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 14:26:59 -0500
Received: from gw.goop.org ([64.81.55.164]:41922 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495AbZB0T06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 14:26:58 -0500
Message-ID: <49A83E7D.1080508@goop.org>
Date: Fri, 27 Feb 2009 11:26:53 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: add brk allocation for very, very early allocations
References: <49A829CE.9020509@goop.org> <49A83C52.5050801@zytor.com>
In-Reply-To: <49A83C52.5050801@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>   
>> unsigned int boot_cpu_id __read_mostly;
>> +__initdata unsigned long _brk_start, _brk_end;
>>
>>     
>
> Better yet, initialize _brk_start and _brk_end statically:
>
> extern const char _end[];
> __initdata unsigned long _brk_start = (unsigned long)&_end;
> __initdata unsigned long _brk_end   = (unsigned long)&_end;
>
> That way it's available from the first instruction, and we can fully
> remove the x86-32 init_pg_tables_end and replace it with _brk_end (thus
> putting the initial page tables in the brk.)

Yes.  It doesn't work for Xen (the domain builder puts the initrd and 
Xen-built pagetable immediately after the kernel's bss), but its no 
problem to move the brk in that case.

    J
