Return-Path: <linux-kernel-owner+w=401wt.eu-S933518AbZDASnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518AbZDASnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 14:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933452AbZDASnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 14:43:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:37358 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500AbZDASnh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 14:43:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GUa4bIycqdESaVF0zBcHYlta63p2ixV8YGOJFCplz6eonSCNKCEkT/up1FijvSjCsg
         I1T6LorrW8V3ZWI08IS/O7HA0M/Vn2oVG2LHusDRxfF3/gRmHqFu6EIwaCbXhasDNMNp
         SKFRzSeKeWtZy4/tzQBq7/wi9kQthv+Wz9OXo=
MIME-Version: 1.0
In-Reply-To: <Pine.SOC.4.64.0904011711210.5672@math.ut.ee>
References: <Pine.SOC.4.64.0904011711210.5672@math.ut.ee>
Date: Wed, 1 Apr 2009 11:43:35 -0700
X-Google-Sender-Auth: 8feffff45a161a97
Message-ID: <86802c440904011143i65d99bd8x7a296f616f6bfccc@mail.gmail.com>
Subject: Re: strange MTRR on 2.6.29-git
From: Yinghai Lu <yinghai@kernel.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 1, 2009 at 7:13 AM, Meelis Roos <mroos@linux.ee> wrote:
> Found this on todays 2.6.29 + git. The same address range has both WB
> and UC MTRR-s.
>
> reg00: base=0x000000000 (    0MB), size=  512MB, count=1: write-back
> reg01: base=0x020000000 (  512MB), size=    1MB, count=1: write-back
> reg02: base=0x020000000 (  512MB), size=    1MB, count=1: uncachable
> reg03: base=0x0f2000000 ( 3872MB), size=   32MB, count=2: write-combining
> reg04: base=0x0f8000000 ( 3968MB), size=   64MB, count=1: write-combining
>
> [    0.000000] Linux version 2.6.29-06608-g15f7176-dirty (mroos@rhn) (gcc version 4.3.3 (Debian 4.3.3-5) ) #195 PREEMPT Tue Mar 31 13:57:57 EEST 2009
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   NSC Geode by NSC
> [    0.000000]   Cyrix CyrixInstead
> [    0.000000]   Centaur CentaurHauls
> [    0.000000]   Transmeta GenuineTMx86
> [    0.000000]   Transmeta TransmetaCPU
> [    0.000000]   UMC UMC UMC UMC
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000001ffc0000 (usable)
> [    0.000000]  BIOS-e820: 000000001ffc0000 - 000000001fff8000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000001fff8000 - 0000000020000000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000ffb80000 - 00000000ffc00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
> [    0.000000] DMI 2.3 present.
> [    0.000000] last_pfn = 0x1ffc0 max_arch_pfn = 0x100000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-CFFFF write-protect
> [    0.000000]   D0000-DFFFF uncachable
> [    0.000000]   E0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask FE0000000 write-back
> [    0.000000]   1 base 020000000 mask FFFF00000 write-back
> [    0.000000]   2 base 020000000 mask FFFF00000 uncachable
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
> [    0.000000]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
> [    0.000000]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable

that is original setting by BIOS.
it should be ok.
if you like, could try to enable

CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1

it could do the clean up for you.

YH
