Return-Path: <linux-kernel-owner+w=401wt.eu-S1764739AbYDNS0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764739AbYDNS0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761379AbYDNS0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:26:42 -0400
Received: from rv-out-0708.google.com ([209.85.198.240]:2168 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760499AbYDNS0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:26:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JCChugqb95bLzYkq59wbUFQbaL/AxgtQbnZprkLUDxZ2gQYB/b331JtARKUEpD26Z8SwfJKOaL/3Sc4etKlE67uV+2E4WU0ODbqHLg/morZwmeX4pJyPFL4OYdSiA2zns5kYI/HOPu4RBjSyEHoVdkIq0jn2hlWnLIuYOsRmhJE=
Message-ID: <86802c440804141126x1744da7ewf988a0c9b13f14c8@mail.gmail.com>
Date: Mon, 14 Apr 2008 11:26:40 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [BUG] linux-next: Tree for April 14 - kernel BUG at arch/powerpc/mm/init_64.c:240! (fixed in -mm)
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, pbadari@us.ibm.com,
       michael@ellerman.id.au, "andy whitcroft" <apw@shadowen.org>
In-Reply-To: <480349EB.8040708@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080414203423.22bf99d1.sfr@canb.auug.org.au>
	 <480349EB.8040708@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 5:11 AM, Kamalesh Babulal
<kamalesh@linux.vnet.ibm.com> wrote:
> Hi Stephen,
>
>  The next-20080414 kernel panic's while booting up on the ppc machines.
>  The same was seen in the 2.6.25-rc8-mm1 kernel and was fixed by
>  the patch at http://lkml.org/lkml/2008/4/2/650
>
>  ------------[ cut here ]------------
>  kernel BUG at arch/powerpc/mm/init_64.c:240!
>  Oops: Exception in kernel mode, sig: 5 [#1]
>  SMP NR_CPUS=128 NUMA pSeries
>  Modules linked in:
>  NIP: c0000000006ca18c LR: c0000000006ca184 CTR: 0000000000000000
>  REGS: c00000000081f950 TRAP: 0700   Not tainted  (2.6.25-rc9-next-20080414-x86-latest.git-autotest)
>  MSR: 8000000000021032 <ME,IR,DR>  CR: 24000088  XER: 20000001
>  TASK = c0000000007334d0[0] 'swapper' THREAD: c00000000081c000 CPU: 0
>  GPR00: c0000000006ca184 c00000000081fbd0 c00000000081c778 0000000000000001
>  GPR04: c0000000006def90 000000000000016e 0000000000000170 0000000000001090
>  GPR08: 0000000207038208 0000000000000000 0000000000000001 800000000ed93080
>  GPR12: c00000000081fae0 c000000000733e80 0000000000000000 c0000000005f4788
>  GPR16: 4000000002100000 c0000000005f3010 0000000000000000 000000000023f000
>  GPR20: 00000000027d07d8 c0000000006d07d8 00000000027d0a48 c0000000006d0a48
>  GPR24: c0000000005f41c8 0000000002b00000 0000000000000000 0000000000000000
>  GPR28: cf000000001f8000 cf00000001000000 0000000001000000 cf00000000000000
>  NIP [c0000000006ca18c] .vmemmap_populate+0xbc/0x100
>  LR [c0000000006ca184] .vmemmap_populate+0xb4/0x100
>  Call Trace:
>  [c00000000081fbd0] [c0000000006ca184] .vmemmap_populate+0xb4/0x100 (unreliable)
>  [c00000000081fc70] [c0000000006cae08] .sparse_mem_map_populate+0x38/0x5c
>  [c00000000081fd00] [c0000000006b8db0] .sparse_early_mem_map_alloc+0x54/0x94
>  [c00000000081fd90] [c0000000006b91d8] .sparse_init+0x1dc/0x218
>  [c00000000081fe40] [c0000000006a54f4] .setup_arch+0x1ac/0x218
>  [c00000000081fed0] [c00000000069c6c0] .start_kernel+0xec/0x464
>  [c00000000081ff90] [c000000000008524] .start_here_common+0x54/0xb0
>  Instruction dump:
>  7fe3fb78 7ca02a14 4082000c 3860fff4 48000040 e9228980 e9628988 e8e90002
>  e90b0002 4b961ab1 60000000 78630fe0 <0b030000> 7ffff214 7fbdf214 7fbfe040
>  ---[ end trace 8640abe69a316dee ]---
>  Kernel panic - not syncing: Attempted to kill the idle task!
>  Call Trace:
>  [c00000000081f470] [c00000000000f970] .show_stack+0x70/0x1bc (unreliable)
>  [c00000000081f520] [c0000000000540fc] .panic+0x80/0x1b8
>  [c00000000081f5c0] [c000000000058ca4] .do_exit+0x8c/0x758
>  [c00000000081f680] [c0000000000235cc] .die+0x24c/0x27c
>  [c00000000081f720] [c0000000000238fc] ._exception+0x88/0x204
>  [c00000000081f8e0] [c000000000004a84] program_check_common+0x104/0x180
>  --- Exception: 700 at .vmemmap_populate+0xbc/0x100
>     LR = .vmemmap_populate+0xb4/0x100
>  [c00000000081fc70] [c0000000006cae08] .sparse_mem_map_populate+0x38/0x5c
>  [c00000000081fd00] [c0000000006b8db0] .sparse_early_mem_map_alloc+0x54/0x94
>  [c00000000081fd90] [c0000000006b91d8] .sparse_init+0x1dc/0x218
>  [c00000000081fe40] [c0000000006a54f4] .setup_arch+0x1ac/0x218
>  [c00000000081fed0] [c00000000069c6c0] .start_kernel+0xec/0x464
>  [c00000000081ff90] [c000000000008524] .start_here_common+0x54/0xb0
>


Ingo already update that in x86.git#latest.

so linux-next of today or tomorrow will fix this.

Thanks

YH
