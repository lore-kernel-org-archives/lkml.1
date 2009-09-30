Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZI3VeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZI3VeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZI3VeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:34:06 -0400
Received: from mail-pz0-f191.google.com ([209.85.222.191]:39634 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZI3VeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fBEINMV72+cbO121gYT2gJ1ne5MSWmgSPiQCfbw/HmO1kkjyT7p1slV6KoYzUAnciy
         HWlE9NxT5GN/WgJVn+GZe2v6mzx8W9fgQCiioOz5MALFsXKAQQGAktfg1gM17Fyq5e7g
         J0rhhMX26mLdmSgea4U3EIbna+eNojvS0n3hM=
MIME-Version: 1.0
In-Reply-To: <20090930131726.2e5f6160@werewolf.home>
References: <20090930131726.2e5f6160@werewolf.home>
Date: Wed, 30 Sep 2009 14:34:08 -0700
Message-ID: <86802c440909301434t44fc4321j78a6eb1a41d5abf@mail.gmail.com>
Subject: Re: Missing MTRR ?
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: =?ISO-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 4:17 AM, J.A. Magallón <jamagallon@ono.com> wrote:
> Hi all...
>
> I'm using 2.6.31.1 on a box like this:
> - Intel(R) Core(TM)2 CPU 6420  @ 2.13GHz (dual core)
> - 4Gb RAM
>
> I find that MTRR setup is this:
> lorelei:/proc# cat mtrr
> reg00: base=0x0cff00000 ( 3327MB), size=    1MB, count=1: uncachable
> reg01: base=0x0d0000000 ( 3328MB), size=  256MB, count=1: uncachable
> reg02: base=0x0e0000000 ( 3584MB), size=  512MB, count=1: uncachable
> reg03: base=0x0cfea6000 ( 3326MB), size=    4KB, count=1: write-back
>
> I have no mtrr for my main memory, is this a problem for speed ?
>
> dmesg:
>
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
>  BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000cee2a000 (usable)
>  BIOS-e820: 00000000cee2a000 - 00000000ceeb1000 (ACPI NVS)
>  BIOS-e820: 00000000ceeb1000 - 00000000cfe00000 (usable)
>  BIOS-e820: 00000000cfe00000 - 00000000cfe0d000 (reserved)
>  BIOS-e820: 00000000cfe0d000 - 00000000cfe94000 (usable)
>  BIOS-e820: 00000000cfe94000 - 00000000cfee9000 (ACPI NVS)
>  BIOS-e820: 00000000cfee9000 - 00000000cfeec000 (usable)
>  BIOS-e820: 00000000cfeec000 - 00000000cfef1000 (ACPI data)
>  BIOS-e820: 00000000cfef1000 - 00000000cfef2000 (usable)
>  BIOS-e820: 00000000cfef2000 - 00000000cfeff000 (ACPI data)
>  BIOS-e820: 00000000cfeff000 - 00000000cff00000 (usable)
>  BIOS-e820: 00000000cff00000 - 00000000d0000000 (reserved)
>  BIOS-e820: 00000000f0000000 - 00000000f8000000 (reserved)
>  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
>  BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
> DMI 2.4 present.
> last_pfn = 0x12c000 max_arch_pfn = 0x400000000
> MTRR default type: write-back
> MTRR fixed ranges enabled:
>  00000-9FFFF write-back
>  A0000-FFFFF uncachable
> MTRR variable ranges enabled:
>  0 base 0CFF00000 mask FFFF00000 uncachable
>  1 base 0D0000000 mask FF0000000 uncachable
>  2 base 0E0000000 mask FE0000000 uncachable
>  3 base 0CFEA6000 mask FFFFFF000 write-back
>  4 disabled
>  5 disabled
>  6 disabled
>  7 disabled

interesting, the default type is write-back.

YH
