Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZI2JSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZI2JSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 05:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbZI2JSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 05:18:52 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:41341 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbZI2JSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 05:18:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=kaXieJVzC5pLeDH8N3KCefVPcgfmY+TfNoBcxD+3lT54Vwfyho+OxxJgiIDi5CU14M
         4IN8AoAvRkjAVwU36RUn6VbB6Zc1h/iNUZFO/l3+q70pnIT7w6MJZsl4z76i98kj9RDj
         XuB8c/aQQ00J95UvADH1FX8h/+C8z5WTiT7O4=
MIME-Version: 1.0
Date: Tue, 29 Sep 2009 11:18:53 +0200
Message-ID: <c4e36d110909290218g3f98c595kaa15566b94527f04@mail.gmail.com>
Subject: ACPI boot memory leaks in 2.6.32-rc1/2
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: len.brown@intel.com, bjorn.helgaas@hp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

My qemu guest seems to be reporting now 46 memleaks  ACPI related.

My kernel   x86_64 - commit: 17d857be649a21ca90008c6dc425d849fa83db5c
(2.6.32-rc1)


unreferenced object 0xffff88001f8095d0 (size 8):
  comm "swapper", pid 1, jiffies 4294877484
  hex dump (first 8 bytes):
    5c 00 80 1f 00 88 ff ff                          \.......
  backtrace:
    [<ffffffff8140a0c6>] kmemleak_alloc+0x26/0x60
    [<ffffffff81128253>] __kmalloc+0x153/0x250
    [<ffffffff812bfff5>] acpi_os_allocate+0x25/0x27
    [<ffffffff812c0037>] acpi_ut_initialize_buffer+0x40/0x71
    [<ffffffff812b739b>] acpi_ns_handle_to_pathname+0x3f/0xa7
    [<ffffffff812b84c4>] acpi_get_name+0x45/0xb8
    [<ffffffff8129b854>] acpi_bus_scan+0x3e/0xa0
    [<ffffffff81878acd>] acpi_scan_init+0x45/0xba
    [<ffffffff81878906>] acpi_init+0x21f/0x26a
    [<ffffffff8100904c>] do_one_initcall+0x3c/0x1d0
    [<ffffffff818574e6>] kernel_init+0x150/0x1a6
    [<ffffffff8100d21a>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88001fa13380 (size 128):
  comm "swapper", pid 1, jiffies 4294877495
  hex dump (first 32 bytes):
    7d 00 00 00 50 43 49 30 06 00 00 00 00 0f 01 ff  }...PCI0........
    ff ff ff ff ff ff ff ff ff ff ff ff 00 00 00 00  ................
  backtrace:
    [<ffffffff8140a0c6>] kmemleak_alloc+0x26/0x60
    [<ffffffff81128253>] __kmalloc+0x153/0x250
    [<ffffffff812b829f>] acpi_get_object_info+0x161/0x341
    [<ffffffff8129afcc>] acpi_add_single_object+0x2b8/0x9ca
    [<ffffffff8129b7be>] acpi_bus_check_add+0xe0/0x138
    [<ffffffff812b98b4>] acpi_ns_walk_namespace+0xb2/0x127
    [<ffffffff812b6524>] acpi_walk_namespace+0x78/0xb2
    [<ffffffff8129b89d>] acpi_bus_scan+0x87/0xa0
    [<ffffffff81878acd>] acpi_scan_init+0x45/0xba
    [<ffffffff81878906>] acpi_init+0x21f/0x26a
    [<ffffffff8100904c>] do_one_initcall+0x3c/0x1d0
    [<ffffffff818574e6>] kernel_init+0x150/0x1a6
    [<ffffffff8100d21a>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
....

All seems to be acpi_bus_scan() related.

Zdenek
