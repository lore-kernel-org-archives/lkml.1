Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbYD2LwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbYD2LwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYD2LwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:52:11 -0400
Received: from hu-out-0506.google.com ([72.14.214.238]:53490 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYD2LwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:52:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=qnXAZpClX6ru9f4lwlkSbgnMtrgyM2ApewqqJhMZmJ+7N+OpG/tfWtAw+0A0A/62AfqTVs97L/6yWweq4g9XlvN3phI6/hiD3O+8GkogI1ukS8I7gBIYm+ukTSH4Se/iG8eGStqX9XMCUjD/f/jCuHjAEIK3CWfH4DQ2h0nmfxk=
Message-ID: <48170BDB.9000801@googlemail.com>
Date: Tue, 29 Apr 2008 13:51:55 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: mtrr cleanup for converting continuous to discrete
 layout v7
References: <200804272337.40130.yhlu.kernel@gmail.com>	 <200804281316.14168.yhlu.kernel@gmail.com>	 <200804281505.05764.yhlu.kernel@gmail.com>	 <200804290200.33459.yhlu.kernel@gmail.com>	 <4816EEA1.6050804@googlemail.com>	 <86802c440804290330wd582daetb2a9c41a69f6e028@mail.gmail.com> <86802c440804290356l678d3a0cxedcbe21a1f7642d1@mail.gmail.com>
In-Reply-To: <86802c440804290356l678d3a0cxedcbe21a1f7642d1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Tue, Apr 29, 2008 at 3:30 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> On Tue, Apr 29, 2008 at 2:47 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
>>  > Yinghai Lu wrote:
>>  >  > some BIOS like to use continus MTRR layout, and may X driver can not add
>>  >  > WB entries for graphical cards when 4g or more RAM installed.
>>  >  >
>>  >  > the patch will change MTRR to discrete.
>>  >  >
>>  >  > mtrr_chunk_size= could be used to have smaller continuous block to hold holes.
>>  >  > default is 256m, could be set according to size of graphics card memory.
>>  >  >
>>  >  > v2: fix -1 for UC checking
>>  >  > v3: default to disable, and need use enable_mtrr_cleanup to enable this feature
>>  >  >     skip the var state change warning.
>>  >  >     remove next_basek in range_to_mtrr()
>>  >  > v4: correct warning mask.
>>  >  > v5: CONFIG_MTRR_SANITIZER
>>  >  > v6: fix 1g, 2g, 512 aligment with extra hole
>>  >  > v7: gran_sizek to prevent running out of MTRRs.
>>  >  >
>>  >
>>  >  With this version ( and patch http://lkml.org/lkml/2008/4/29/97 ) applyed on latest linus git tree
>>  >  the box OOPS'es early.
>>  >
>>  >  Sorry I don't have time right now to write down the part of the OOPS I can see on monitor , I can try to find
>>  >  some time later.
>>  >
>>  >  In any way OOPS'es on __free_one_page+0x191/0x21e
>>
>>  thanks. found one problem with hole_basek ...
>>
>>  will send you v8, and hope it will be last version.
> 
> please try v8, it should get rid of the 8m entry. it need patch
> http://lkml.org/lkml/2008/4/29/97 too.

Box does boot with v8 but now I get that warning you fixed in v2 again =):

....
[    0.000000] Linux version 2.6.25-06058-ga01e035-dirty (crazy@thor) (gcc version 4.3.0 (Frugalware Linux) ) #805 SMP PREEMPT Tue Apr 29 13:04:49 CEST 2008
[    0.000000] Command line: root=/dev/sdb1 ro debug vga=0x317
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
[    0.000000]  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf550000 (usable)
[    0.000000]  BIOS-e820: 00000000cf550000 - 00000000cf55e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf5e0000 - 00000000cf600000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 156) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 849232) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1228800) 2 entries of 256 used
[    0.000000] max_pfn_mapped = 1228800
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] After WB checking
[    0.000000] MTRR MAP PFN: 0000000000000000 - 000000000012c000
[    0.000000] After UC checking
[    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
[    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
[    0.000000] MTRR MAP PFN: 00000000000cf800 - 00000000000d0000
[    0.000000] After sorting
[    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
[    0.000000] MTRR MAP PFN: 00000000000cf800 - 00000000000d0000
[    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
[    0.000000] range0: 0000000000000000 - 00000000c0000000
[    0.000000] Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
[    0.000000] Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
[    0.000000] range: 00000000c0000000 - 00000000d0000000
[    0.000000] Setting variable MTRR 2, base: 3072MB, range: 256MB, type WB
[    0.000000] hole: 00000000cc000000 - 00000000d0000000
[    0.000000] Setting variable MTRR 3, base: 3264MB, range: 64MB, type UC
[    0.000000] rangeX: 00000000d0000000 - 00000000d0000000
[    0.000000] range0: 0000000100000000 - 0000000120000000
[    0.000000] Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
[    0.000000] range: 0000000120000000 - 0000000130000000
[    0.000000] Setting variable MTRR 5, base: 4608MB, range: 256MB, type WB
[    0.000000] hole: 000000012c000000 - 0000000130000000
[    0.000000] Setting variable MTRR 6, base: 4800MB, range: 64MB, type UC
[    0.000000] DONE variable MTRRs
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] After WB checking
[    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000d0000
[    0.000000] MTRR MAP PFN: 0000000000100000 - 0000000000130000
[    0.000000] After UC checking
[    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cc000
[    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
[    0.000000] After sorting
[    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cc000
[    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
[    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 757MB of RAM.
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1227 mtrr_trim_uncached_memory+0x30c/0x35a()
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.25-06058-ga01e035-dirty #805
[    0.000000]
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8022d661>] warn_on_slowpath+0x51/0x78
[    0.000000]  [<ffffffff8067f0dc>] x86_get_mtrr_mem_range+0x241/0x25c
[    0.000000]  [<ffffffff8067d93e>] update_memory_range+0x95/0xb7
[    0.000000]  [<ffffffff8067fb02>] mtrr_trim_uncached_memory+0x30c/0x35a
[    0.000000]  [<ffffffff8067ca43>] setup_arch+0x280/0x4a2
[    0.000000]  [<ffffffff80676aa6>] start_kernel+0x6e/0x308
[    0.000000]  [<ffffffff80676432>] x86_64_start_kernel+0x241/0x24a
[    0.000000]
[    0.000000] ---[ end trace ca143223eefdc828 ]---
[    0.000000] update e820 for mtrr -- holes
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 000000000009cc00 (usable)
[    0.000000]  modified: 000000000009cc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000cc000000 (usable)
[    0.000000]  modified: 00000000cc000000 - 00000000cf550000 (reserved)
[    0.000000]  modified: 00000000cf550000 - 00000000cf55e000 (ACPI data)
[    0.000000]  modified: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
[    0.000000]  modified: 00000000cf5e0000 - 00000000cf600000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffc00000 - 000000012c000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 156) 3 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 835584) 3 entries of 256 used
[    0.000000] max_pfn_mapped = 1228800
[    0.000000] init_memory_mapping 

...
                                                                                                                       > 
> Thanks
> 
> Yinghai Lu
> 


Gabriel
