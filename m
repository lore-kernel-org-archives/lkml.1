Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbXKWKQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbXKWKQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbXKWKQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:16:45 -0500
Received: from ro-out-1112.google.com ([72.14.202.178]:60496 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562AbXKWKQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:16:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=gygE1KUkwB+vMKFaqBCTOVjPBR1RJnYTBC8rAySuXtl1nDKpC3Flxgf7l7juF2pXN+UxooPef6blFpuWDfVU+GDUeiiHPp3kH1cKEDupy3n9NUIwNYskamxNKpovHH7aXgTKgeKG4kUKLj/GLZ87Icu2yGVuJKyC5hR7q3F5SNo=
Date: Fri, 23 Nov 2007 18:13:48 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Jeff Dike <jdike@addtoit.com>, Blaisorblade <blaisorblade@yahoo.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PROBLEM] uml doesn't compile on i386
Message-ID: <20071123101348.GC2488@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <84144f020711230052h2d0b8af8radbdf1d7b08a57e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020711230052h2d0b8af8radbdf1d7b08a57e3@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2007 at 10:52:06AM +0200, Pekka Enberg wrote:
>Hi,
>
>Current git head doesn't compile. Looks like fall-out from the x86 merge?
>
>penberg@haji:~/src/linux/uml-2.6$ make ARCH=um
>  SYMLINK arch/um/include/kern_constants.h
>  SYMLINK arch/um/include/sysdep
>make[1]: `arch/um/sys-i386/user-offsets.s' is up to date.
>  CHK     arch/um/include/user_constants.h
>  CHK     include/linux/version.h
>  CHK     include/linux/utsrelease.h
>  CC      arch/um/kernel/asm-offsets.s
>In file included from include/asm/arch/atomic.h:2,
>                 from include/asm/atomic.h:9,
>                 from include/linux/spinlock.h:333,
>                 from include/linux/seqlock.h:29,
>                 from include/linux/time.h:8,
>                 from include/linux/timex.h:57,
>                 from include/linux/sched.h:53,
>                 from arch/um/include/sysdep/kernel-offsets.h:2,
>                 from arch/um/kernel/asm-offsets.c:1:
>include/asm/arch/atomic_32.h: In function 'atomic_add_unless':
>include/asm/arch/atomic_32.h:237: error: 'struct cpuinfo_um' has no
>member named 'x86'
>In file included from include/asm/rwsem.h:4,
>                 from include/linux/rwsem.h:24,
>                 from include/linux/mm_types.h:11,
>                 from include/linux/sched.h:60,
>                 from arch/um/include/sysdep/kernel-offsets.h:2,
>                 from arch/um/kernel/asm-offsets.c:1:
>include/asm/arch/rwsem.h: In function '__down_write_trylock':
>include/asm/arch/rwsem.h:165: error: 'struct cpuinfo_um' has no member
>named 'x86'
>make[1]: *** [arch/um/kernel/asm-offsets.s] Error 1
>make: *** [prepare0] Error 2

Hmm, I believe this patch[1] from Jeff can solve the problem. ;-)

[1] http://lkml.org/lkml/2007/11/19/220


