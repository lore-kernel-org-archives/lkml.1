Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbXLVAmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbXLVAmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 19:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbXLVAmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 19:42:08 -0500
Received: from mx1.suse.de ([195.135.220.2]:33067 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbXLVAmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 19:42:07 -0500
To: David Miller <davem@davemloft.net>
Cc: mtk.manpages@googlemail.com, akpm@linux-foundation.org, lkml@davidb.org,
       paulus@samba.org, drepper@redhat.com, cfriesen@nortel.com,
       schwab@suse.de, linux-kernel@vger.kernel.org
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
From: Andi Kleen <andi@firstfloor.org>
References: <4733206C.8030903@nortel.com> <4734A4D9.3090907@redhat.com>
	<476A53D4.7040909@gmail.com>
	<20071220.035104.240386115.davem@davemloft.net>
Date: Sat, 22 Dec 2007 01:42:02 +0100
In-Reply-To: <20071220.035104.240386115.davem@davemloft.net> (David Miller's message of "Thu\, 20 Dec 2007 03\:51\:04 -0800 \(PST\)")
Message-ID: <p73wsr7ef1h.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> Only on x86 platforms.  Sparc, IA64, MIPS, powerpc, etc. all get this
> case right.

Do they for 32bit kernels or for 64bit userland? 

> Yes it's another unfortunate side effect of how error status is
> indicated for x86 system calls.

Maybe I'm dense, but doesn't all the kernel code pass it the
same way as the x86 syscall code? For your proposal you
would need a separate error bit coming out of the sys_* to
handle this case. Basically rewrite all code that ever returns
errors in the kernel. Or do I miss something? 

Or are you talking about solving it only for 32bit compat emulation
on 64bit kernels? There it would be possible, but only doing 
it there and not on native 32bit systems wouldn't seem clean to me.

At least on x86-64 the compat code's (near) only goal in live is to be
as compatible to 32it as possible not better.

-Andi
