Return-Path: <linux-kernel-owner+w=401wt.eu-S932638AbYBHBef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbYBHBef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 20:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760039AbYBHBe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 20:34:26 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:63394 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761476AbYBHBeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 20:34:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CANBAq0dMQWYq/2dsb2JhbACBWapE
Date: Thu, 7 Feb 2008 20:34:23 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: frv cmpxchg_local compile error
Message-ID: <20080208013422.GA22122@Krystal>
References: <20080207231350.GG7198@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080207231350.GG7198@cs181133002.pp.htv.fi>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:29:14 up 96 days,  6:34,  3 users,  load average: 1.89, 2.09,
	1.54
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@kernel.org) wrote:
> Commit 14e0cb3c60b89c4a2512852ffc18601c72314a0f broke frv compilation:
> 
> <--  snip  -->
> 
> ...
>   CC      arch/frv/kernel/asm-offsets.s
> In file included from include/asm/system.h:271,
>                  from include/asm/bitops.h:19,
>                  from include/linux/bitops.h:17,
>                  from include/linux/kernel.h:15,
>                  from include/linux/sched.h:52,
>                  from arch/frv/kernel/asm-offsets.c:7:
> include/asm-generic/cmpxchg-local.h: In function '__cmpxchg_local_generic':
> include/asm-generic/cmpxchg-local.h:23: error: implicit declaration of function 'typecheck'


Isn't typecheck() supposed to be defined in kernel.h which is included
_everywhere_ ?

Hrm, I see, dependency from kernel.h on bitops.h on asm/bitops.h on
asm/system.h.



> include/asm-generic/cmpxchg-local.h:23: error: expected expression before 'unsigned'
> include/asm-generic/cmpxchg-local.h:23: error: expected expression before 'unsigned'
> include/asm-generic/cmpxchg-local.h:44: error: expected expression before 'unsigned'
> include/asm-generic/cmpxchg-local.h: In function '__cmpxchg64_local_generic':
> include/asm-generic/cmpxchg-local.h:57: error: expected expression before 'unsigned'
> include/asm-generic/cmpxchg-local.h:57: error: expected expression before 'unsigned'
> include/asm-generic/cmpxchg-local.h:61: error: expected expression before 'unsigned'
> In file included from include/asm/bitops.h:19,
>                  from include/linux/bitops.h:17,
>                  from include/linux/kernel.h:15,
>                  from include/linux/sched.h:52,
>                  from arch/frv/kernel/asm-offsets.c:7:
> include/asm/system.h: In function '__cmpxchg_local':
> include/asm/system.h:279: error: variable or field '__xg_orig' declared void
> include/asm/system.h:279: error: variable or field '__xg_test' declared void
> include/asm/system.h:279: error: variable or field '__xg_new' declared void
> include/asm/system.h:279: error: void value not ignored as it ought to be
> make[1]: *** [arch/frv/kernel/asm-offsets.s] Error 1
> 
> <--  snip  -->
> 
> 
> An architecture specific patch that breaks the one architecture it 
> touches at the first file being compiled is even for kernel standards 
> unusually bad...
> 

I did this cmpxchg_local patchset to support Christoph Lameter's slub
performance improvement work. It implies touching every kernel
architecture. Each architecture is touched by a different patch. And no,
I did not happen to have an FRV toolchain handy. Sorry. I'll dig into
this.

Mathieu


> 
> cu
> Adrian
> 
> -- 
> 
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
