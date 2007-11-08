Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbXKHFQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbXKHFQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 00:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbXKHFP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 00:15:58 -0500
Received: from ozlabs.org ([203.10.76.45]:32968 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbXKHFP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 00:15:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18226.39815.631891.784259@cargo.ozlabs.ibm.com>
Date: Thu, 8 Nov 2007 16:15:51 +1100
From: Paul Mackerras <paulus@samba.org>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, lkml@davidb.org, linux-kernel@vger.kernel.org,
       drepper@redhat.com, mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
In-Reply-To: <20071107.191354.115487072.davem@davemloft.net>
References: <20071107161853.044b6e8f.akpm@linux-foundation.org>
	<18226.27701.782268.375231@cargo.ozlabs.ibm.com>
	<20071107190714.9c404e28.akpm@linux-foundation.org>
	<20071107.191354.115487072.davem@davemloft.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:

> I can't see where x86 is doing this though, so perhaps for x86
> glibc does make the negative value check.  But I doubt it is
> checking the range 0x80000000-0xffffffff, otherwise mmap() would
> be busted.

At least for the INTERNAL_SYSCALL macro in glibc, the error check is:

#define INTERNAL_SYSCALL_ERROR_P(val, err) \
  ((unsigned int) (val) >= 0xfffff001u)

in sysdeps/unix/sysv/linux/i386/sysdep.h.  Similarly the PSEUDO macro
in that file does a cmpl $-4095,%eax to test for error.  (There is also
a PSEUDO_NOERRNO which doesn't test for error.)

So the convention on (32-bit) x86 is that -4095 .. -1 are error
values, and other values are successful return values.

Paul.
