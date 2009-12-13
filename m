Return-Path: <linux-kernel-owner+w=401wt.eu-S1751901AbZLMJZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbZLMJZl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 04:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZLMJZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 04:25:39 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:53980 "HELO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751656AbZLMJZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 04:25:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lxPRhyRn/IzkviyA/pdyQKLRLs/FJx4ZyUwfOMLvt20/2OiISVbg8fSPU+bwpglSsR
         43EF9WT8Fy6Br7HJ3P4jJsg3Y44S+xCkG/PGf0FkIx8DpEEhr+71nDQZfYYNLOrU9Hkm
         9VM+dXbynSXSSYaSBI5MAuAb9aKRenIQaHoOo=
MIME-Version: 1.0
In-Reply-To: <200912130826.48302.tvrtko@ursulin.net>
References: <200912130807.44905.tvrtko@ursulin.net>
	 <200912130826.48302.tvrtko@ursulin.net>
Date: Sun, 13 Dec 2009 01:25:33 -0800
X-Google-Sender-Auth: aae1ae5022337e6a
Message-ID: <86802c440912130125y4215ca49l9b1bd49bde07f558@mail.gmail.com>
Subject: Re: Are these MTRR settings correct?
From: Yinghai Lu <yinghai@kernel.org>
To: Tvrtko Ursulin <tvrtko@ursulin.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 12:26 AM, Tvrtko Ursulin <tvrtko@ursulin.net> wrote:
> On Sunday 13 Dec 2009 08:07:44 Tvrtko Ursulin wrote:
>> Hi all,
>>
>> They look a bit suspicious to me since machine has 4GB of RAM, and range
>>  covered by MTRR seems to be short of that. Last entry is from the IGP I
>>  believe, which is also strange because in BIOS an option to map that above
>>  4G is set.
>>
>> tvrtko@deuteros:~> cat /proc/mtrr
>> reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
>> reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
>> reg02: base=0x0c0000000 ( 3072MB), size=  256MB, count=1: write-back
>> reg03: base=0x0d0000000 ( 3328MB), size=  256MB, count=1: write-combining
>
> This IGP has a sideport memory, above sideport plus UMA was enabled in BIOS. If I limit it to
> only 128Mb of sideport framebuffer then it looks like this:
>
> reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
> reg02: base=0x0c0000000 ( 3072MB), size=  256MB, count=1: write-back
> reg03: base=0x0f0000000 ( 3840MB), size=  128MB, count=1: write-combining
>
> Still looks like from 3328MB to 3840MB is of status unknown?
>
> dmesg in that case:
>
> [    0.000000] Linux version 2.6.32 (tvrtko@deuteros) (gcc version 4.4.1 [gcc-4_4-branch revision 150839] (SUSE Linux) ) #2 SMP PREEMPT Sat
> Dec 12 20:44:59 GMT 2009
> [    0.000000] Command line: root=UUID="78df20fb-791f-4a82-b1d6-4e043aa663d1" resume=UUID="fc2d8cd0-fed3-4196-b346-83de887dfcf7"
> splash=silent quiet vga=0x31a 3
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   Centaur CentaurHauls
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
> [    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff90000 (usable)
> [    0.000000]  BIOS-e820: 00000000cff90000 - 00000000cffa8000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000cffa8000 - 00000000cffd0000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000cffd0000 - 00000000d0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
> [    0.000000] DMI present.
> [    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-EFFFF uncachable
> [    0.000000]   F0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
> [    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
> [    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] TOM2: 0000000130000000 aka 4864M

that [d0000000, e0000000) is to mmio space.

your var mtrrs is covering [0, d0000000)

and AMD K8 Rev F, will auto cover your [4G, TOM2) aka [4G, 4G+3*256M) to WB ...
...

> [    0.251043] node 0 link 0: io port [1000, ffffff]
> [    0.251045] TOM: 00000000d0000000 aka 3328M
> [    0.251046] Fam 10h mmconf [e0000000, efffffff]
> [    0.251048] node 0 link 0: mmio [a0000, bffff]
> [    0.251050] node 0 link 0: mmio [d0000000, dfffffff]
> [    0.251051] node 0 link 0: mmio [e0000000, efffffff] ==> none
> [    0.251053] node 0 link 0: mmio [f0000000, fe7fffff]
> [    0.251055] node 0 link 0: mmio [fe800000, fe9fffff]
> [    0.251056] node 0 link 0: mmio [fea00000, ffefffff]
> [    0.251058] TOM2: 0000000130000000 aka 4864M
> [    0.251059] bus: [00,07] on node 0 link 0
> [    0.251060] bus: 00 index 0 io port: [0, ffff]
> [    0.251062] bus: 00 index 1 mmio: [a0000, bffff]
> [    0.251063] bus: 00 index 2 mmio: [d0000000, dfffffff]
> [    0.251064] bus: 00 index 3 mmio: [f0000000, ffffffff]
> [    0.251065] bus: 00 index 4 mmio: [130000000, fcffffffff]
> [    0.251072] ACPI: bus type pci registered
> [    0.251107] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> [    0.251109] PCI: Not using MMCONFIG.
> [    0.251110] PCI: Using configuration type 1 for base access
> [    0.251111] PCI: Using configuration type 1 for extended access

only concern that is your BIOS doesn't have [e000000, F0000000)
reserved in e820 or acpi etc.

you could try to use "pci=check_enable_amd_mmconf" in boot command
line to enable it.

YH
