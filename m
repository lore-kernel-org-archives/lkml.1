Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbYD2Vtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbYD2Vtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYD2VtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:49:24 -0400
Received: from po-out-1718.google.com ([72.14.252.156]:16165 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbYD2VtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:49:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=dGCrKDfo7saxKNjkqPzaTcvsmC3ju2ELSvdGHKrHFAZ5hsGNXymcaUiU4tjdtUUiMHLPacDxUvzlfo9VziY/RvGNXm7zeBTEPxPp3i3NBdLeiAaSOkXd8zBrtOGSngIByj/1Y5KRrb4igyPH5RtfK6+V7U64bsKOy+hwkc94r0I=
Message-ID: <86802c440804291449y50f178a6x4e200c26840493a@mail.gmail.com>
Date: Tue, 29 Apr 2008 14:49:22 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: [PATCH 1/2] x86: mtrr cleanup for converting continuous to discrete layout v7
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mika Fischer" <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <48178434.90701@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_10357_13726424.1209505762320"
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <200804281316.14168.yhlu.kernel@gmail.com>
	 <200804281505.05764.yhlu.kernel@gmail.com>
	 <200804290200.33459.yhlu.kernel@gmail.com>
	 <4816EEA1.6050804@googlemail.com>
	 <86802c440804290330wd582daetb2a9c41a69f6e028@mail.gmail.com>
	 <86802c440804290356l678d3a0cxedcbe21a1f7642d1@mail.gmail.com>
	 <48170BDB.9000801@googlemail.com>
	 <86802c440804291011g1cdd2c81h962f066dd7980282@mail.gmail.com>
	 <48178434.90701@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_10357_13726424.1209505762320
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Apr 29, 2008 at 1:25 PM, Gabriel C <nix.or.die@googlemail.com> wrote:
>
> Yinghai Lu wrote:
>  > On Tue, Apr 29, 2008 at 4:51 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
>  >> Yinghai Lu wrote:
>  >>  > On Tue, Apr 29, 2008 at 3:30 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>  >>  >> On Tue, Apr 29, 2008 at 2:47 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
>  >>  >>  > Yinghai Lu wrote:
>  >>  >>  >  > some BIOS like to use continus MTRR layout, and may X driver can not add
>  >>  >>  >  > WB entries for graphical cards when 4g or more RAM installed.
>  >>  >>  >  >
>  >>  >>  >  > the patch will change MTRR to discrete.
>  >>  >>  >  >
>  >>  >>  >  > mtrr_chunk_size= could be used to have smaller continuous block to hold holes.
>  >>  >>  >  > default is 256m, could be set according to size of graphics card memory.
>  >>  >>  >  >
>  >>  >>  >  > v2: fix -1 for UC checking
>  >>  >>  >  > v3: default to disable, and need use enable_mtrr_cleanup to enable this feature
>  >>  >>  >  >     skip the var state change warning.
>  >>  >>  >  >     remove next_basek in range_to_mtrr()
>  >>  >>  >  > v4: correct warning mask.
>  >>  >>  >  > v5: CONFIG_MTRR_SANITIZER
>  >>  >>  >  > v6: fix 1g, 2g, 512 aligment with extra hole
>  >>  >>  >  > v7: gran_sizek to prevent running out of MTRRs.
>  >>  >>  >  >
>  >>  >>  >
>  >>  >>  >  With this version ( and patch http://lkml.org/lkml/2008/4/29/97 ) applyed on latest linus git tree
>  >>  >>  >  the box OOPS'es early.
>  >>  >>  >
>  >>  >>  >  Sorry I don't have time right now to write down the part of the OOPS I can see on monitor , I can try to find
>  >>  >>  >  some time later.
>  >>  >>  >
>  >>  >>  >  In any way OOPS'es on __free_one_page+0x191/0x21e
>  >>  >>
>  >>  >>  thanks. found one problem with hole_basek ...
>  >>  >>
>  >>  >>  will send you v8, and hope it will be last version.
>  >>  >
>  >>  > please try v8, it should get rid of the 8m entry. it need patch
>  >>  > http://lkml.org/lkml/2008/4/29/97 too.
>  >>
>  >>  Box does boot with v8 but now I get that warning you fixed in v2 again =):
>  >>
>  >>  ....
>  >>  [    0.000000] Linux version 2.6.25-06058-ga01e035-dirty (crazy@thor) (gcc version 4.3.0 (Frugalware Linux) ) #805 SMP PREEMPT Tue Apr 29 13:04:49 CEST 2008
>  >>  [    0.000000] Command line: root=/dev/sdb1 ro debug vga=0x317
>  >>  [    0.000000] BIOS-provided physical RAM map:
>  >>  [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
>  >>  [    0.000000]  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
>  >>  [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
>  >>  [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf550000 (usable)
>  >>  [    0.000000]  BIOS-e820: 00000000cf550000 - 00000000cf55e000 (ACPI data)
>  >>  [    0.000000]  BIOS-e820: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
>  >>  [    0.000000]  BIOS-e820: 00000000cf5e0000 - 00000000cf600000 (reserved)
>  >>  [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  >>  [    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
>  >>  [    0.000000]  BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
>  >>  [    0.000000] Entering add_active_range(0, 0, 156) 0 entries of 256 used
>  >>  [    0.000000] Entering add_active_range(0, 256, 849232) 1 entries of 256 used
>  >>  [    0.000000] Entering add_active_range(0, 1048576, 1228800) 2 entries of 256 used
>  >>  [    0.000000] max_pfn_mapped = 1228800
>  >>  [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>  >>  [    0.000000] After WB checking
>  >>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 000000000012c000
>  >>  [    0.000000] After UC checking
>  >>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
>  >>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  >>  [    0.000000] MTRR MAP PFN: 00000000000cf800 - 00000000000d0000
>  >>  [    0.000000] After sorting
>  >>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
>  >>  [    0.000000] MTRR MAP PFN: 00000000000cf800 - 00000000000d0000
>  >>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  >>  [    0.000000] range0: 0000000000000000 - 00000000c0000000
>  >>  [    0.000000] Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
>  >>  [    0.000000] Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
>  >>  [    0.000000] range: 00000000c0000000 - 00000000d0000000
>  >>  [    0.000000] Setting variable MTRR 2, base: 3072MB, range: 256MB, type WB
>  >>  [    0.000000] hole: 00000000cc000000 - 00000000d0000000
>  >>  [    0.000000] Setting variable MTRR 3, base: 3264MB, range: 64MB, type UC
>  >>  [    0.000000] rangeX: 00000000d0000000 - 00000000d0000000
>  >>  [    0.000000] range0: 0000000100000000 - 0000000120000000
>  >>  [    0.000000] Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
>  >>  [    0.000000] range: 0000000120000000 - 0000000130000000
>  >>  [    0.000000] Setting variable MTRR 5, base: 4608MB, range: 256MB, type WB
>  >>  [    0.000000] hole: 000000012c000000 - 0000000130000000
>  >>  [    0.000000] Setting variable MTRR 6, base: 4800MB, range: 64MB, type UC
>  >>  [    0.000000] DONE variable MTRRs
>  >>  [    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
>  >>  [    0.000000] After WB checking
>  >>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000d0000
>  >>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 0000000000130000
>  >>  [    0.000000] After UC checking
>  >>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cc000
>  >>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  >>  [    0.000000] After sorting
>  >>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cc000
>  >>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  >>  [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 757MB of RAM.
>  >
>  > so
>  >>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cf600
>  >>  [    0.000000] MTRR MAP PFN: 00000000000cf800 - 00000000000d0000
>  >>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  > ===>
>  >>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000cc000
>  >>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 000000000012c000
>  >
>  > please try
>
>  Now I have 2 warnings
>
>
>  > mtrr_chunk_size=512m mtrr_gran_size=128m
>
>  ...
>
>  [    0.000000] Command line: root=/dev/sdb1 ro debug vga=0x317 mtrr_chunk_size=512m mtrr_gran_size=128m 3
>
>
> [    0.000000] BIOS-provided physical RAM map:
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
>
> [    0.000000] rangeX: 00000000d0000000 - 00000000d0000000
>  [    0.000000] range0: 0000000100000000 - 0000000120000000
>  [    0.000000] Setting variable MTRR 3, base: 4096MB, range: 512MB, type WB
>  [    0.000000] range: 0000000120000000 - 0000000128000000
>  [    0.000000] Setting variable MTRR 4, base: 4608MB, range: 128MB, type WB
>
> [    0.000000] DONE variable MTRRs
>  [    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
>  [    0.000000] After WB checking
>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000c8000
>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 0000000000128000
>
> [    0.000000] After UC checking
>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000c8000
>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 0000000000128000
>  [    0.000000] After sorting
>  [    0.000000] MTRR MAP PFN: 0000000000000000 - 00000000000c8000
>  [    0.000000] MTRR MAP PFN: 0000000000100000 - 0000000000128000
>  [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 64MB of RAM.
>  [    0.000000] ------------[ cut here ]------------
>  [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1206 mtrr_trim_uncached_memory+0x25b/0x35a()
>
> [    0.000000] Modules linked in:
>  [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.25-06058-ga01e035-dirty #805
>  [    0.000000]
>  [    0.000000] Call Trace:
>  [    0.000000]  [<ffffffff8022d661>] warn_on_slowpath+0x51/0x78
>  [    0.000000]  [<ffffffff8067f0dc>] x86_get_mtrr_mem_range+0x241/0x25c
>  [    0.000000]  [<ffffffff8067d93e>] update_memory_range+0x95/0xb7
>  [    0.000000]  [<ffffffff8067fa51>] mtrr_trim_uncached_memory+0x25b/0x35a
>
> [    0.000000]  [<ffffffff8067ca43>] setup_arch+0x280/0x4a2
>  [    0.000000]  [<ffffffff80676aa6>] start_kernel+0x6e/0x308
>  [    0.000000]  [<ffffffff80676432>] x86_64_start_kernel+0x241/0x24a
>  [    0.000000]
>  [    0.000000] ---[ end trace ca143223eefdc828 ]---
>  [    0.000000] update e820 for mtrr -- end_pfn
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
>
> [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 757MB of RAM.
>
> [    0.000000] ------------[ cut here ]------------
>  [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1227 mtrr_trim_uncached_memory+0x30c/0x35a()
>  [    0.000000] Modules linked in:
>  [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.25-06058-ga01e035-dirty #805
>  [    0.000000]
>  [    0.000000] Call Trace:
>  [    0.000000]  [<ffffffff8022d661>] warn_on_slowpath+0x51/0x78
>  [    0.000000]  [<ffffffff8067f0dc>] x86_get_mtrr_mem_range+0x241/0x25c
>  [    0.000000]  [<ffffffff8067d93e>] update_memory_range+0x95/0xb7
>  [    0.000000]  [<ffffffff8067fb02>] mtrr_trim_uncached_memory+0x30c/0x35a
>  [    0.000000]  [<ffffffff8067ca43>] setup_arch+0x280/0x4a2
>  [    0.000000]  [<ffffffff80676aa6>] start_kernel+0x6e/0x308
>  [    0.000000]  [<ffffffff80676432>] x86_64_start_kernel+0x241/0x24a
>  [    0.000000]
>  [    0.000000] ---[ end trace ca143223eefdc828 ]---
>  [    0.000000] update e820 for mtrr -- holes
>  [    0.000000] modified physical RAM map:
>  [    0.000000]  modified: 0000000000000000 - 000000000009cc00 (usable)
>  [    0.000000]  modified: 000000000009cc00 - 00000000000a0000 (reserved)
>  [    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
>  [    0.000000]  modified: 0000000000100000 - 00000000c8000000 (usable)
>  [    0.000000]  modified: 00000000c8000000 - 00000000cf550000 (reserved)
>  [    0.000000]  modified: 00000000cf550000 - 00000000cf55e000 (ACPI data)
>  [    0.000000]  modified: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
>  [    0.000000]  modified: 00000000cf5e0000 - 00000000cf600000 (reserved)
>  [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
>  [    0.000000]  modified: 00000000ffc00000 - 000000012c000000 (reserved)
>
> [    0.000000] Entering add_active_range(0, 0, 156) 3 entries of 256 used
>  [    0.000000] Entering add_active_range(0, 256, 819200) 3 entries of 256 used

please try attached trim_holes_fix.patch..., it will fix the trim hole problem.

then check if X server works well.

then try mtrr_cleanup_fix.patch for... ==> address ingo request about style etc.

Thanks

Yinghai Lu

------=_Part_10357_13726424.1209505762320
Content-Type: text/x-patch; name=trim_holes_fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ffn0dfl20
Content-Disposition: attachment; filename=trim_holes_fix.patch

SW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvY3B1L210cnIvbWFpbi5jCj09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2tlcm5lbC9jcHUvbXRyci9tYWluLmMKKysr
IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvY3B1L210cnIvbWFpbi5jCkBAIC0xMjE0LDcgKzEy
MzAsNyBAQCBpbnQgX19pbml0IG10cnJfdHJpbV91bmNhY2hlZF9tZW1vcnkodW5zCiAJaWYgKHJh
bmdlWzBdLnN0YXJ0KQogCQl0b3RhbF9yZWFsX3RyaW1fc2l6ZSArPSByZWFsX3RyaW1fbWVtb3J5
KDAsIHJhbmdlWzBdLnN0YXJ0KTsKIAotCWZvciAoaSA9IDA7IGkgPCBucl9yYW5nZSAtIDE7IGkt
LSkgeworCWZvciAoaSA9IDA7IGkgPCBucl9yYW5nZSAtIDE7IGkrKykgewogCQlpZiAocmFuZ2Vb
aV0uZW5kICsgMSA8IHJhbmdlW2krMV0uc3RhcnQpCiAJCQl0b3RhbF9yZWFsX3RyaW1fc2l6ZSAr
PSByZWFsX3RyaW1fbWVtb3J5KHJhbmdlW2ldLmVuZCArIDEsIHJhbmdlW2krMV0uc3RhcnQpOwog
CX0K
------=_Part_10357_13726424.1209505762320
Content-Type: text/x-patch; name=mtrr_cleanup_fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ffn0ehxh1
Content-Disposition: attachment; filename=mtrr_cleanup_fix.patch

SW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9LY29uZmlnCj09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIu
Ni5vcmlnL2FyY2gveDg2L0tjb25maWcKKysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9LY29uZmlnCkBA
IC0xMDkyLDEzICsxMDkyLDEyIEBAIGNvbmZpZyBNVFJSX1NBTklUSVpFUgogCSAgSWYgdW5zdXJl
LCBzYXkgWS4KIAogY29uZmlnIE1UUlJfU0FOSVRJWkVSX0VOQUJMRV9ERUZBVUxUCi0JZGVmX2Jv
b2wgeQotCXByb21wdCAiRW5hYmxlIE1UUlIgY2xlYW51cCBieSBkZWZhdWx0IgorCWludCAiTVRS
UiBjbGVhbnVwIGVuYWJsZSB2YWx1ZSAoMC0xKSIKKwlyYW5nZSAwIDEKKwlkZWZhdWx0ICIxIgog
CWRlcGVuZHMgb24gTVRSUl9TQU5JVElaRVIKIAloZWxwCi0JICBFbmFibGUgbXRyciBjbGVhbnVw
IGJ5IGRlZmF1bHQKLQotCSAgSWYgdW5zdXJlLCBzYXkgWS4KKwkgIEVuYWJsZSBtdHJyIGNsZWFu
dXAgZGVmYXVsdCB2YWx1ZQogCiBjb25maWcgWDg2X1BBVAogCWJvb2wKSW5kZXg6IGxpbnV4LTIu
Ni9hcmNoL3g4Ni9rZXJuZWwvY3B1L210cnIvbWFpbi5jCj09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIu
Ni5vcmlnL2FyY2gveDg2L2tlcm5lbC9jcHUvbXRyci9tYWluLmMKKysrIGxpbnV4LTIuNi9hcmNo
L3g4Ni9rZXJuZWwvY3B1L210cnIvbWFpbi5jCkBAIC02MTEsMTcgKzYxMSw5IEBAIHN0YXRpYyBz
dHJ1Y3Qgc3lzZGV2X2RyaXZlciBtdHJyX3N5c2Rldl8KIH07CiAKICNpZmRlZiBDT05GSUdfTVRS
Ul9TQU5JVElaRVIKLQotI2lmZGVmIENPTkZJR19NVFJSX1NBTklUSVpFUl9FTkFCTEVfREVGQVVM
VAotc3RhdGljIGludCBlbmFibGVfbXRycl9jbGVhbnVwIF9faW5pdGRhdGEgPSAxOwotI2Vsc2UK
LXN0YXRpYyBpbnQgZW5hYmxlX210cnJfY2xlYW51cCBfX2luaXRkYXRhOwotI2VuZGlmCi0KK3N0
YXRpYyBpbnQgZW5hYmxlX210cnJfY2xlYW51cCBfX2luaXRkYXRhID0gQ09ORklHX01UUlJfU0FO
SVRJWkVSX0VOQUJMRV9ERUZBVUxUOwogI2Vsc2UKLQogc3RhdGljIGludCBlbmFibGVfbXRycl9j
bGVhbnVwIF9faW5pdGRhdGEgPSAtMTsKLQogI2VuZGlmCiAKIHN0YXRpYyBpbnQgX19pbml0IGRp
c2FibGVfbXRycl9jbGVhbnVwX3NldHVwKGNoYXIgKnN0cikKQEAgLTY0MCw2ICs2MzIsNyBAQCBz
dGF0aWMgaW50IF9faW5pdCBlbmFibGVfbXRycl9jbGVhbnVwX3NlCiB9CiBlYXJseV9wYXJhbSgi
ZW5ibGVfbXRycl9jbGVhbnVwIiwgZW5hYmxlX210cnJfY2xlYW51cF9zZXR1cCk7CiAKKy8qIHNo
b3VsZCBiZSByZWxhdGVkIHRvIE1UUlJfVkFSX1JBTkdFUyBudW1zICovCiAjZGVmaW5lIFJBTkdF
X05VTSAyNTYKIAogc3RydWN0IHJlc19yYW5nZSB7CkBAIC02NDcsMTMgKzY0MCwyNyBAQCBzdHJ1
Y3QgcmVzX3JhbmdlIHsKIAl1bnNpZ25lZCBsb25nIGVuZDsKIH07CiAKLXN0YXRpYyBpbnQgX19p
bml0IGFkZF9yYW5nZShzdHJ1Y3QgcmVzX3JhbmdlICpyYW5nZSwgaW50IG5yX3JhbmdlLCB1bnNp
Z25lZCBsb25nIHN0YXJ0LAotCQkJICAgICAgdW5zaWduZWQgbG9uZyBlbmQsIGludCBtZXJnZSkK
K3N0YXRpYyBpbnQgX19pbml0CithZGRfcmFuZ2Uoc3RydWN0IHJlc19yYW5nZSAqcmFuZ2UsIGlu
dCBucl9yYW5nZSwgdW5zaWduZWQgbG9uZyBzdGFydCwKKwkJCSAgICAgIHVuc2lnbmVkIGxvbmcg
ZW5kKQogewotCWludCBpOworCS8qIG91dCBvZiBzbG90cyAqLworCWlmIChucl9yYW5nZSA+PSBS
QU5HRV9OVU0pCisJCXJldHVybiBucl9yYW5nZTsKIAotCWlmICghbWVyZ2UpCi0JCWdvdG8gYWRk
aXQ7CisJcmFuZ2VbbnJfcmFuZ2VdLnN0YXJ0ID0gc3RhcnQ7CisJcmFuZ2VbbnJfcmFuZ2VdLmVu
ZCA9IGVuZDsKKworCW5yX3JhbmdlKys7CisKKwlyZXR1cm4gbnJfcmFuZ2U7Cit9CisKK3N0YXRp
YyBpbnQgX19pbml0CithZGRfcmFuZ2Vfd2l0aF9tZXJnZShzdHJ1Y3QgcmVzX3JhbmdlICpyYW5n
ZSwgaW50IG5yX3JhbmdlLCB1bnNpZ25lZCBsb25nIHN0YXJ0LAorCQkJICAgICAgdW5zaWduZWQg
bG9uZyBlbmQpCit7CisJaW50IGk7CiAKIAkvKiB0cnkgdG8gbWVyZ2UgaXQgd2l0aCBvbGQgb25l
ICovCiAJZm9yIChpID0gMDsgaSA8IG5yX3JhbmdlOyBpKyspIHsKQEAgLTY3NiwyNCArNjgzLDE0
IEBAIHN0YXRpYyBpbnQgX19pbml0IGFkZF9yYW5nZShzdHJ1Y3QgcmVzX3IKIAkJcmV0dXJuIG5y
X3JhbmdlOwogCX0KIAotYWRkaXQ6CiAJLyogbmVlZCB0byBhZGQgdGhhdCAqLwotCWlmIChucl9y
YW5nZSA+PSBSQU5HRV9OVU0pCi0JCXJldHVybiBucl9yYW5nZTsKLQotCXJhbmdlW25yX3Jhbmdl
XS5zdGFydCA9IHN0YXJ0OwotCXJhbmdlW25yX3JhbmdlXS5lbmQgPSBlbmQ7Ci0KLQlucl9yYW5n
ZSsrOwotCi0JcmV0dXJuIG5yX3JhbmdlOwotCisJcmV0dXJuIGFkZF9yYW5nZShyYW5nZSwgbnJf
cmFuZ2UsIHN0YXJ0LCBlbmQpOwogfQotc3RhdGljIHZvaWQgX19pbml0IHN1YnRyYWN0X3Jhbmdl
KHN0cnVjdCByZXNfcmFuZ2UgKnJhbmdlLCB1bnNpZ25lZCBsb25nIHN0YXJ0LAotCQkJCXVuc2ln
bmVkIGxvbmcgZW5kKQorCitzdGF0aWMgdm9pZCBfX2luaXQKK3N1YnRyYWN0X3JhbmdlKHN0cnVj
dCByZXNfcmFuZ2UgKnJhbmdlLCB1bnNpZ25lZCBsb25nIHN0YXJ0LCB1bnNpZ25lZCBsb25nIGVu
ZCkKIHsKLQlpbnQgaTsKLQlpbnQgajsKKwlpbnQgaSwgajsKIAogCWZvciAoaiA9IDA7IGogPCBS
QU5HRV9OVU07IGorKykgewogCQlpZiAoIXJhbmdlW2pdLmVuZCkKQEAgLTc0Nyw0NiArNzQ0LDQ3
IEBAIHN0YXRpYyBpbnQgX19pbml0IGNtcF9yYW5nZShjb25zdCB2b2lkICoKIH0KIAogc3RydWN0
IHZhcl9tdHJyX3N0YXRlIHsKLQl1bnNpZ25lZCBsb25nIHJhbmdlX3N0YXJ0aywgcmFuZ2Vfc2l6
ZWs7Ci0JdW5zaWduZWQgbG9uZyBjaHVua19zaXplazsKLQl1bnNpZ25lZCBsb25nIGdyYW5fc2l6
ZWs7Ci0JdW5zaWduZWQgaW50IHJlZzsKLQl1bnNpZ25lZCBhZGRyZXNzX2JpdHM7CisJdW5zaWdu
ZWQgbG9uZwlyYW5nZV9zdGFydGs7CisJdW5zaWduZWQgbG9uZwlyYW5nZV9zaXplazsKKwl1bnNp
Z25lZCBsb25nCWNodW5rX3NpemVrOworCXVuc2lnbmVkIGxvbmcJZ3Jhbl9zaXplazsKKwl1bnNp
Z25lZCBpbnQJcmVnOworCXVuc2lnbmVkIGludAlhZGRyZXNzX2JpdHM7CiB9OwogCi1zdGF0aWMg
dm9pZCBfX2luaXQgc2V0X3Zhcl9tdHJyKAotCXVuc2lnbmVkIGludCByZWcsIHVuc2lnbmVkIGxv
bmcgYmFzZWssIHVuc2lnbmVkIGxvbmcgc2l6ZWssCi0JdW5zaWduZWQgY2hhciB0eXBlLCB1bnNp
Z25lZCBhZGRyZXNzX2JpdHMpCitzdGF0aWMgdm9pZCBfX2luaXQKK3NldF92YXJfbXRycih1bnNp
Z25lZCBpbnQgcmVnLCB1bnNpZ25lZCBsb25nIGJhc2VrLCB1bnNpZ25lZCBsb25nIHNpemVrLAor
CQl1bnNpZ25lZCBjaGFyIHR5cGUsIHVuc2lnbmVkIGFkZHJlc3NfYml0cykKIHsKIAl1MzIgYmFz
ZV9sbywgYmFzZV9oaSwgbWFza19sbywgbWFza19oaTsKLQl1bnNpZ25lZCBhZGRyZXNzX21hc2tf
aGlnaDsKKwl1NjQgYmFzZSwgbWFzazsKIAogCWlmICghc2l6ZWspIHsKIAkJZmlsbF9tdHJyX3Zh
cl9yYW5nZShyZWcsIDAsIDAsIDAsIDApOwogCQlyZXR1cm47CiAJfQogCi0JYWRkcmVzc19tYXNr
X2hpZ2ggPSAoKDF1IDw8IChhZGRyZXNzX2JpdHMgLSAzMnUpKSAtIDF1KTsKKwltYXNrID0gKDFV
TEwgPDwgYWRkcmVzc19iaXRzKSAtIDE7CisJbWFzayAmPSB+KCgoKHU2NClzaXplaykgPDwgMTAp
IC0gMSk7CiAKLQliYXNlX2hpID0gYmFzZWsgPj4gMjI7Ci0JYmFzZV9sbyAgPSBiYXNlayA8PCAx
MDsKKwliYXNlICA9ICgodTY0KWJhc2VrKSA8PCAxMDsKIAotCWlmIChzaXplayA8IDQqMTAyNCox
MDI0KSB7Ci0JCW1hc2tfaGkgPSBhZGRyZXNzX21hc2tfaGlnaDsKLQkJbWFza19sbyA9IH4oKHNp
emVrIDw8IDEwKSAtIDEpOwotCX0gZWxzZSB7Ci0JCW1hc2tfaGkgPSBhZGRyZXNzX21hc2tfaGln
aCAmICh+KChzaXplayA+PiAyMikgLSAxKSk7Ci0JCW1hc2tfbG8gPSAwOwotCX0KKwliYXNlIHw9
IHR5cGU7CisJbWFzayB8PSAweDgwMDsKKworCWJhc2VfbG8gPSBiYXNlICYgKCgxVUxMPDwzMikg
LSAxKTsKKwliYXNlX2hpID0gYmFzZSA+PiAzMjsKKworCW1hc2tfbG8gPSBtYXNrICYgKCgxVUxM
PDwzMikgLSAxKTsKKwltYXNrX2hpID0gbWFzayA+PiAzMjsKIAotCWJhc2VfbG8gfD0gdHlwZTsK
LQltYXNrX2xvIHw9IDB4ODAwOwogCWZpbGxfbXRycl92YXJfcmFuZ2UocmVnLCBiYXNlX2xvLCBi
YXNlX2hpLCBtYXNrX2xvLCBtYXNrX2hpKTsKIH0KIAotc3RhdGljIHVuc2lnbmVkIGludCBfX2lu
aXQgcmFuZ2VfdG9fbXRycih1bnNpZ25lZCBpbnQgcmVnLAotCXVuc2lnbmVkIGxvbmcgcmFuZ2Vf
c3RhcnRrLCB1bnNpZ25lZCBsb25nIHJhbmdlX3NpemVrLAotCXVuc2lnbmVkIGNoYXIgdHlwZSwg
dW5zaWduZWQgYWRkcmVzc19iaXRzKQorc3RhdGljIHVuc2lnbmVkIGludCBfX2luaXQKK3Jhbmdl
X3RvX210cnIodW5zaWduZWQgaW50IHJlZywgdW5zaWduZWQgbG9uZyByYW5nZV9zdGFydGssCisJ
ICAgICAgdW5zaWduZWQgbG9uZyByYW5nZV9zaXplaywgdW5zaWduZWQgY2hhciB0eXBlLAorCSAg
ICAgIHVuc2lnbmVkIGFkZHJlc3NfYml0cykKIHsKIAlpZiAoIXJhbmdlX3NpemVrIHx8IChyZWcg
Pj0gbnVtX3Zhcl9yYW5nZXMpKQogCQlyZXR1cm4gcmVnOwpAQCAtNzk0LDYgKzc5Miw3IEBAIHN0
YXRpYyB1bnNpZ25lZCBpbnQgX19pbml0IHJhbmdlX3RvX210cnIKIAl3aGlsZSAocmFuZ2Vfc2l6
ZWspIHsKIAkJdW5zaWduZWQgbG9uZyBtYXhfYWxpZ24sIGFsaWduOwogCQl1bnNpZ25lZCBsb25n
IHNpemVrOworCiAJCS8qIENvbXB1dGUgdGhlIG1heGltdW0gc2l6ZSBJIGNhbiBtYWtlIGEgcmFu
Z2UgKi8KIAkJaWYgKHJhbmdlX3N0YXJ0aykKIAkJCW1heF9hbGlnbiA9IGZmcyhyYW5nZV9zdGFy
dGspIC0gMTsKQEAgLTgxOCw3ICs4MTcsOCBAQCBzdGF0aWMgdW5zaWduZWQgaW50IF9faW5pdCBy
YW5nZV90b19tdHJyCiAJcmV0dXJuIHJlZzsKIH0KIAotc3RhdGljIHZvaWQgX19pbml0IHJhbmdl
X3RvX210cnJfd2l0aF9ob2xlKHN0cnVjdCB2YXJfbXRycl9zdGF0ZSAqc3RhdGUsIHVuc2lnbmVk
IGxvbmcgYmFzZWspCitzdGF0aWMgdm9pZCBfX2luaXQKK3JhbmdlX3RvX210cnJfd2l0aF9ob2xl
KHN0cnVjdCB2YXJfbXRycl9zdGF0ZSAqc3RhdGUsIHVuc2lnbmVkIGxvbmcgYmFzZWspCiB7CiAJ
dW5zaWduZWQgbG9uZyBob2xlX2Jhc2VrLCBob2xlX3NpemVrOwogCXVuc2lnbmVkIGxvbmcgcmFu
Z2UwX2Jhc2VrLCByYW5nZTBfc2l6ZWs7CkBAIC04NDgsMjMgKzg0OCwzMSBAQCBzdGF0aWMgdm9p
ZCBfX2luaXQgcmFuZ2VfdG9fbXRycl93aXRoX2hvCiAJLyogdHJ5IHRvIGFwcGVuZCBzb21lIHNt
YWxsIGhvbGUgKi8KIAlyYW5nZTBfYmFzZWsgPSBzdGF0ZS0+cmFuZ2Vfc3RhcnRrOwogCXJhbmdl
MF9zaXplayA9IEFMSUdOKHN0YXRlLT5yYW5nZV9zaXplaywgY2h1bmtfc2l6ZWspOwotCWlmICgo
cmFuZ2UwX3NpemVrID09IHN0YXRlLT5yYW5nZV9zaXplaykgfHwKLQkgICAgKChyYW5nZTBfYmFz
ZWsgKyByYW5nZTBfc2l6ZWsgLSBjaHVua19zaXplayA+IGJhc2VrKSAmJiBiYXNlaykpIHsKKwlp
ZiAocmFuZ2UwX3NpemVrID09IHN0YXRlLT5yYW5nZV9zaXplaykgewogCQkJcHJpbnRrKEtFUk5f
SU5GTyAicmFuZ2VYOiAlMDE2bHggLSAlMDE2bHhcbiIsIHJhbmdlMF9iYXNlazw8MTAsIChyYW5n
ZTBfYmFzZWsgKyBzdGF0ZS0+cmFuZ2Vfc2l6ZWspPDwxMCk7CiAJCQlzdGF0ZS0+cmVnID0gcmFu
Z2VfdG9fbXRycihzdGF0ZS0+cmVnLCByYW5nZTBfYmFzZWssCiAJCQkJc3RhdGUtPnJhbmdlX3Np
emVrLCBNVFJSX1RZUEVfV1JCQUNLLCBzdGF0ZS0+YWRkcmVzc19iaXRzKTsKIAkJcmV0dXJuOwor
CX0gZWxzZSBpZiAoYmFzZWspIHsKKwkgICAgd2hpbGUgKHJhbmdlMF9iYXNlayArIHJhbmdlMF9z
aXplayAtIGNodW5rX3NpemVrID4gYmFzZWspIHsKKwkJcmFuZ2UwX3NpemVrIC09IGNodW5rX3Np
emVrOworCQlpZiAoIXJhbmdlMF9zaXplaykKKwkJCWJyZWFrOworCSAgICB9CiAJfQogCiAKLQly
YW5nZTBfc2l6ZWsgLT0gY2h1bmtfc2l6ZWs7CisJaWYgKHJhbmdlMF9zaXplayA+IGNodW5rX3Np
emVrKQorCQlyYW5nZTBfc2l6ZWsgLT0gY2h1bmtfc2l6ZWs7CiAJcHJpbnRrKEtFUk5fSU5GTyAi
cmFuZ2UwOiAlMDE2bHggLSAlMDE2bHhcbiIsIHJhbmdlMF9iYXNlazw8MTAsIChyYW5nZTBfYmFz
ZWsgKyByYW5nZTBfc2l6ZWspPDwxMCk7CiAJc3RhdGUtPnJlZyA9IHJhbmdlX3RvX210cnIoc3Rh
dGUtPnJlZywgcmFuZ2UwX2Jhc2VrLAogCQkJcmFuZ2UwX3NpemVrLCBNVFJSX1RZUEVfV1JCQUNL
LCBzdGF0ZS0+YWRkcmVzc19iaXRzKTsKIAogCXJhbmdlX2Jhc2VrID0gcmFuZ2UwX2Jhc2VrICsg
cmFuZ2UwX3NpemVrOwogCXJhbmdlX3NpemVrID0gY2h1bmtfc2l6ZWs7Ci0JaWYgKHJhbmdlX3Np
emVrIC0gKHN0YXRlLT5yYW5nZV9zaXplayAtIHJhbmdlMF9zaXplaykgPCAoY2h1bmtfc2l6ZWsg
Pj4gMSkpIHsKKworCWlmICgocmFuZ2Vfc2l6ZWsgLSAoc3RhdGUtPnJhbmdlX3NpemVrIC0gcmFu
Z2UwX3NpemVrKSA8IChjaHVua19zaXplayA+PiAxKSkgJiYKKwkgICAgKHJhbmdlX2Jhc2VrICsg
cmFuZ2Vfc2l6ZWsgPD0gYmFzZWspKSB7CiAJCWhvbGVfc2l6ZWsgPSByYW5nZV9zaXplayAtIChz
dGF0ZS0+cmFuZ2Vfc2l6ZWsgLSByYW5nZTBfc2l6ZWspOwogCQlob2xlX2Jhc2VrID0gcmFuZ2Vf
YmFzZWsgKyByYW5nZV9zaXplayAtIGhvbGVfc2l6ZWs7CiAJfSBlbHNlCkBAIC04ODAsNyArODg4
LDkgQEAgc3RhdGljIHZvaWQgX19pbml0IHJhbmdlX3RvX210cnJfd2l0aF9obwogCX0KIH0KIAot
c3RhdGljIHZvaWQgX19pbml0IHNldF92YXJfbXRycl9yYW5nZShzdHJ1Y3QgdmFyX210cnJfc3Rh
dGUgKnN0YXRlLCB1bnNpZ25lZCBsb25nIGJhc2VfcGZuLCB1bnNpZ25lZCBsb25nIHNpemVfcGZu
KQorc3RhdGljIHZvaWQgX19pbml0CitzZXRfdmFyX210cnJfcmFuZ2Uoc3RydWN0IHZhcl9tdHJy
X3N0YXRlICpzdGF0ZSwgdW5zaWduZWQgbG9uZyBiYXNlX3BmbiwKKwkJICAgdW5zaWduZWQgbG9u
ZyBzaXplX3BmbikKIHsKIAl1bnNpZ25lZCBsb25nIGJhc2VrLCBzaXplazsKIApAQCAtOTIxLDcg
KzkzMSw3IEBAIHN0YXRpYyBpbnQgX19pbml0IHBhcnNlX210cnJfY2h1bmtfc2l6ZV8KIGVhcmx5
X3BhcmFtKCJtdHJyX2NodW5rX3NpemUiLCBwYXJzZV9tdHJyX2NodW5rX3NpemVfb3B0KTsKIAog
LyogZ3Jhbml0eSBvZiBtdHJyIG9mIGJsb2NrICovCi1zdGF0aWMgdTY0IG10cnJfZ3Jhbl9zaXpl
IF9faW5pdGRhdGEgPSAoNjRVTEw8PDIwKTsKK3N0YXRpYyB1NjQgbXRycl9ncmFuX3NpemUgX19p
bml0ZGF0YSA9ICgxVUxMPDwyMCk7CiAKIHN0YXRpYyBpbnQgX19pbml0IHBhcnNlX210cnJfZ3Jh
bl9zaXplX29wdChjaGFyICpwKQogewpAQCAtOTMyLDE3ICs5NDIsMTkgQEAgc3RhdGljIGludCBf
X2luaXQgcGFyc2VfbXRycl9ncmFuX3NpemVfbwogfQogZWFybHlfcGFyYW0oIm10cnJfZ3Jhbl9z
aXplIiwgcGFyc2VfbXRycl9ncmFuX3NpemVfb3B0KTsKIAotc3RhdGljIHZvaWQgX19pbml0IHg4
Nl9zZXR1cF92YXJfbXRycnMoc3RydWN0IHJlc19yYW5nZSAqcmFuZ2UsIGludCBucl9yYW5nZSwg
dW5zaWduZWQgYWRkcmVzc19iaXRzKQorc3RhdGljIHZvaWQgX19pbml0Cit4ODZfc2V0dXBfdmFy
X210cnJzKHN0cnVjdCByZXNfcmFuZ2UgKnJhbmdlLCBpbnQgbnJfcmFuZ2UsCisJCSAgICB1bnNp
Z25lZCBhZGRyZXNzX2JpdHMpCiB7CiAJc3RydWN0IHZhcl9tdHJyX3N0YXRlIHZhcl9zdGF0ZTsK
IAlpbnQgaTsKIAotCXZhcl9zdGF0ZS5yYW5nZV9zdGFydGsgPSAwOwotCXZhcl9zdGF0ZS5yYW5n
ZV9zaXplayA9IDA7Ci0JdmFyX3N0YXRlLnJlZyA9IDA7Ci0JdmFyX3N0YXRlLmFkZHJlc3NfYml0
cyA9IGFkZHJlc3NfYml0czsKLQl2YXJfc3RhdGUuY2h1bmtfc2l6ZWsgPSBtdHJyX2NodW5rX3Np
emUgPj4gMTA7Ci0JdmFyX3N0YXRlLmdyYW5fc2l6ZWsgPSBtdHJyX2dyYW5fc2l6ZSA+PiAxMDsK
Kwl2YXJfc3RhdGUucmFuZ2Vfc3RhcnRrCT0gMDsKKwl2YXJfc3RhdGUucmFuZ2Vfc2l6ZWsJPSAw
OworCXZhcl9zdGF0ZS5yZWcJCT0gMDsKKwl2YXJfc3RhdGUuYWRkcmVzc19iaXRzCT0gYWRkcmVz
c19iaXRzOworCXZhcl9zdGF0ZS5jaHVua19zaXplawk9IG10cnJfY2h1bmtfc2l6ZSA+PiAxMDsK
Kwl2YXJfc3RhdGUuZ3Jhbl9zaXplawk9IG10cnJfZ3Jhbl9zaXplID4+IDEwOwogCiAJLyogV3Jp
dGUgdGhlIHJhbmdlIGV0YyAqLwogCWZvciAoaSA9IDA7IGkgPCBucl9yYW5nZTsgaSsrKQpAQCAt
OTUyLDExICs5NjQsMTYgQEAgc3RhdGljIHZvaWQgX19pbml0IHg4Nl9zZXR1cF92YXJfbXRycnMo
cwogCXJhbmdlX3RvX210cnJfd2l0aF9ob2xlKCZ2YXJfc3RhdGUsIDApOwogCXByaW50ayhLRVJO
X0lORk8gIkRPTkUgdmFyaWFibGUgTVRSUnNcbiIpOwogCS8qIENsZWFyIG91dCB0aGUgZXh0cmEg
TVRSUidzICovCi0Jd2hpbGUgKHZhcl9zdGF0ZS5yZWcgPCBudW1fdmFyX3JhbmdlcykKLQkJc2V0
X3Zhcl9tdHJyKHZhcl9zdGF0ZS5yZWcrKywgMCwgMCwgMCwgdmFyX3N0YXRlLmFkZHJlc3NfYml0
cyk7CisJd2hpbGUgKHZhcl9zdGF0ZS5yZWcgPCBudW1fdmFyX3JhbmdlcykgeworCQlzZXRfdmFy
X210cnIodmFyX3N0YXRlLnJlZywgMCwgMCwgMCwgdmFyX3N0YXRlLmFkZHJlc3NfYml0cyk7CisJ
CXZhcl9zdGF0ZS5yZWcrKzsKKwl9CiB9CiAKLXN0YXRpYyBpbnQgX19pbml0IHg4Nl9nZXRfbXRy
cl9tZW1fcmFuZ2Uoc3RydWN0IHJlc19yYW5nZSAqcmFuZ2UsIGludCBucl9yYW5nZSwgdW5zaWdu
ZWQgbG9uZyBleHRyYV9yZW1vdmVfYmFzZSwgdW5zaWduZWQgbG9uZyBleHRyYV9yZW1vdmVfc2l6
ZSkKK3N0YXRpYyBpbnQgX19pbml0Cit4ODZfZ2V0X210cnJfbWVtX3JhbmdlKHN0cnVjdCByZXNf
cmFuZ2UgKnJhbmdlLCBpbnQgbnJfcmFuZ2UsCisJCSAgICAgICB1bnNpZ25lZCBsb25nIGV4dHJh
X3JlbW92ZV9iYXNlLAorCQkgICAgICAgdW5zaWduZWQgbG9uZyBleHRyYV9yZW1vdmVfc2l6ZSkK
IHsKIAl1bnNpZ25lZCBsb25nIGksIGJhc2UsIHNpemU7CiAJbXRycl90eXBlIHR5cGU7CkBAIC05
NjUsNyArOTgyLDcgQEAgc3RhdGljIGludCBfX2luaXQgeDg2X2dldF9tdHJyX21lbV9yYW5nZQog
CQltdHJyX2lmLT5nZXQoaSwgJmJhc2UsICZzaXplLCAmdHlwZSk7CiAJCWlmICh0eXBlICE9IE1U
UlJfVFlQRV9XUkJBQ0spCiAJCQljb250aW51ZTsKLQkJbnJfcmFuZ2UgPSBhZGRfcmFuZ2UocmFu
Z2UsIG5yX3JhbmdlLCBiYXNlLCBiYXNlICsgc2l6ZSAtIDEsIDEpOworCQlucl9yYW5nZSA9IGFk
ZF9yYW5nZV93aXRoX21lcmdlKHJhbmdlLCBucl9yYW5nZSwgYmFzZSwgYmFzZSArIHNpemUgLSAx
KTsKIAl9CiAJcHJpbnRrKEtFUk5fSU5GTyAiQWZ0ZXIgV0IgY2hlY2tpbmdcbiIpOwogCWZvciAo
aSA9IDA7IGkgPCBucl9yYW5nZTsgaSsrKQpAQCAtMTAwNSwxMSArMTAyMiwxMSBAQCBzdGF0aWMg
aW50IF9faW5pdCB4ODZfZ2V0X210cnJfbWVtX3JhbmdlCiAKIHN0YXRpYyBpbnQgX19pbml0IG10
cnJfY2xlYW51cCh1bnNpZ25lZCBhZGRyZXNzX2JpdHMpCiB7CisJdW5zaWduZWQgbG9uZyBleHRy
YV9yZW1vdmVfYmFzZSwgZXh0cmFfcmVtb3ZlX3NpemU7CiAJdW5zaWduZWQgbG9uZyBpLCBiYXNl
LCBzaXplLCBkZWYsIGR1bW15OwotCW10cnJfdHlwZSB0eXBlOwogCXN0cnVjdCByZXNfcmFuZ2Ug
cmFuZ2VbUkFOR0VfTlVNXTsKKwltdHJyX3R5cGUgdHlwZTsKIAlpbnQgbnJfcmFuZ2U7Ci0JdW5z
aWduZWQgbG9uZyBleHRyYV9yZW1vdmVfYmFzZSwgZXh0cmFfcmVtb3ZlX3NpemU7CiAKIAkvKiBl
eHRyYSBvbmUgZm9yIGFsbCAwICovCiAJaW50IG51bVtNVFJSX05VTV9UWVBFUyArIDFdOwpAQCAt
MTA1Myw3ICsxMDcwLDYgQEAgc3RhdGljIGludCBfX2luaXQgbXRycl9jbGVhbnVwKHVuc2lnbmVk
IAogCXg4Nl9zZXR1cF92YXJfbXRycnMocmFuZ2UsIG5yX3JhbmdlLCBhZGRyZXNzX2JpdHMpOwog
CiAJcmV0dXJuIDE7Ci0KIH0KIAogc3RhdGljIGludCBkaXNhYmxlX210cnJfdHJpbTsK
------=_Part_10357_13726424.1209505762320--
