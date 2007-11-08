Return-Path: <linux-kernel-owner+w=401wt.eu-S1760037AbXKHDOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037AbXKHDOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 22:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbXKHDN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 22:13:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60990
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753021AbXKHDN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 22:13:56 -0500
Date: Wed, 07 Nov 2007 19:13:54 -0800 (PST)
Message-Id: <20071107.191354.115487072.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: paulus@samba.org, lkml@davidb.org, linux-kernel@vger.kernel.org,
       drepper@redhat.com, mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071107190714.9c404e28.akpm@linux-foundation.org>
References: <20071107161853.044b6e8f.akpm@linux-foundation.org>
	<18226.27701.782268.375231@cargo.ozlabs.ibm.com>
	<20071107190714.9c404e28.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 7 Nov 2007 19:07:14 -0800

> It appears that glibc treats all of 0x80000000-0xffffffff as an
> error.

glibc treats it as an error if the system call returns with
the carry condition code set.  At least that's how I've
understood it to work and at a minimum this is how it works
on sparc, ppc, ia64, mips, etc.

The error indication is being created by the system call return path
in the kernel.  It tests for values between -512 and 0, and marks
those as errors unless force_successful_syscall() has been called.

I can't see where x86 is doing this though, so perhaps for x86
glibc does make the negative value check.  But I doubt it is
checking the range 0x80000000-0xffffffff, otherwise mmap() would
be busted.

