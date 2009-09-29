Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbZI2T2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbZI2T2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 15:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbZI2T2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 15:28:49 -0400
Received: from mail-pz0-f191.google.com ([209.85.222.191]:37595 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbZI2T2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 15:28:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sTXJfmnOHvJfC74WvlT7xYG9OioMLQdwdmICChC4rdlxtkN31bCi7l0bEIjq5W50ok
         nISrvg5hbrsQaWhoWw+Mg1NLvDSwAbqSoWYSy9T0TwPq5bjiX1xtckqRr0rwJ/XjGy/5
         p7p0tT/tXBEs2HZEfOpH4ayBDbvm2iqVNx1fU=
MIME-Version: 1.0
In-Reply-To: <Pine.A41.4.64.0909291547160.1114112@stalin.acc.umu.se>
References: <Pine.A41.4.64.0909291547160.1114112@stalin.acc.umu.se>
Date: Tue, 29 Sep 2009 12:28:51 -0700
Message-ID: <86802c440909291228l7214c46agf9c62c0073b11e2a@mail.gmail.com>
Subject: Re: still mtrr problems
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: =?ISO-8859-1?Q?Bo_Brant=E9n?= <bosse@acc.umu.se>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 6:52 AM, Bo Brantén <bosse@acc.umu.se> wrote:
>
> Hello,
>
> when installing 8G RAM on an Intel DG965OT motherboard Linux will hang at
> boot (or parhaps only become very very slow) if I dont add the boot option
> mem=8192M, Windows Vista 64-bit works without any probelm on the same
> hardware.
>
> /proc/mtrr:
> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
> reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
> reg03: base=0xcf800000 (3320MB), size=   8MB: uncachable, count=1
> reg04: base=0xcf700000 (3319MB), size=   1MB: uncachable, count=1
> reg05: base=0x100000000 (4096MB), size=4096MB: write-back, count=1
> reg06: base=0x200000000 (8192MB), size= 512MB: write-back, count=1
> reg07: base=0xd0000000 (3328MB), size= 256MB: write-combining, count=1
>
> dmesg|grep e820:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
> [    0.000000]  BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf561000 (usable)
> [    0.000000]  BIOS-e820: 00000000cf561000 - 00000000cf56e000 (reserved)
> [    0.000000]  BIOS-e820: 00000000cf56e000 - 00000000cf637000 (usable)
> [    0.000000]  BIOS-e820: 00000000cf637000 - 00000000cf6e9000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000cf6e9000 - 00000000cf6ed000 (usable)
> [    0.000000]  BIOS-e820: 00000000cf6ed000 - 00000000cf6f2000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000cf6f2000 - 00000000cf6f3000 (usable)
> [    0.000000]  BIOS-e820: 00000000cf6f3000 - 00000000cf6ff000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000cf6ff000 - 00000000cf700000 (usable)
> [    0.000000]  BIOS-e820: 00000000cf700000 - 00000000d0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 000000022c000000 (usable)
> --

kernel should trim your e820 to 220000000, could be some strange MTRR
layout that we don't want to touch.

can you post whole bootlog with debug?

YH
