Return-Path: <linux-kernel-owner+w=401wt.eu-S1760586AbXKHGYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760586AbXKHGYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 01:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbXKHGYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 01:24:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36614
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbXKHGYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 01:24:07 -0500
Date: Wed, 07 Nov 2007 22:24:06 -0800 (PST)
Message-Id: <20071107.222406.90744682.davem@davemloft.net>
To: paulus@samba.org
Cc: akpm@linux-foundation.org, lkml@davidb.org, linux-kernel@vger.kernel.org,
       drepper@redhat.com, mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
From: David Miller <davem@davemloft.net>
In-Reply-To: <18226.39815.631891.784259@cargo.ozlabs.ibm.com>
References: <20071107190714.9c404e28.akpm@linux-foundation.org>
	<20071107.191354.115487072.davem@davemloft.net>
	<18226.39815.631891.784259@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Thu, 8 Nov 2007 16:15:51 +1100

> David Miller writes:
> 
> > I can't see where x86 is doing this though, so perhaps for x86
> > glibc does make the negative value check.  But I doubt it is
> > checking the range 0x80000000-0xffffffff, otherwise mmap() would
> > be busted.
> 
> At least for the INTERNAL_SYSCALL macro in glibc, the error check is:
> 
> #define INTERNAL_SYSCALL_ERROR_P(val, err) \
>   ((unsigned int) (val) >= 0xfffff001u)
> 
> in sysdeps/unix/sysv/linux/i386/sysdep.h.  Similarly the PSEUDO macro
> in that file does a cmpl $-4095,%eax to test for error.  (There is also
> a PSEUDO_NOERRNO which doesn't test for error.)
> 
> So the convention on (32-bit) x86 is that -4095 .. -1 are error
> values, and other values are successful return values.

Thanks for figuring that out.

Really there is no way to fix sys_times() return values
universally.  Each proposed solution either doesn't fix
the problem, or adds a new failure mode.
