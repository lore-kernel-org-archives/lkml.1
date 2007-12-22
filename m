Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbXLVBld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbXLVBld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 20:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbXLVBl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 20:41:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60978
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbXLVBlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 20:41:25 -0500
Date: Fri, 21 Dec 2007 17:41:24 -0800 (PST)
Message-Id: <20071221.174124.208826257.davem@davemloft.net>
To: andi@firstfloor.org
Cc: mtk.manpages@googlemail.com, akpm@linux-foundation.org, lkml@davidb.org,
       paulus@samba.org, drepper@redhat.com, cfriesen@nortel.com,
       schwab@suse.de, linux-kernel@vger.kernel.org
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
From: David Miller <davem@davemloft.net>
In-Reply-To: <p73wsr7ef1h.fsf@bingen.suse.de>
References: <476A53D4.7040909@gmail.com>
	<20071220.035104.240386115.davem@davemloft.net>
	<p73wsr7ef1h.fsf@bingen.suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Sat, 22 Dec 2007 01:42:02 +0100

> David Miller <davem@davemloft.net> writes:
> 
> > Only on x86 platforms.  Sparc, IA64, MIPS, powerpc, etc. all get this
> > case right.
> 
> Do they for 32bit kernels or for 64bit userland? 

Both.  This is not a compat issue.

> > Yes it's another unfortunate side effect of how error status is
> > indicated for x86 system calls.
> 
> Maybe I'm dense, but doesn't all the kernel code pass it the
> same way as the x86 syscall code? For your proposal you
> would need a separate error bit coming out of the sys_* to
> handle this case. Basically rewrite all code that ever returns
> errors in the kernel. Or do I miss something? 

I'm suggesting that you set the condition codes based upon whether
there is an error or not.  That is the critical thing x86 doesn't do
that all the other platforms do.

x86 relies on interpretation of purely the integer returned from the
system call to userspace, and that means a certain chunk of the return
value space can never represent valid values.

If you use the condition codes to signal "the return value is an
error" you don't have these problems.
