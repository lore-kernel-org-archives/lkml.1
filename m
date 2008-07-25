Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYGYAmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYGYAmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 20:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbYGYAmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 20:42:09 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:59426
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753000AbYGYAmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 20:42:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEAAHO+iEjLrQkK/2dsb2JhbAAIsiI
X-IronPort-AV: E=Sophos;i="4.31,249,1215360000"; 
   d="scan'208";a="293900038"
Subject: [REGRESSION] PAGE_ALIGN(): correctly handle ... breaks AVR32 build
From: Ben Nizette <bn@niasdigital.com>
To: righi.andrea@gmail.com
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       kernel <kernel@avr32linux.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Nias Digital
Date: Fri, 25 Jul 2008 10:41:57 +1000
Message-Id: <1216946517.4004.306.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As of

commit 27ac792ca0b0a1e7e65f20342260650516c95864
Author: Andrea Righi <righi.andrea@gmail.com>
Date:   Wed Jul 23 21:28:13 2008 -0700

    PAGE_ALIGN(): correctly handle 64-bit values on 32-bit architectures

We no longer have PAGE_ALIGN in asm-avr32/page.h so the AVR32 build dies
quite quickly:

  CC      init/main.o
In file included from include/linux/utsname.h:35,
                 from init/main.c:20:
include/linux/sched.h: In function 'arch_pick_mmap_layout':
include/linux/sched.h:2149: error: implicit declaration of function 'PAGE_ALIGN'
make[1]: *** [init/main.o] Error 1
make: *** [init] Error 2

This looks a relatively simple fix, just include linux/mm.h from
asm-avr32/processor.h from where sched.h gets the dodgy macro.
Unfortunately this, and every other placement of an #include
<linux/mm.h> I've tried, ends up in Massive Include Armageddon as per
[1].

Ideas?

Thanks,
	--Ben.

[1] http://niasdigital.com/bnizette/logs/MIA-25-7-8.log

