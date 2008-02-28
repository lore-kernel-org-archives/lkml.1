Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbYB1NiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbYB1NiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 08:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757116AbYB1NiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 08:38:06 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:36285 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbYB1NiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 08:38:05 -0500
Date: Thu, 28 Feb 2008 14:37:18 +0100
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: undefined references to __udivdi3 on powerpc
Message-ID: <20080228133718.GA8383@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While debugging __divdi3 calls in drivers/crypto/hifn_795x.c (due to the
ndelay() delay call with a s64), I found even more breakage of that
sort. This is after a allnoconfig with ARCH=powerpc in 2.6.25-rc3,
plus CONFIG_MODULES=y and CONFIG_CRYPTO_DEV_HIFN_795X=y:

  LD      .tmp_vmlinux1
  kernel/built-in.o: In function `update_xtime_cache':
  (.text+0x221a0): undefined reference to `__umoddi3'
  kernel/built-in.o: In function `update_xtime_cache':
  (.text+0x221c0): undefined reference to `__udivdi3'
  kernel/built-in.o: In function `getnstimeofday':
  (.text+0x22330): undefined reference to `__umoddi3'
  kernel/built-in.o: In function `getnstimeofday':
  (.text+0x22350): undefined reference to `__udivdi3'
  kernel/built-in.o: In function `timekeeping_resume':
  timekeeping.c:(.text+0x226a0): undefined reference to `__udivdi3'
  timekeeping.c:(.text+0x22778): undefined reference to `__umoddi3'
  timekeeping.c:(.text+0x22798): undefined reference to `__udivdi3'
  kernel/built-in.o: In function `update_wall_time':
  (.text+0x22c7c): undefined reference to `__umoddi3'
  kernel/built-in.o: In function `update_wall_time':
  (.text+0x22c9c): undefined reference to `__udivdi3'
  kernel/built-in.o: In function `update_wall_time':
  (.text+0x230f8): undefined reference to `__umoddi3'
  kernel/built-in.o: In function `update_wall_time':
  (.text+0x23118): undefined reference to `__udivdi3'
  kernel/built-in.o: In function `do_settimeofday':
  (.text+0x23520): undefined reference to `__udivdi3'
  kernel/built-in.o: In function `timekeeping_init':
  (.init.text+0x1870): undefined reference to `__udivdi3'
  make[1]: *** [.tmp_vmlinux1] Error 1

But its not a regression, 2.6.24 allnoconfig does not link either on
powerpc32. 

How can this be fixed?

Olaf
