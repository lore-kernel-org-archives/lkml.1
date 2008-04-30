Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbYD3Aiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbYD3Aiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 20:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbYD3Ail
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 20:38:41 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:33831 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbYD3Aik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 20:38:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=RfmVnTCgDXj28HrzIgGg1SDwSHPhud2HIiHz7B9bf5JtHFQpUigWIZtfM+c6NfOSbyS+NRJ5CUn9d2ZontcUsHPTQCDHmFaeBP/TlUN0rRBJM+QKzb3Bn25eU1lB4qX7M4S3OGXZqfgQOEBMXhaDKDo0qsP4yslifU7zwRxmJ60=
Message-ID: <86802c440804291738p401e339djda18d24bce324795@mail.gmail.com>
Date: Tue, 29 Apr 2008 17:38:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: [PATCH 1/2] x86: mtrr cleanup for converting continuous to discrete layout v7
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mika Fischer" <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4817B811.9070707@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_10758_695771.1209515915843"
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <4816EEA1.6050804@googlemail.com>
	 <86802c440804290330wd582daetb2a9c41a69f6e028@mail.gmail.com>
	 <86802c440804290356l678d3a0cxedcbe21a1f7642d1@mail.gmail.com>
	 <48170BDB.9000801@googlemail.com>
	 <86802c440804291011g1cdd2c81h962f066dd7980282@mail.gmail.com>
	 <48178434.90701@googlemail.com>
	 <86802c440804291449y50f178a6x4e200c26840493a@mail.gmail.com>
	 <4817B5B0.5090606@googlemail.com> <4817B811.9070707@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_10758_695771.1209515915843
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Apr 29, 2008 at 5:06 PM, Gabriel C <nix.or.die@googlemail.com> wrote:
>
> Gabriel C wrote:
>  > Yinghai Lu wrote:
>  >> On Tue, Apr 29, 2008 at 1:25 PM, Gabriel C <nix.or.die@googlemail.com> wrote:
>  >>> Yinghai Lu wrote:
>  >>>  > On Tue, Apr 29, 2008 at 4:51 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
>  >>>  >> Yinghai Lu wrote:
>  >>>  >>  > On Tue, Apr 29, 2008 at 3:30 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>  >>>  >>  >> On Tue, Apr 29, 2008 at 2:47 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
>  >>>  >>  >>  > Yinghai Lu wrote:
>  >>>  >>  >>  >  > some BIOS like to use continus MTRR layout, and may X driver can not add
>  >>>  >>  >>  >  > WB entries for graphical cards when 4g or more RAM installed.
>  >>>  >>  >>  >  >
>  >>>  >>  >>  >  > the patch will change MTRR to discrete.
>  >>>  >>  >>  >  >
>  >>>  >>  >>  >  > mtrr_chunk_size= could be used to have smaller continuous block to hold holes.
>  >>>  >>  >>  >  > default is 256m, could be set according to size of graphics card memory.
>  >>>  >>  >>  >  >
>  >>>  >>  >>  >  > v2: fix -1 for UC checking
>  >>>  >>  >>  >  > v3: default to disable, and need use enable_mtrr_cleanup to enable this feature
>  >>>  >>  >>  >  >     skip the var state change warning.
>  >>>  >>  >>  >  >     remove next_basek in range_to_mtrr()
>  >>>  >>  >>  >  > v4: correct warning mask.
>  >>>  >>  >>  >  > v5: CONFIG_MTRR_SANITIZER
>  >>>  >>  >>  >  > v6: fix 1g, 2g, 512 aligment with extra hole
>  >>>  >>  >>  >  > v7: gran_sizek to prevent running out of MTRRs.
>  >>>  >>  >>  >  >
>  >>>  >>  >>  >
>  >>>  >>  >>  >  With this version ( and patch http://lkml.org/lkml/2008/4/29/97 ) applyed on latest linus git tree
>  >>>  >>  >>  >  the box OOPS'es early.
>  >>>  >>  >>  >
>  >>>  >>  >>  >  Sorry I don't have time right now to write down the part of the OOPS I can see on monitor , I can try to find
>  >>>  >>  >>  >  some time later.
>  >>>  >>  >>  >
>  >>>  >>  >>  >  In any way OOPS'es on __free_one_page+0x191/0x21e
>  >>>  >>  >>
>  >>>  >>  >>  thanks. found one problem with hole_basek ...
>  >>>  >>  >>
>  >>>  >>  >>  will send you v8, and hope it will be last version.
>  >>>  >>  >
>  >>>  >>  > please try v8, it should get rid of the 8m entry. it need patch
>  >>>  >>  > http://lkml.org/lkml/2008/4/29/97 too.
>  >>>  >>
>  >>>  >>  Box does boot with v8 but now I get that warning you fixed in v2 again =):
>  >>>  >>
>  >>>  >>  ....
>  >>>  >>  [    0.000000] Linux version 2.6.25-06058-ga01e035-dirty (crazy@thor) (gcc version 4.3.0 (Frugalware Linux) ) #805 SMP PREEMPT Tue Apr 29 13:04:49 CEST 2008
>  >>>  >>  [    0.000000] Command line: root=/dev/sdb1 ro debug vga=0x317
>  >>>  >>  [    0.000000] BIOS-provided physical RAM map:
>  >>>  >>  [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
>  >>>  >>  [    0.000000]  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
>  >>>  >>  [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
>  >>>  >>  [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf550000 (usable)
>  >>>  >>  [    0.000000]  BIOS-e820: 00000000cf550000 - 00000000cf55e000 (ACPI data)
>  >>>  >>  [    0.000000]  BIOS-e820: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
>  >>>  >>  [    0.000000]  BIOS-e820: 00000000cf5e0000 - 00000000cf600000 (reserved)
>  >>>  >>  [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  >>>  >>  [    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
>  >>>  >>  [    0.000000]  BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
>  >>>  >>  [    0.000000] Entering add_active_range(0, 0, 156) 0 entries of 256 used
>  >>>  >>  [    0.000000] Entering add_active_range(0, 256, 849232) 1 entries of 256 used
>  >>>  >>  [    0.000000] Entering add_active_range(0, 1048576, 1228800) 2 entries of 256 used
>  >>>  >>  [    0.000000] max_pfn_mapped = 1228800
>  >>>  >>  [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>  >>>  >>  [    0.000000] After WB checking
>  >>>  >>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 000000000012c000
>  >>>  >>  [    0.000000] After UC checking
>  >>>  >>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
>  >>>  >>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  >>>  >>  [    0.000000] MTRR MAP PFN: 00000000000cf800 - 00000000000d0000
>  >>>  >>  [    0.000000] After sorting
>  >>>  >>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
>  >>>  >>  [    0.000000] MTRR MAP PFN: 00000000000cf800 - 00000000000d0000
>  >>>  >>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  >>>  >>  [    0.000000] range0: 0000000000000000 - 00000000c0000000
>  >>>  >>  [    0.000000] Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
>  >>>  >>  [    0.000000] Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
>  >>>  >>  [    0.000000] range: 00000000c0000000 - 00000000d0000000
>  >>>  >>  [    0.000000] Setting variable MTRR 2, base: 3072MB, range: 256MB, type WB
>  >>>  >>  [    0.000000] hole: 00000000cc000000 - 00000000d0000000
>  >>>  >>  [    0.000000] Setting variable MTRR 3, base: 3264MB, range: 64MB, type UC
>  >>>  >>  [    0.000000] rangeX: 00000000d0000000 - 00000000d0000000
>  >>>  >>  [    0.000000] range0: 0000000100000000 - 0000000120000000
>  >>>  >>  [    0.000000] Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
>  >>>  >>  [    0.000000] range: 0000000120000000 - 0000000130000000
>  >>>  >>  [    0.000000] Setting variable MTRR 5, base: 4608MB, range: 256MB, type WB
>  >>>  >>  [    0.000000] hole: 000000012c000000 - 0000000130000000
>  >>>  >>  [    0.000000] Setting variable MTRR 6, base: 4800MB, range: 64MB, type UC
>  >>>  >>  [    0.000000] DONE variable MTRRs
>  >>>  >>  [    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
>  >>>  >>  [    0.000000] After WB checking
>  >>>  >>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000d0000
>  >>>  >>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 0000000000130000
>  >>>  >>  [    0.000000] After UC checking
>  >>>  >>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cc000
>  >>>  >>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  >>>  >>  [    0.000000] After sorting
>  >>>  >>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cc000
>  >>>  >>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  >>>  >>  [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 757MB of RAM.
>  >>>  >
>  >>>  > so
>  >>>  >>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
>  >>>  >>  [    0.000000] MTRR MAP PFN: 00000000000cf800 - 00000000000d0000
>  >>>  >>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  >>>  > ===>
>  >>>  >>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cc000
>  >>>  >>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  >>>  >
>  >>>  > please try
>  >>>
>  >>>  Now I have 2 warnings
>  >>>
>  >>>
>  >>>  > mtrr_chunk_size=512m mtrr_gran_size=128m
>  >>>
>  >>>  ...
>  >>>
>  >>>  [    0.000000] Command line: root=/dev/sdb1 ro debug vga=0x317 mtrr_chunk_size=512m mtrr_gran_size=128m 3
>  >>>
>  >>>
>  >>> [    0.000000] BIOS-provided physical RAM map:
>  >>>  [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
>  >>>  [    0.000000]  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
>  >>>  [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
>  >>>  [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf550000 (usable)
>  >>>  [    0.000000]  BIOS-e820: 00000000cf550000 - 00000000cf55e000 (ACPI data)
>  >>>  [    0.000000]  BIOS-e820: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
>  >>>  [    0.000000]  BIOS-e820: 00000000cf5e0000 - 00000000cf600000 (reserved)
>  >>>  [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  >>>  [    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
>  >>>  [    0.000000]  BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
>  >>>  [    0.000000] Entering add_active_range(0, 0, 156) 0 entries of 256 used
>  >>>  [    0.000000] Entering add_active_range(0, 256, 849232) 1 entries of 256 used
>  >>>  [    0.000000] Entering add_active_range(0, 1048576, 1228800) 2 entries of 256 used
>  >>>  [    0.000000] max_pfn_mapped = 1228800
>  >>>  [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>  >>>  [    0.000000] After WB checking
>  >>>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 000000000012c000
>  >>>  [    0.000000] After UC checking
>  >>>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
>  >>>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  >>>  [    0.000000] MTRR MAP PFN: 00000000000cf800 - 00000000000d0000
>  >>>  [    0.000000] After sorting
>  >>>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
>  >>>  [    0.000000] MTRR MAP PFN: 00000000000cf800 - 00000000000d0000
>  >>>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  >>>  [    0.000000] range0: 0000000000000000 - 00000000c0000000
>  >>>  [    0.000000] Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
>  >>>  [    0.000000] Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
>  >>>  [    0.000000] range: 00000000c0000000 - 00000000c8000000
>  >>>  [    0.000000] Setting variable MTRR 2, base: 3072MB, range: 128MB, type WB
>  >>>
>  >>> [    0.000000] rangeX: 00000000d0000000 - 00000000d0000000
>  >>>  [    0.000000] range0: 0000000100000000 - 0000000120000000
>  >>>  [    0.000000] Setting variable MTRR 3, base: 4096MB, range: 512MB, type WB
>  >>>  [    0.000000] range: 0000000120000000 - 0000000128000000
>  >>>  [    0.000000] Setting variable MTRR 4, base: 4608MB, range: 128MB, type WB
>  >>>
>  >>> [    0.000000] DONE variable MTRRs
>  >>>  [    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
>  >>>  [    0.000000] After WB checking
>  >>>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000c8000
>  >>>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 0000000000128000
>  >>>
>  >>> [    0.000000] After UC checking
>  >>>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000c8000
>  >>>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 0000000000128000
>  >>>  [    0.000000] After sorting
>  >>>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000c8000
>  >>>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 0000000000128000
>  >>>  [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 64MB of RAM.
>  >>>  [    0.000000] ------------[ cut here ]------------
>  >>>  [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1206 mtrr_trim_uncached_memory+0x25b/0x35a()
>  >>>
>  >>> [    0.000000] Modules linked in:
>  >>>  [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.25-06058-ga01e035-dirty #805
>  >>>  [    0.000000]
>  >>>  [    0.000000] Call Trace:
>  >>>  [    0.000000]  [<ffffffff8022d661>] warn_on_slowpath+0x51/0x78
>  >>>  [    0.000000]  [<ffffffff8067f0dc>] x86_get_mtrr_mem_range+0x241/0x25c
>  >>>  [    0.000000]  [<ffffffff8067d93e>] update_memory_range+0x95/0xb7
>  >>>  [    0.000000]  [<ffffffff8067fa51>] mtrr_trim_uncached_memory+0x25b/0x35a
>  >>>
>  >>> [    0.000000]  [<ffffffff8067ca43>] setup_arch+0x280/0x4a2
>  >>>  [    0.000000]  [<ffffffff80676aa6>] start_kernel+0x6e/0x308
>  >>>  [    0.000000]  [<ffffffff80676432>] x86_64_start_kernel+0x241/0x24a
>  >>>  [    0.000000]
>  >>>  [    0.000000] ---[ end trace ca143223eefdc828 ]---
>  >>>  [    0.000000] update e820 for mtrr -- end_pfn
>  >>>  [    0.000000] modified physical RAM map:
>  >>>  [    0.000000]  modified: 0000000000000000 - 000000000009cc00 (usable)
>  >>>  [    0.000000]  modified: 000000000009cc00 - 00000000000a0000 (reserved)
>  >>>  [    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
>  >>>  [    0.000000]  modified: 0000000000100000 - 00000000cf550000 (usable)
>  >>>  [    0.000000]  modified: 00000000cf550000 - 00000000cf55e000 (ACPI data)
>  >>>  [    0.000000]  modified: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
>  >>>  [    0.000000]  modified: 00000000cf5e0000 - 00000000cf600000 (reserved)
>  >>>  [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
>  >>>  [    0.000000]  modified: 00000000ffc00000 - 0000000100000000 (reserved)
>  >>>  [    0.000000]  modified: 0000000100000000 - 0000000128000000 (usable)
>  >>>  [    0.000000]  modified: 0000000128000000 - 000000012c000000 (reserved)
>  >>>
>  >>> [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 757MB of RAM.
>  >>>
>  >>> [    0.000000] ------------[ cut here ]------------
>  >>>  [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1227 mtrr_trim_uncached_memory+0x30c/0x35a()
>  >>>  [    0.000000] Modules linked in:
>  >>>  [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.25-06058-ga01e035-dirty #805
>  >>>  [    0.000000]
>  >>>  [    0.000000] Call Trace:
>  >>>  [    0.000000]  [<ffffffff8022d661>] warn_on_slowpath+0x51/0x78
>  >>>  [    0.000000]  [<ffffffff8067f0dc>] x86_get_mtrr_mem_range+0x241/0x25c
>  >>>  [    0.000000]  [<ffffffff8067d93e>] update_memory_range+0x95/0xb7
>  >>>  [    0.000000]  [<ffffffff8067fb02>] mtrr_trim_uncached_memory+0x30c/0x35a
>  >>>  [    0.000000]  [<ffffffff8067ca43>] setup_arch+0x280/0x4a2
>  >>>  [    0.000000]  [<ffffffff80676aa6>] start_kernel+0x6e/0x308
>  >>>  [    0.000000]  [<ffffffff80676432>] x86_64_start_kernel+0x241/0x24a
>  >>>  [    0.000000]
>  >>>  [    0.000000] ---[ end trace ca143223eefdc828 ]---
>  >>>  [    0.000000] update e820 for mtrr -- holes
>  >>>  [    0.000000] modified physical RAM map:
>  >>>  [    0.000000]  modified: 0000000000000000 - 000000000009cc00 (usable)
>  >>>  [    0.000000]  modified: 000000000009cc00 - 00000000000a0000 (reserved)
>  >>>  [    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
>  >>>  [    0.000000]  modified: 0000000000100000 - 00000000c8000000 (usable)
>  >>>  [    0.000000]  modified: 00000000c8000000 - 00000000cf550000 (reserved)
>  >>>  [    0.000000]  modified: 00000000cf550000 - 00000000cf55e000 (ACPI data)
>  >>>  [    0.000000]  modified: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
>  >>>  [    0.000000]  modified: 00000000cf5e0000 - 00000000cf600000 (reserved)
>  >>>  [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
>  >>>  [    0.000000]  modified: 00000000ffc00000 - 000000012c000000 (reserved)
>  >>>
>  >>> [    0.000000] Entering add_active_range(0, 0, 156) 3 entries of 256 used
>  >>>  [    0.000000] Entering add_active_range(0, 256, 819200) 3 entries of 256 used
>  >> please try attached trim_holes_fix.patch..., it will fix the trim hole problem.
>  >
>  > Tested but warning is still there. I try to boot with mtrr_chunk_size / mtrr_gran_size and see what I get.
>  >
>  > ...
>  >
>  > [    0.000000] Linux version 2.6.25-06589-gc65a350-dirty (crazy@thor) (gcc version 4.3.0 (Frugalware Linux) ) #808 SMP PREEMPT Wed Apr 30 01:37:38 CEST 2008
>  > [    0.000000] Command line: root=/dev/sdb1 ro debug vga=0x317
>  > [    0.000000] BIOS-provided physical RAM map:
>  > [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
>  > [    0.000000]  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
>  > [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
>  > [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf550000 (usable)
>  > [    0.000000]  BIOS-e820: 00000000cf550000 - 00000000cf55e000 (ACPI data)
>  > [    0.000000]  BIOS-e820: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
>  > [    0.000000]  BIOS-e820: 00000000cf5e0000 - 00000000cf600000 (reserved)
>  > [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  > [    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
>  > [    0.000000]  BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
>  > [    0.000000] Entering add_active_range(0, 0, 156) 0 entries of 256 used
>  > [    0.000000] Entering add_active_range(0, 256, 849232) 1 entries of 256 used
>  > [    0.000000] Entering add_active_range(0, 1048576, 1228800) 2 entries of 256 used
>  > [    0.000000] max_pfn_mapped = 1228800
>  > [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>  > [    0.000000] After WB checking
>  > [    0.000000] MTRR MAP PFN: 0000000000000000 - 000000000012c000
>  > [    0.000000] After UC checking
>  > [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
>  > [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  > [    0.000000] MTRR MAP PFN: 00000000000cf800 - 00000000000d0000
>  > [    0.000000] After sorting
>  > [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
>  > [    0.000000] MTRR MAP PFN: 00000000000cf800 - 00000000000d0000
>  > [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  > [    0.000000] range0: 0000000000000000 - 00000000c0000000
>  > [    0.000000] Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
>  > [    0.000000] Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
>  > [    0.000000] range: 00000000c0000000 - 00000000d0000000
>  > [    0.000000] Setting variable MTRR 2, base: 3072MB, range: 256MB, type WB
>  > [    0.000000] hole: 00000000cc000000 - 00000000d0000000
>  > [    0.000000] Setting variable MTRR 3, base: 3264MB, range: 64MB, type UC
>  > [    0.000000] rangeX: 00000000d0000000 - 00000000d0000000
>  > [    0.000000] range0: 0000000100000000 - 0000000120000000
>  > [    0.000000] Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
>  > [    0.000000] range: 0000000120000000 - 0000000130000000
>  > [    0.000000] Setting variable MTRR 5, base: 4608MB, range: 256MB, type WB
>  > [    0.000000] hole: 000000012c000000 - 0000000130000000
>  > [    0.000000] Setting variable MTRR 6, base: 4800MB, range: 64MB, type UC
>  > [    0.000000] DONE variable MTRRs
>  > [    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
>  > [    0.000000] After WB checking
>  > [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000d0000
>  > [    0.000000] MTRR MAP PFN: 0000000000100000 - 0000000000130000
>  > [    0.000000] After UC checking
>  > [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cc000
>  > [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  > [    0.000000] After sorting
>  > [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cc000
>  > [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  > [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 757MB of RAM.
>  > [    0.000000] ------------[ cut here ]------------
>  > [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1227 mtrr_trim_uncached_memory+0x313/0x361()
>  > [    0.000000] Modules linked in:
>  > [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.25-06589-gc65a350-dirty #808
>  > [    0.000000]
>  > [    0.000000] Call Trace:
>  > [    0.000000]  [<ffffffff8022d699>] warn_on_slowpath+0x51/0x8c
>  > [    0.000000]  [<ffffffff806810b4>] x86_get_mtrr_mem_range+0x241/0x25c
>  > [    0.000000]  [<ffffffff8067f915>] update_memory_range+0x95/0xb7
>  > [    0.000000]  [<ffffffff80681ae1>] mtrr_trim_uncached_memory+0x313/0x361
>  > [    0.000000]  [<ffffffff8067ea16>] setup_arch+0x280/0x4a6
>  > [    0.000000]  [<ffffffff80678a3d>] start_kernel+0x6e/0x30d
>  > [    0.000000]  [<ffffffff80678432>] x86_64_start_kernel+0x241/0x24a
>  > [    0.000000]
>  > [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
>  > [    0.000000] update e820 for mtrr -- holes
>  > [    0.000000] modified physical RAM map:
>  > [    0.000000]  modified: 0000000000000000 - 000000000009cc00 (usable)
>  > [    0.000000]  modified: 000000000009cc00 - 00000000000a0000 (reserved)
>  > [    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
>  > [    0.000000]  modified: 0000000000100000 - 00000000cc000000 (usable)
>  > [    0.000000]  modified: 00000000cc000000 - 00000000cf550000 (reserved)
>  > [    0.000000]  modified: 00000000cf550000 - 00000000cf55e000 (ACPI data)
>  > [    0.000000]  modified: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
>  > [    0.000000]  modified: 00000000cf5e0000 - 00000000cf600000 (reserved)
>  > [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
>  > [    0.000000]  modified: 00000000ffc00000 - 000000012c000000 (reserved)
>  > [    0.000000] Entering add_active_range(0, 0, 156) 3 entries of 256 used
>  > [    0.000000] Entering add_active_range(0, 256, 835584) 3 entries of 256 used
>  > [    0.000000] max_pfn_mapped = 1228800
>  > [    0.000000] init_memory_mapping
>  >
>  > ...
>  >
>
>  with mtrr_chunk_size=256m mtrr_gran_size=128m I'm getting :
>
>  ...
>
>
>
>  [    0.000000] BIOS-provided physical RAM map:
>  [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
>  [    0.000000]  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
>  [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
>  [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf550000 (usable)
>  [    0.000000]  BIOS-e820: 00000000cf550000 - 00000000cf55e000 (ACPI data)
>  [    0.000000]  BIOS-e820: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
>  [    0.000000]  BIOS-e820: 00000000cf5e0000 - 00000000cf600000 (reserved)
>  [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  [    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
>  [    0.000000]  BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
>  [    0.000000] Entering add_active_range(0, 0, 156) 0 entries of 256 used
>  [    0.000000] Entering add_active_range(0, 256, 849232) 1 entries of 256 used
>  [    0.000000] Entering add_active_range(0, 1048576, 1228800) 2 entries of 256 used
>  [    0.000000] max_pfn_mapped = 1228800
>  [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>  [    0.000000] After WB checking
>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 000000000012c000
>  [    0.000000] After UC checking
>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  [    0.000000] MTRR MAP PFN: 00000000000cf800 - 00000000000d0000
>  [    0.000000] After sorting
>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
>  [    0.000000] MTRR MAP PFN: 00000000000cf800 - 00000000000d0000
>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  [    0.000000] range0: 0000000000000000 - 00000000c0000000
>  [    0.000000] Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
>  [    0.000000] Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
>  [    0.000000] range: 00000000c0000000 - 00000000c8000000
>  [    0.000000] Setting variable MTRR 2, base: 3072MB, range: 128MB, type WB
>  [    0.000000] rangeX: 00000000d0000000 - 00000000d0000000
>  [    0.000000] range0: 0000000100000000 - 0000000120000000
>  [    0.000000] Setting variable MTRR 3, base: 4096MB, range: 512MB, type WB
>  [    0.000000] range: 0000000120000000 - 0000000128000000
>  [    0.000000] Setting variable MTRR 4, base: 4608MB, range: 128MB, type WB
>  [    0.000000] DONE variable MTRRs
>  [    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
>  [    0.000000] After WB checking
>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000c8000
>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 0000000000128000
>  [    0.000000] After UC checking
>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000c8000
>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 0000000000128000
>  [    0.000000] After sorting
>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000c8000
>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 0000000000128000
>  [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 64MB of RAM.
>  [    0.000000] ------------[ cut here ]------------
>  [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1206 mtrr_trim_uncached_memory+0x25b/0x361()
>
> [    0.000000] Modules linked in:
>  [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.25-06589-gc65a350-dirty #808
>  [    0.000000]
>  [    0.000000] Call Trace:
>  [    0.000000]  [<ffffffff8022d699>] warn_on_slowpath+0x51/0x8c
>  [    0.000000]  [<ffffffff806810b4>] x86_get_mtrr_mem_range+0x241/0x25c
>  [    0.000000]  [<ffffffff8067f915>] update_memory_range+0x95/0xb7
>  [    0.000000]  [<ffffffff80681a29>] mtrr_trim_uncached_memory+0x25b/0x361
>
> [    0.000000]  [<ffffffff8067ea16>] setup_arch+0x280/0x4a6
>  [    0.000000]  [<ffffffff80678a3d>] start_kernel+0x6e/0x30d
>  [    0.000000]  [<ffffffff80678432>] x86_64_start_kernel+0x241/0x24a
>  [    0.000000]
>  [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
>
> [    0.000000] update e820 for mtrr -- end_pfn
>  [    0.000000] modified physical RAM map:
>  [    0.000000]  modified: 0000000000000000 - 000000000009cc00 (usable)
>  [    0.000000]  modified: 000000000009cc00 - 00000000000a0000 (reserved)
>  [    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
>  [    0.000000]  modified: 0000000000100000 - 00000000cf550000 (usable)
>  [    0.000000]  modified: 00000000cf550000 - 00000000cf55e000 (ACPI data)
>  [    0.000000]  modified: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
>  [    0.000000]  modified: 00000000cf5e0000 - 00000000cf600000 (reserved)
>  [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
>  [    0.000000]  modified: 00000000ffc00000 - 0000000100000000 (reserved)
>  [    0.000000]  modified: 0000000100000000 - 0000000128000000 (usable)
>  [    0.000000]  modified: 0000000128000000 - 000000012c000000 (reserved)
>  [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 757MB of RAM.
>  [    0.000000] ------------[ cut here ]------------
>
> [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1227 mtrr_trim_uncached_memory+0x313/0x361()
>  [    0.000000] Modules linked in:
>  [    0.000000] Pid: 0, comm: swapper Tainted: G        W 2.6.25-06589-gc65a350-dirty #808
>
> [    0.000000]
>  [    0.000000] Call Trace:
>  [    0.000000]  [<ffffffff8022d699>] warn_on_slowpath+0x51/0x8c
>  [    0.000000]  [<ffffffff806810b4>] x86_get_mtrr_mem_range+0x241/0x25c
>  [    0.000000]  [<ffffffff8067f915>] update_memory_range+0x95/0xb7
>  [    0.000000]  [<ffffffff80681ae1>] mtrr_trim_uncached_memory+0x313/0x361
>  [    0.000000]  [<ffffffff8067ea16>] setup_arch+0x280/0x4a6
>  [    0.000000]  [<ffffffff80678a3d>] start_kernel+0x6e/0x30d
>  [    0.000000]  [<ffffffff80678432>] x86_64_start_kernel+0x241/0x24a
>  [    0.000000]
>  [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
>  [    0.000000] update e820 for mtrr -- holes
>  [    0.000000] modified physical RAM map:
>  [    0.000000]  modified: 0000000000000000 - 000000000009cc00 (usable)
>  [    0.000000]  modified: 000000000009cc00 - 00000000000a0000 (reserved)
>  [    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
>
> [    0.000000]  modified: 0000000000100000 - 00000000c8000000 (usable)
>  [    0.000000]  modified: 00000000c8000000 - 00000000cf550000 (reserved)
>  [    0.000000]  modified: 00000000cf550000 - 00000000cf55e000 (ACPI data)
>  [    0.000000]  modified: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
>  [    0.000000]  modified: 00000000cf5e0000 - 00000000cf600000 (reserved)
>  [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
>  [    0.000000]  modified: 00000000ffc00000 - 000000012c000000 (reserved)
>  [    0.000000] Entering add_active_range(0, 0, 156) 3 entries of 256 used
>  [    0.000000] Entering add_active_range(0, 256, 819200) 3 entries of 256 used
>
please check attached debug patch...

THanks

Yinghai Lu

------=_Part_10758_695771.1209515915843
Content-Type: text/x-patch; name=trim_holes_fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ffn6i9up0
Content-Disposition: attachment; filename=trim_holes_fix.patch

SW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvY3B1L210cnIvbWFpbi5jCj09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2tlcm5lbC9jcHUvbXRyci9tYWluLmMKKysr
IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvY3B1L210cnIvbWFpbi5jCkBAIC0xMTAzLDYgKzEx
MDMsOSBAQCBzdGF0aWMgdTY0IF9faW5pdCByZWFsX3RyaW1fbWVtb3J5KHVuc2lnCiAJdHJpbV9z
aXplID0gbGltaXRfcGZuOwogCXRyaW1fc2l6ZSA8PD0gUEFHRV9TSElGVDsKIAl0cmltX3NpemUg
LT0gdHJpbV9zdGFydDsKKworCXByaW50ayhLRVJOX0lORk8gInRyaW1tIGU4MjAgZm9yIE1UUlIg
TUFQIChVQyk6ICUwMTZseCAtICUwMTZseFxuIiwgc3RhcnRfcGZuLCBsaW1pdF9wZm4pOworCiAJ
cmV0dXJuIHVwZGF0ZV9tZW1vcnlfcmFuZ2UodHJpbV9zdGFydCwgdHJpbV9zaXplLCBFODIwX1JB
TSwKIAkJCQlFODIwX1JFU0VSVkVEKTsKIH0KQEAgLTEyMDMsNyArMTIwNiw4IEBAIGludCBfX2lu
aXQgbXRycl90cmltX3VuY2FjaGVkX21lbW9yeSh1bnMKIAkJCSIgYWxsIG9mIG1lbW9yeSwgbG9z
aW5nICVsbHVNQiBvZiBSQU0uXG4iLAogCQkJdG90YWxfcmVhbF90cmltX3NpemUgPj4gMjApOwog
Ci0JCVdBUk5fT04oMSk7CisJCWlmIChlbmFibGVfbXRycl9jbGVhbnVwIDwgMSkKKwkJCVdBUk5f
T04oMSk7CiAKIAkJcHJpbnRrKEtFUk5fSU5GTyAidXBkYXRlIGU4MjAgZm9yIG10cnIgLS0gZW5k
X3BmblxuIik7CiAJCXVwZGF0ZV9lODIwKCk7CkBAIC0xMjE0LDcgKzEyMTgsNyBAQCBpbnQgX19p
bml0IG10cnJfdHJpbV91bmNhY2hlZF9tZW1vcnkodW5zCiAJaWYgKHJhbmdlWzBdLnN0YXJ0KQog
CQl0b3RhbF9yZWFsX3RyaW1fc2l6ZSArPSByZWFsX3RyaW1fbWVtb3J5KDAsIHJhbmdlWzBdLnN0
YXJ0KTsKIAotCWZvciAoaSA9IDA7IGkgPCBucl9yYW5nZSAtIDE7IGktLSkgeworCWZvciAoaSA9
IDA7IGkgPCBucl9yYW5nZSAtIDE7IGkrKykgewogCQlpZiAocmFuZ2VbaV0uZW5kICsgMSA8IHJh
bmdlW2krMV0uc3RhcnQpCiAJCQl0b3RhbF9yZWFsX3RyaW1fc2l6ZSArPSByZWFsX3RyaW1fbWVt
b3J5KHJhbmdlW2ldLmVuZCArIDEsIHJhbmdlW2krMV0uc3RhcnQpOwogCX0KQEAgLTEyMjQsNyAr
MTIyOCw4IEBAIGludCBfX2luaXQgbXRycl90cmltX3VuY2FjaGVkX21lbW9yeSh1bnMKIAkJCSIg
YWxsIG9mIG1lbW9yeSwgbG9zaW5nICVsbHVNQiBvZiBSQU0uXG4iLAogCQkJdG90YWxfcmVhbF90
cmltX3NpemUgPj4gMjApOwogCi0JCVdBUk5fT04oMSk7CisJCWlmIChlbmFibGVfbXRycl9jbGVh
bnVwIDwgMSkKKwkJCVdBUk5fT04oMSk7CiAKIAkJcHJpbnRrKEtFUk5fSU5GTyAidXBkYXRlIGU4
MjAgZm9yIG10cnIgLS0gaG9sZXNcbiIpOwogCQl1cGRhdGVfZTgyMCgpOwo=
------=_Part_10758_695771.1209515915843--
