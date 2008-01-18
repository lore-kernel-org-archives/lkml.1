Return-Path: <linux-kernel-owner+w=401wt.eu-S1760977AbYARQGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977AbYARQGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761778AbYARQFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:05:49 -0500
Received: from gw.goop.org ([64.81.55.164]:47153 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761599AbYARQFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:05:48 -0500
Message-ID: <4790CE5A.6010007@goop.org>
Date: Fri, 18 Jan 2008 08:05:46 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: Debug warning: early ioremap leak of 2 areas detected.
References: <478FDC52.5010002@goop.org> <20080118092812.GI24337@elte.hu>
In-Reply-To: <20080118092812.GI24337@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> sidenote, is this failure normal:
>
>   
>> acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
>>     
>
> ?
>   

Yes, I see it on all boots.  When booting native, I get a "acpiphp: too 
many resources found"  message (I'll get the exact wording next time I 
boot).

> the leaked ioremap seems to be:
>
>   
>> early_ioremap(2fff0a10, 00000040) [1] => Pid: 1, comm: swapper Not tainted 2.6.24-rc8 #1877
>> [<c04e3913>] early_ioremap+0x49/0x157
>> [<c0117057>] __acpi_map_table+0x2f/0x31
>> [<c0279459>] acpi_os_map_memory+0x1a/0x1c
>> [<c028b4fc>] acpi_tb_verify_table+0x20/0x4d
>> [<c028acea>] acpi_get_table+0x4a/0x91
>> [<c04ec303>] acpi_processor_init+0x35/0xcf
>> [<c04d44b8>] kernel_init+0x14f/0x2a5
>> [<c0107c12>] ? ret_from_fork+0x6/0x1c
>> [<c04d4369>] ? kernel_init+0x0/0x2a5
>> [<c04d4369>] ? kernel_init+0x0/0x2a5
>> [<c01089f3>] kernel_thread_helper+0x7/0x10
>> =======================
>> 00000a10 + ffd40000
>>     
>
>   
>> Debug warning: early ioremap leak of 2 areas detected.
>> please boot with early_ioremap_debug and report the dmesg.
>>     
>
> hm, why does it say 2? I only see a single backtrace in the dmesg you 
> sent. ( Could you boot with ignore_loglevel to make sure you get all 
> printks to the log? )
>   

Even with ignore_loglevel, only one trace appears in the log.

> Btw., did the bootup otherwise go fine? The typical nesting is at most 2 
> levels, and i've kept the max nesting at 4 so the typical 1-2 leaks 
> should have no functional/correctness aspect on the bootup, just that 
> warning message. Once we hit the 5th leaked ioremap we start rejecting 
> early_ioremap()s and that might result in boot failures.
>   

Yep, it made it up to userspace fine.  I'll try a boot on real hardware 
soon.

    J
