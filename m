Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbXEMHHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbXEMHHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 03:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbXEMHH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 03:07:28 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39440 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbXEMHH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 03:07:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]x86_64: build and use GDT on copied compressed kernel
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
	<m1ejllqmo8.fsf@ebiederm.dsl.xmission.com>
	<86802c440705122329y27c6ef92v8cff43d52b99ae69@mail.gmail.com>
	<m1abw9qkve.fsf@ebiederm.dsl.xmission.com>
	<86802c440705122355r5f811d5bg2006b0b22ca885e6@mail.gmail.com>
Date: Sun, 13 May 2007 01:06:51 -0600
In-Reply-To: <86802c440705122355r5f811d5bg2006b0b22ca885e6@mail.gmail.com>
	(Yinghai Lu's message of "Sat, 12 May 2007 23:55:34 -0700")
Message-ID: <m11whlqk1g.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On 5/12/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> For data segments we never use that GDT, it is only for the code
>> segment we use the GDT and that only to get us into 64bit mode.
>>
>
> after the patch
> linux:/home/yhlu/xx/xx/kernel/linux-2.6/arch/x86_64/boot/compressed #
> readelf -e vmlinux
> ...
> Section Headers:
>  [Nr] Name              Type             Address           Offset
>       Size              EntSize          Flags  Link  Info  Align
>  [ 0]                   NULL             0000000000000000  00000000
>       0000000000000000  0000000000000000           0     0     0
>  [ 1] .text             PROGBITS         0000000000000000  00100000
>       000000000032617c  0000000000000000  AX       0     0     16
>  [ 2] .rodata           PROGBITS         0000000000326180  00426180
>       0000000000000400  0000000000000000   A       0     0     32
>  [ 3] .eh_frame         PROGBITS         0000000000326580  00426580
>       0000000000000210  0000000000000000   A       0     0     8
>  [ 4] .data             PROGBITS         0000000000326790  00426790
>       0000000000000008  0000000000000000  WA       0     0     8
>  [ 5] .bss              NOBITS           00000000003267a0  00426798
>       000000000000b860  0000000000000000  WA       0     0     32
>  [ 6] .comment          PROGBITS         0000000000000000  00426798
>       0000000000000035  0000000000000000           0     0     1
>  [ 7] .shstrtab         STRTAB           0000000000000000  004267cd
>       0000000000000047  0000000000000000           0     0     1
>  [ 8] .symtab           SYMTAB           0000000000000000  00426a98
>       00000000000007c8  0000000000000018           9    60     8
>  [ 9] .strtab           STRTAB           0000000000000000  00427260
>       0000000000000350  0000000000000000           0     0     1
> Key to Flags:
>  W (write), A (alloc), X (execute), M (merge), S (strings)
>  I (info), L (link order), G (group), x (unknown)
>  O (extra OS processing required) o (OS specific), p (processor specific)
>
> after the patch, it seems .data section size still have 8 bytes.
> before that will 0x28.
> don't know what are the 8 bytes.

Probably variables in misc.c


Eric
