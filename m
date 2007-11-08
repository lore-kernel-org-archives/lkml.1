Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbXKHFUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbXKHFUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 00:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbXKHFUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 00:20:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51757 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788AbXKHFUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 00:20:36 -0500
Date: Wed, 7 Nov 2007 21:20:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: lkml@davidb.org, linux-kernel@vger.kernel.org, drepper@redhat.com,
       mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
Message-Id: <20071107212005.f039c279.akpm@linux-foundation.org>
In-Reply-To: <18226.38816.486372.52353@cargo.ozlabs.ibm.com>
References: <20071107224722.GA20204@old.davidb.org>
	<20071107152833.6f302c2a.akpm@linux-foundation.org>
	<20071107161853.044b6e8f.akpm@linux-foundation.org>
	<18226.27701.782268.375231@cargo.ozlabs.ibm.com>
	<20071107190714.9c404e28.akpm@linux-foundation.org>
	<18226.38816.486372.52353@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 8 Nov 2007 15:59:12 +1100 Paul Mackerras <paulus@samba.org> wrote:
> Andrew Morton writes:
> 
> > "the latter" is what my protopatch does isn't it?  It wraps at 0x7fffffff.
> > It appears that glibc treats all of 0x80000000-0xffffffff as an error.
> 
> Not on powerpc.  On powerpc the error indication is carried separately
> in a condition register bit.  So a force_successful_syscall_return()
> call will make glibc automatically do the right thing without any
> glibc changes on powerpc.

OK

> Wrapping at 0x7fffffff will cause programs to see large negative
> deltas between successive calls when the wrap occurs.  I can see that
> giving userspace fits. :)
> 

Yup.  But userspace will already have a fit if either the start or end time
advanced into the glibc-thought-that-was-an-error range.

