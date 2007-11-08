Return-Path: <linux-kernel-owner+w=401wt.eu-S1759116AbXKHE72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116AbXKHE72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 23:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbXKHE7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 23:59:20 -0500
Received: from ozlabs.org ([203.10.76.45]:45498 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbXKHE7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 23:59:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18226.38816.486372.52353@cargo.ozlabs.ibm.com>
Date: Thu, 8 Nov 2007 15:59:12 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml@davidb.org, linux-kernel@vger.kernel.org, drepper@redhat.com,
       mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
In-Reply-To: <20071107190714.9c404e28.akpm@linux-foundation.org>
References: <20071107224722.GA20204@old.davidb.org>
	<20071107152833.6f302c2a.akpm@linux-foundation.org>
	<20071107161853.044b6e8f.akpm@linux-foundation.org>
	<18226.27701.782268.375231@cargo.ozlabs.ibm.com>
	<20071107190714.9c404e28.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> "the latter" is what my protopatch does isn't it?  It wraps at 0x7fffffff.
> It appears that glibc treats all of 0x80000000-0xffffffff as an error.

Not on powerpc.  On powerpc the error indication is carried separately
in a condition register bit.  So a force_successful_syscall_return()
call will make glibc automatically do the right thing without any
glibc changes on powerpc.

Wrapping at 0x7fffffff will cause programs to see large negative
deltas between successive calls when the wrap occurs.  I can see that
giving userspace fits. :)

Paul.

