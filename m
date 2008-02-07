Return-Path: <linux-kernel-owner+w=401wt.eu-S1763625AbYBGXNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763625AbYBGXNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759585AbYBGXNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:13:39 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55366 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757180AbYBGXNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:13:38 -0500
Date: Fri, 8 Feb 2008 01:13:50 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: frv cmpxchg_local compile error
Message-ID: <20080207231350.GG7198@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 14e0cb3c60b89c4a2512852ffc18601c72314a0f broke frv compilation:

<--  snip  -->

...
  CC      arch/frv/kernel/asm-offsets.s
In file included from include/asm/system.h:271,
                 from include/asm/bitops.h:19,
                 from include/linux/bitops.h:17,
                 from include/linux/kernel.h:15,
                 from include/linux/sched.h:52,
                 from arch/frv/kernel/asm-offsets.c:7:
include/asm-generic/cmpxchg-local.h: In function '__cmpxchg_local_generic':
include/asm-generic/cmpxchg-local.h:23: error: implicit declaration of function 'typecheck'
include/asm-generic/cmpxchg-local.h:23: error: expected expression before 'unsigned'
include/asm-generic/cmpxchg-local.h:23: error: expected expression before 'unsigned'
include/asm-generic/cmpxchg-local.h:44: error: expected expression before 'unsigned'
include/asm-generic/cmpxchg-local.h: In function '__cmpxchg64_local_generic':
include/asm-generic/cmpxchg-local.h:57: error: expected expression before 'unsigned'
include/asm-generic/cmpxchg-local.h:57: error: expected expression before 'unsigned'
include/asm-generic/cmpxchg-local.h:61: error: expected expression before 'unsigned'
In file included from include/asm/bitops.h:19,
                 from include/linux/bitops.h:17,
                 from include/linux/kernel.h:15,
                 from include/linux/sched.h:52,
                 from arch/frv/kernel/asm-offsets.c:7:
include/asm/system.h: In function '__cmpxchg_local':
include/asm/system.h:279: error: variable or field '__xg_orig' declared void
include/asm/system.h:279: error: variable or field '__xg_test' declared void
include/asm/system.h:279: error: variable or field '__xg_new' declared void
include/asm/system.h:279: error: void value not ignored as it ought to be
make[1]: *** [arch/frv/kernel/asm-offsets.s] Error 1

<--  snip  -->


An architecture specific patch that breaks the one architecture it 
touches at the first file being compiled is even for kernel standards 
unusually bad...


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

