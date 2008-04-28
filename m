Return-Path: <linux-kernel-owner+w=401wt.eu-S933350AbYD1Jyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350AbYD1Jyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763017AbYD1Jyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:54:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:24669 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbYD1Jyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:54:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=gSyJBOzBcrr8ECiT9a2htBUVMdS6swWuuq6MPQfvOCsl07WwcX+SwwKA70tEYc9uiPlVUzNyLRf5gcs55FwPFpZQ5bZVCUH88+A1EwN+5KLYUZ091nPy2G7IRMuIO3Pio/dmTrwekxdhbEcDMoGP0/RrL+QteVBMGCaU5+UKk7U=
Message-ID: <48159ECF.9020004@googlemail.com>
Date: Mon, 28 Apr 2008 11:54:23 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Mika Fischer <mika.fischer@zoopnet.de>, balajirrao@gmail.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
References: <200801192045.17291.yinghai.lu@sun.com>	 <200801202256.48365.yinghai.lu@sun.com>	 <20080122165125.GA17992@elte.hu>	 <200801221623.20861.yinghai.lu@sun.com>	 <20080426035614.a30afb17.akpm@linux-foundation.org>	 <48132665.8050202@googlemail.com>	 <86802c440804272344yac6a9f0n40809169424247e6@mail.gmail.com>	 <48159668.5010808@googlemail.com> <86802c440804280234y5b38b4bds330fc1a6987202c5@mail.gmail.com>
In-Reply-To: <86802c440804280234y5b38b4bds330fc1a6987202c5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Mon, Apr 28, 2008 at 2:18 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
>> Yinghai Lu wrote:
>>  > On Sat, Apr 26, 2008 at 5:56 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
>>  >> Andrew Morton wrote:
>>  >>  > On Tue, 22 Jan 2008 16:23:20 -0800 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
>>  >>  >
>>  >>  >> [PATCH] x86_32: trim memory by updating e820 v3
>>  >>  >>
>>  >>  >> when mtrr is not covering all e820 table, need to trim the ram, need to update e820
>>  >>  >>
>>  >>  >> reuse some code for x86_64
>>  >>  >>
>>  >>  >> here need to add early_get_cap and use it in early_cpu_detect, and move mtrr_bp_init early
>>  >>  >>
>>  >>  >> need Justine to test with his special system with bug bios.
>>  >>  >>
>>  >>  >> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
>>  >>  >
>>  >>  > Speaking of mtrr and e820....
>>  >>  >
>>  >>  > Could someone please take a peek at
>>  >>  > http://bugzilla.kernel.org/show_bug.cgi?id=10508 ?
>>  >>  >
>>  >>  > For some reason we seem to have turned this:
>>  >>  >
>>  >>  > [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
>>  >>  > [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
>>  >>  > [    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
>>  >>  > [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf6d0000 (usable)
>>  >>  > [    0.000000]  BIOS-e820: 00000000bf6d0000 - 00000000bf6e3000 (ACPI NVS)
>>  >>  > [    0.000000]  BIOS-e820: 00000000bf6e3000 - 00000000c0000000 (reserved)
>>  >>  > [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>>  >>  > [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
>>  >>  > [    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
>>  >>  > [    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
>>  >>  > [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
>>  >>  > [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>>  >>  > [    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
>>  >>  > [    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
>>  >>  >
>>  >>  > into this:
>>  >>  >
>>  >>  > reg00: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
>>  >>  > reg01: base=0x00000000 ( 0MB), size=4096MB: write-back, count=1
>>  >>  > reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
>>  >>  > reg03: base=0xbf700000 (3063MB), size= 1MB: uncachable, count=1
>>  >>  > reg04: base=0xbf800000 (3064MB), size= 8MB: uncachable, count=1
>>  >>  >
>>  >>  > which screws up the X server's attempt to map the video memory at
>>  >>  > 0xd0000000.
>>  >>
>>  >>  I see that on my box with ASUS P5E-VM DO and 4G RAM.
>>  >>  It has an Q35 intel chipset and the intel card is set to use 256MB in BIOS.
>>  >>
>>  >>  I tested 2.6.{24*,25,25-next,25-latest-git} 32/64 bit.
>>  >>
>>  >>  Also I get the mtrr type mismatch message on 32 and 64 bit kernels.
>>  >>
>>  >>  ...
>>  >>
>>  >>  [    0.000000] BIOS-provided physical RAM map:
>>  >>  [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
>>  >>  [    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
>>  >>  [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
>>  >>  [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf550000 (usable)
>>  >>  [    0.000000]  BIOS-e820: 00000000cf550000 - 00000000cf55e000 (ACPI data)
>>  >>  [    0.000000]  BIOS-e820: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
>>  >>  [    0.000000]  BIOS-e820: 00000000cf5e0000 - 00000000cf600000 (reserved)
>>  >>
>>  >> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>>  >>  [    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
>>  >>  [    0.000000]  BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
>>  >>  ...
>>  >>
>>  >>  cat /proc/mtrr :
>>  >>
>>  >>  reg00: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
>>  >>  reg01: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
>>  >>  reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
>>  >>  reg03: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
>>  >>  reg04: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
>>  >>  reg05: base=0x128000000 (4736MB), size=  64MB: write-back, count=1
>>  >>  reg06: base=0xcf600000 (3318MB), size=   2MB: uncachable, count=1
>>  >
>>  > please try the patch at
>>  >
>>  > http://lkml.org/lkml/2008/4/28/52
>>  >
>>  > with mtrr_chunk_size=1g
>>
>>  Hi,
>>
>>  With mtrr_chunk_size=1g my box won't boot :( ( just tested 64bit kernel ).
>>
>>  It does without but I get a warning:
>>
>>
>>  ...
>>
>>
>>  [    0.000000] BIOS-provided physical RAM map:
>>  [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
>>  [    0.000000]  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
>>
>> [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
>>  [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf550000 (usable)
>>  [    0.000000]  BIOS-e820: 00000000cf550000 - 00000000cf55e000 (ACPI data)
>>  [    0.000000]  BIOS-e820: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
>>  [    0.000000]  BIOS-e820: 00000000cf5e0000 - 00000000cf600000 (reserved)
>>  [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>>  [    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
>>  [    0.000000]  BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
>>  [    0.000000] Entering add_active_range(0, 0, 156) 0 entries of 256 used
>>  [    0.000000] Entering add_active_range(0, 256, 849232) 1 entries of 256 used
>>  [    0.000000] Entering add_active_range(0, 1048576, 1228800) 2 entries of 256 used
>>  [    0.000000] max_pfn_mapped = 1228800
>>  [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>>  [    0.000000] After WB checking
>>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 0000000000100000
>>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 0000000000120000
>>  [    0.000000] MTRR MAP PFN: 0000000000120000 - 0000000000128000
>>  [    0.000000] MTRR MAP PFN: 0000000000128000 - 000000000012c000
>>  [    0.000000] After UC checking
>>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
>>  [    0.000000] MTRR MAP PFN: 0000000000100001 - 0000000000120000
>>  [    0.000000] MTRR MAP PFN: 0000000000120000 - 0000000000128000
>>  [    0.000000] MTRR MAP PFN: 0000000000128000 - 000000000012c000
>>  [    0.000000] MTRR MAP PFN: 00000000000cf801 - 00000000000d0000
>>  [    0.000000] After sorting
>>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
>>  [    0.000000] MTRR MAP PFN: 00000000000cf801 - 00000000000d0000
>>  [    0.000000] MTRR MAP PFN: 0000000000100001 - 0000000000120000
>>  [    0.000000] MTRR MAP PFN: 0000000000120000 - 0000000000128000
>>  [    0.000000] MTRR MAP PFN: 0000000000128000 - 000000000012c000
>>  [    0.000000] rangeX: 0000000000000000 - 00000000d0000000
>>  [    0.000000] Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
>>  [    0.000000] Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
>>  [    0.000000] Setting variable MTRR 2, base: 3072MB, range: 256MB, type WB
>>  [    0.000000] range0: 00000000cf801000 - 00000000cf801000
>>  [    0.000000] range: 00000000cf801000 - 00000000d0000000
>>  [    0.000000] Setting variable MTRR 3, base: 3320MB, range: 0MB, type WB
>>  [    0.000000] Setting variable MTRR 4, base: 3320MB, range: 0MB, type WB
>>  [    0.000000] Setting variable MTRR 5, base: 3320MB, range: 0MB, type WB
>>  [    0.000000] Setting variable MTRR 6, base: 3320MB, range: 0MB, type WB
>>  [    0.000000] Setting variable MTRR 7, base: 3320MB, range: 0MB, type WB
>>  [    0.000000] range0: 0000000100001000 - 0000000110001000
>>  [    0.000000] range: 0000000110001000 - 0000000120001000
>>  [    0.000000] hole: 0000000120000000 - 0000000120001000
>>  [    0.000000] DONE variable MTRRs
>>  [    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
>>  [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 1472MB of RAM.
>>  [    0.000000] ------------[ cut here ]------------
>>  [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1049 mtrr_trim_uncached_memory+0x154/0x18d()
>>
>> [    0.000000] Modules linked in:
>>  [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.25-05561-g064922a-dirty #797
>>  [    0.000000]
>>  [    0.000000] Call Trace:
>>  [    0.000000]  [<ffffffff802374f4>] warn_on_slowpath+0x64/0xb0
>>  [    0.000000]  [<ffffffff8074ac5b>] mtrr_trim_uncached_memory+0x154/0x18d
>>  [    0.000000]  [<ffffffff80747a08>] setup_arch+0x356/0x599
>>  [    0.000000]  [<ffffffff80740b6f>] start_kernel+0x5c/0x3b9
>>  [    0.000000]  [<ffffffff80740425>] x86_64_start_kernel+0x225/0x270
>>
>> [    0.000000]
>>  [    0.000000] ---[ end trace ca143223eefdc828 ]---
>>  [    0.000000] update e820 for mtrr
>>  [    0.000000] modified physical RAM map:
>>  [    0.000000]  modified: 0000000000000000 - 000000000009cc00 (usable)
>>  [    0.000000]  modified: 000000000009cc00 - 00000000000a0000 (reserved)
>>  [    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
>>  [    0.000000]  modified: 0000000000100000 - 00000000cf550000 (usable)
>>  [    0.000000]  modified: 00000000cf550000 - 00000000cf55e000 (ACPI data)
>>  [    0.000000]  modified: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
>>  [    0.000000]  modified: 00000000cf5e0000 - 00000000cf600000 (reserved)
>>  [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
>>  [    0.000000]  modified: 00000000ffc00000 - 000000012c000000 (reserved)
>>  [    0.000000] Entering add_active_range(0, 0, 156) 3 entries of 256 used
>>  [    0.000000] Entering add_active_range(0, 256, 849232) 3 entries of 256 used
>>  [    0.000000] max_pfn_mapped = 1228800
>>  [    0.000000] init_memory_mapping
>>
>>  ...
>>
>>
>>  --($:~)-- cat /proc/mtrr
>>
>> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
>>  reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
>>  reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
>>  reg03: base=0xcf801000 (3320MB), size=   4KB: write-back, count=1
>>  reg04: base=0xcf802000 (3320MB), size=   8KB: write-back, count=1
>>  reg05: base=0xcf804000 (3320MB), size=  16KB: write-back, count=1
>>  reg06: base=0xcf808000 (3320MB), size=  32KB: write-back, count=1
>>  reg07: base=0xcf810000 (3320MB), size=  64KB: write-back, count=1
>>
>>  --($:~)-- uname -a
>>  Linux thor 2.6.25-05561-g064922a-dirty #797 SMP PREEMPT Mon Apr 28 10:30:06 CEST 2008 x86_64 GNU/Linux
>>
>>  Full dmesg can be found there :
>>
>>
>>  http://frugalware.org/~crazy/mtrr/mtrr_dmesg
> 
> please try v2 version
> 
> http://lkml.org/lkml/2008/4/28/115

Box still won't boot with mtrr_chunk_size=1g but without it is perfect :)) Thx for your work. 
I've quick tested some games and 3d things , all are working with this patch really nice.

Full dmesg :

http://frugalware.org/~crazy/mtrr/mtrr2_dmesg


--($:~)-- cat /proc/mtrr
reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
reg03: base=0xcf800000 (3320MB), size=   8MB: write-back, count=1
reg04: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
reg05: base=0x120000000 (4608MB), size= 256MB: write-back, count=1
reg06: base=0x12c000000 (4800MB), size=  64MB: uncachable, count=1
reg07: base=0xd0000000 (3328MB), size= 256MB: write-combining, count=1


If you wish I can test 32bit too a bit later , just let me know.

> 
> YH
> 


Gabriel
