Return-Path: <linux-kernel-owner+w=401wt.eu-S939856AbXHIQCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939856AbXHIQCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932298AbXHIQCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:02:01 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:56146 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761848AbXHIQB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:01:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=VbSFH93tIXO4VZQaOfa7C+OxzOJJg14/QEJzvQGBVosvzvH9lRTcDf367786YT5Ekct0xwDVYSafhD0nN75/dhOQo29LihHxpV7MV4RUT0DtJSBfkjj+ZvDfz1Bibcqod+RTG/q2T6sC/vJkN5WR7ymyTKCE6GG8D40R+AedaLE=
Message-ID: <46BB3A2A.9010703@googlemail.com>
Date: Thu, 09 Aug 2007 18:00:42 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm1: kernel BUG at mm/swap_state.c:78!
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org> <200708091711.53898.m.kozlowski@tuxland.pl> <Pine.LNX.4.64.0708091633540.8627@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0708091633540.8627@blonde.wat.veritas.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins pisze:
> On Thu, 9 Aug 2007, Mariusz Kozlowski wrote:
>> Hello,
>>
>> 	Nothing unusual happening, allmodconfig compiling etc.
>> Not sure why it says kernel was tainted though ... hmmm.
>>
>> ------------[ cut here ]------------
>> kernel BUG at mm/swap_state.c:78!
>> invalid opcode: 0000 [#1]
>> PREEMPT 
>> Modules linked in: orinoco_cs orinoco hermes pl2303 usbserial pcmcia 8250_pci 8250 serial_core yenta_socket rsrc_nonstatic pcmcia_core 8139too
>> CPU:    0
>> EIP:    0060:[<c01504b7>]    Tainted: P        VLI
>> EFLAGS: 00010246   (2.6.23-rc2-mm1 #1)
>> EIP is at __add_to_swap_cache+0xc6/0xd7
>> eax: 40000000   ebx: c11285c0   ecx: 000000d0   edx: 00000283
>> esi: c11285c0   edi: 00000283   ebp: c1858f90   esp: c1858f84
>> ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
>> Process kprefetchd (pid: 236, ti=c1858000 task=c18d14d0 task.ti=c1858000)
>> Stack: 00000283 c11285c0 c3d5a3c8 c1858fa0 c01504ea c11285c0 00000000 c1858fcc 
>>        c015307c 00000001 00000007 00000002 00000002 00000283 00000000 fffffffc 
>>        00000000 c0152d5c c1858fe0 c0127f2e c0127ef8 00000000 00000000 00000000 
>> Call Trace:
>>  [<c010456a>] show_trace_log_lvl+0x1a/0x30
>>  [<c0104629>] show_stack_log_lvl+0xa9/0xd5
>>  [<c010486e>] show_registers+0x219/0x38d
>>  [<c0104ae6>] die+0x104/0x23e
>>  [<c0419bd3>] do_trap+0x83/0xad
>>  [<c0104edf>] do_invalid_op+0x88/0x92
>>  [<c04199b2>] error_code+0x6a/0x70
>>  [<c01504ea>] add_to_swap_cache+0x22/0x58
>>  [<c015307c>] kprefetchd+0x320/0x364
>>  [<c0127f2e>] kthread+0x36/0x58
>>  [<c0104233>] kernel_thread_helper+0x7/0x14
>>  =======================
>> INFO: lockdep is turned off.
>> Code: 0f 89 7b 0c 83 05 fc c9 53 c0 01 8b 13 c1 ea 1e 8d 04 12 01 d0 c1 e0 03 29 d0 c1 e0 05 ff 80 b8 c0 53 c0 ff 05 34 1d 68 c0 eb 96 <0f> 0b eb fe 0f 0b eb fe 0f 0b eb fe 8b 53 0c eb be 55 89 e5 56 
>> EIP: [<c01504b7>] __add_to_swap_cache+0xc6/0xd7 SS:ESP 0068:c1858f84
> 

The same issue here.

> Don't worry about reproducing untainted, I got the same earlier
> and was just preparing and testing the hotfix: here it is...
> 

Thanks for the patch.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
