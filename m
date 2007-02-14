Return-Path: <linux-kernel-owner+w=401wt.eu-S1751546AbXBNKha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbXBNKha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 05:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbXBNKha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 05:37:30 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3779 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbXBNKh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 05:37:29 -0500
Date: Wed, 14 Feb 2007 10:36:55 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/11] syslets: core, documentation
Message-ID: <20070214103655.GB4241@flint.arm.linux.org.uk>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@zip.com.au>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Ulrich Drepper <drepper@redhat.com>,
	Zach Brown <zach.brown@oracle.com>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Suparna Bhattacharya <suparna@in.ibm.com>,
	Davide Libenzi <davidel@xmailserver.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20060529212109.GA2058@elte.hu> <20070213142042.GG638@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213142042.GG638@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 03:20:42PM +0100, Ingo Molnar wrote:
> +Arguments to the system call are implemented via pointers to arguments.
> +This not only increases the flexibility of syslet atoms (multiple syslets
> +can share the same variable for example), but is also an optimization:
> +copy_uatom() will only fetch syscall parameters up until the point it
> +meets the first NULL pointer. 50% of all syscalls have 2 or less
> +parameters (and 90% of all syscalls have 4 or less parameters).
> +
> + [ Note: since the argument array is at the end of the atom, and the
> +   kernel will not touch any argument beyond the final NULL one, atoms
> +   might be packed more tightly. (the only special case exception to
> +   this rule would be SKIP_TO_NEXT_ON_STOP atoms, where the kernel will
> +   jump a full syslet_uatom number of bytes.) ]

What if you need to increase the number of arguments passed to a system
call later?  That would be an API change since the size of syslet_uatom
would change?

Also, what if you have an ABI such that:

sys_foo(int fd, long long a)

where:
 arg[0] <= fd
 arg[1] <= unused
 arg[2] <= low 32-bits a
 arg[3] <= high 32-bits a

it seems you need to point arg[1] to some valid but dummy variable.

How do you propose syslet users know about these kinds of ABI issues
(including the endian-ness of 64-bit arguments) ?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
