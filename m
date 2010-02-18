Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484Ab0BRWKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 17:10:20 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37554 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab0BRWKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 17:10:17 -0500
Subject: printk_ratelimited() not compiling
From: john stultz <johnstul@us.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 14:10:13 -0800
Message-ID: <1266531013.3201.86.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Joe, 
	So I thought printk_ratelimited would be perfect for an issue I'm
having, but when I tried using it, replacing a printk I had, I got the
following:

fs/namei.c:1075: error: variable ‘_rs’ has initializer but incomplete type
fs/namei.c:1075: error: unknown field ‘interval’ specified in initializer
fs/namei.c:1075: warning: excess elements in struct initializer
fs/namei.c:1075: warning: (near initialization for ‘_rs’)
fs/namei.c:1075: error: unknown field ‘burst’ specified in initializer
fs/namei.c:1075: warning: excess elements in struct initializer
fs/namei.c:1075: warning: (near initialization for ‘_rs’)
fs/namei.c:1075: error: storage size of ‘_rs’ isn’t known
fs/namei.c:1075: warning: unused variable ‘_rs’


Thinking the issue was ratelimit.h wasn't included I tried that, but
got:

 file included from include/linux/spinlock_types.h:18,
                 from include/linux/ratelimit.h:5,
                 from include/linux/kernel.h:21,
                 from /home/jstultz/projects/linux/linux-2.6-git/arch/x86/include/asm/percpu.h:45,
                 from /home/jstultz/projects/linux/linux-2.6-git/arch/x86/include/asm/current.h:5,
                 from /home/jstultz/projects/linux/linux-2.6-git/arch/x86/include/asm/processor.h:15,
                 from include/linux/prefetch.h:14,
                 from include/linux/list.h:6,
                 from include/linux/module.h:9,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/lockdep.h:52: error: field ‘hash_entry’ has incomplete type
include/linux/lockdep.h:57: error: field ‘lock_entry’ has incomplete type
include/linux/lockdep.h:74: error: field ‘locks_after’ has incomplete type
include/linux/lockdep.h:74: error: field ‘locks_before’ has incomplete type
include/linux/lockdep.h:148: error: field ‘entry’ has incomplete type
include/linux/lockdep.h:167: error: field ‘entry’ has incomplete type
make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

Yuck.

Am I missing something obvious, or did something get broken after this went in?

thanks
-john



