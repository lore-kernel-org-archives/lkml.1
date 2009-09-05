Return-Path: <linux-kernel-owner+w=401wt.eu-S934264AbZIEAoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934264AbZIEAoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933858AbZIEAox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:44:53 -0400
Received: from mail.atheros.com ([12.36.123.2]:31872 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933828AbZIEAox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:44:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <catalin.marinas@arm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
       <penberg@cs.helsinki.fi>, <mcgrof@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 0/5] kmemleak: few small cleanups and clear command support
Date: Fri, 4 Sep 2009 17:44:49 -0700
Message-ID: <1252111494-7593-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is my third respin, this time rebased ontop of:

git://linux-arm.org/linux-2.6 kmemleak

As suggested by Catalin we now clear the list by only painting reported
unreferenced objects and the color we use is grey to ensure future
scans are possible on these same objects to account for new allocations
in the future referenced on the cleared objects.

Patch 3 is now a little different, now with a paint_ptr() and
a __paint_it() helper.

I tested this by clearing kmemleak after bootup, then writing my
own buggy module which kmalloc()'d onto some internal pointer,
scanned, unloaded, and scanned again and then saw a new shiny
report come up:

unreferenced object 0xffff88003ad70920 (size 16):
  comm "insmod", pid 7449, jiffies 4296458482
  hex dump (first 16 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814e9d55>] kmemleak_alloc+0x25/0x60
    [<ffffffff81118c3b>] kmem_cache_alloc+0x14b/0x1c0
    [<ffffffffa000a07f>] 0xffffffffa000a07f
    [<ffffffff8100a047>] do_one_initcall+0x37/0x1a0
    [<ffffffff810950d9>] sys_init_module+0xd9/0x230
    [<ffffffff81011f02>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

Luis R. Rodriguez (5):
  kmemleak: use bool for true/false questions
  kmemleak: add clear command support
  kmemleak: move common painting code together
  kmemleak: fix sparse warning over overshadowed flags
  kmemleak: fix sparse warning for static declarations

 Documentation/kmemleak.txt |   30 +++++++++++
 mm/kmemleak.c              |  116 ++++++++++++++++++++++++++++++--------------
 2 files changed, 109 insertions(+), 37 deletions(-)

