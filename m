Return-Path: <linux-kernel-owner+w=401wt.eu-S934521AbZIEAQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934521AbZIEAQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934500AbZIEAQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:16:10 -0400
Received: from mail-iw0-f175.google.com ([209.85.223.175]:62307 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934059AbZIEAQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:16:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AVYSHq1BRTu4KhwzzZqPo8hkeRv8E/hn2sN8q+vrkMtclJzORWiYjunZVgd0jX7iwD
         S53xG5nU2/V/BSqzkct9Yppdha9RTbG+h1X1RHrNS4QXIwcuqAU0KPZ83OU7glqg4zVy
         uE+Viy25h05RTIxPBUCAkAz3u0DB9MhsOcCBE=
MIME-Version: 1.0
In-Reply-To: <43e72e890909041534v4a4ec6ecpc6198be37adcfdef@mail.gmail.com>
References: <43e72e890909041534v4a4ec6ecpc6198be37adcfdef@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 4 Sep 2009 17:15:47 -0700
Message-ID: <43e72e890909041715p203a06a8h7e836ecffdfc2eaa@mail.gmail.com>
Subject: Re: Memory leak on acpi_add_single_object()
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 4, 2009 at 3:34 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> Here are 3 acpi_add_single_object() kmemleak reports on 2.6.31-rc8 +
> Catalin's kmemleak tree (git://linux-arm.org/linux-2.6 master).
>
> unreferenced object 0xffff88003c405940 (size 64):
>  comm "swapper", pid 1, jiffies 4294892466
>  hex dump (first 32 bytes):
>    00 00 00 00 38 00 00 00 00 00 00 00 00 00 00 00  ....8...........
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  backtrace:
>    [<ffffffff814e9d55>] kmemleak_alloc+0x25/0x60
>    [<ffffffff81119fbb>] __kmalloc+0x16b/0x250
>    [<ffffffff812bb379>] kzalloc+0xf/0x11
>    [<ffffffff812bb983>] acpi_add_single_object+0x58e/0xd3c
>    [<ffffffff812bc34c>] acpi_bus_scan+0x125/0x1af
>    [<ffffffff81818842>] acpi_scan_init+0xc8/0xe9
>    [<ffffffff818185fd>] acpi_init+0x21f/0x265
>    [<ffffffff8100a047>] do_one_initcall+0x37/0x1a0
>    [<ffffffff817efa16>] kernel_init+0x164/0x1ba
>    [<ffffffff810130ca>] child_rip+0xa/0x20
>    [<ffffffffffffffff>] 0xffffffffffffffff
> unreferenced object 0xffff88003c405980 (size 64):
>  comm "swapper", pid 1, jiffies 4294892467
>  hex dump (first 32 bytes):
>    00 00 00 00 38 00 00 00 00 00 00 00 00 00 00 00  ....8...........
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  backtrace:
>    [<ffffffff814e9d55>] kmemleak_alloc+0x25/0x60
>    [<ffffffff81119fbb>] __kmalloc+0x16b/0x250
>    [<ffffffff812bb379>] kzalloc+0xf/0x11
>    [<ffffffff812bb983>] acpi_add_single_object+0x58e/0xd3c
>    [<ffffffff812bc34c>] acpi_bus_scan+0x125/0x1af
>    [<ffffffff81818842>] acpi_scan_init+0xc8/0xe9
>    [<ffffffff818185fd>] acpi_init+0x21f/0x265
>    [<ffffffff8100a047>] do_one_initcall+0x37/0x1a0
>    [<ffffffff817efa16>] kernel_init+0x164/0x1ba
>    [<ffffffff810130ca>] child_rip+0xa/0x20
>    [<ffffffffffffffff>] 0xffffffffffffffff
> unreferenced object 0xffff88003c4059c0 (size 64):
>  comm "swapper", pid 1, jiffies 4294892470
>  hex dump (first 32 bytes):
>    00 00 00 00 38 00 00 00 00 00 00 00 00 00 00 00  ....8...........
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  backtrace:
>    [<ffffffff814e9d55>] kmemleak_alloc+0x25/0x60
>    [<ffffffff81119fbb>] __kmalloc+0x16b/0x250
>    [<ffffffff812bb379>] kzalloc+0xf/0x11
>    [<ffffffff812bb983>] acpi_add_single_object+0x58e/0xd3c
>    [<ffffffff812bc34c>] acpi_bus_scan+0x125/0x1af
>    [<ffffffff81818842>] acpi_scan_init+0xc8/0xe9
>    [<ffffffff818185fd>] acpi_init+0x21f/0x265
>    [<ffffffff8100a047>] do_one_initcall+0x37/0x1a0
>    [<ffffffff817efa16>] kernel_init+0x164/0x1ba
>    [<ffffffff810130ca>] child_rip+0xa/0x20
>    [<ffffffffffffffff>] 0xffffffffffffffff

I get these even after issuing manual scans.

  Luis
