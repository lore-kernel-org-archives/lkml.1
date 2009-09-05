Return-Path: <linux-kernel-owner+w=401wt.eu-S934342AbZIEAHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934342AbZIEAHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934059AbZIEAG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:06:58 -0400
Received: from mail-iw0-f175.google.com ([209.85.223.175]:64523 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934011AbZIEAG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=ODhENhpQhIn4Ylv1REkrhmLeeBwoY5+lIcFiF5DF0puEg3VZdpRU2pbSI5XMxPvRhH
         B4catv3srQ2EqZw99HV5YsF+qIQFfOPQE1qCNcA3s5KbJYf3OU7LQ6g6nx2wa47EmusT
         1uW0p3SIAFtwqeOgCJY7A5vnS2NdpHiCOV8PA=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 4 Sep 2009 17:06:39 -0700
Message-ID: <43e72e890909041706u12f271eq2317c69038c73c2@mail.gmail.com>
Subject: process_zones() kmemleak on 2.6.31-rc8
To: linux-mm@kvack.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get these kmemleak reports on 2.6.31-rc8 + Catalin's
git://linux-arm.org/linux-2.6 kmemleak branch. This kmemleak report
sticks there even after further scans issued manually.

unreferenced object 0xffff88003e001040 (size 64):
  comm "swapper", pid 0, jiffies 4294892296
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
    50 10 00 3e 00 88 ff ff 50 10 00 3e 00 88 ff ff  P..>....P..>....
  backtrace:
    [<ffffffff814e9d55>] kmemleak_alloc+0x25/0x60
    [<ffffffff81118a83>] kmem_cache_alloc_node+0x193/0x200
    [<ffffffff814fa09e>] process_zones+0x70/0x1cd
    [<ffffffff8180d4c5>] setup_per_cpu_pageset+0x11/0x27
    [<ffffffff817f0016>] start_kernel+0x371/0x415
    [<ffffffff817ef61a>] x86_64_start_reservations+0x125/0x129
    [<ffffffff817ef718>] x86_64_start_kernel+0xfa/0x109
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88003e0015c0 (size 64):
  comm "swapper", pid 1, jiffies 4294892353
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
    d0 15 00 3e 00 88 ff ff d0 15 00 3e 00 88 ff ff  ...>.......>....
  backtrace:
    [<ffffffff814e9d55>] kmemleak_alloc+0x25/0x60
    [<ffffffff81118a83>] kmem_cache_alloc_node+0x193/0x200
    [<ffffffff814fa09e>] process_zones+0x70/0x1cd
    [<ffffffff814fa230>] pageset_cpuup_callback+0x35/0x92
    [<ffffffff815019b7>] notifier_call_chain+0x47/0x90
    [<ffffffff81078559>] __raw_notifier_call_chain+0x9/0x10
    [<ffffffff814f8f25>] _cpu_up+0x75/0x130
    [<ffffffff814f903a>] cpu_up+0x5a/0x6a
    [<ffffffff817ef97e>] kernel_init+0xcc/0x1ba
    [<ffffffff810130ca>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff

  Luis
