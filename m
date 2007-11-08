Return-Path: <linux-kernel-owner+w=401wt.eu-S1760748AbXKHHJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760748AbXKHHJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 02:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756778AbXKHHJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 02:09:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49771 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756458AbXKHHJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 02:09:51 -0500
Date: Wed, 7 Nov 2007 23:09:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, lkml@davidb.org, linux-kernel@vger.kernel.org,
       drepper@redhat.com, mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
Message-Id: <20071107230916.fa301e5a.akpm@linux-foundation.org>
In-Reply-To: <20071107.222530.156152513.davem@davemloft.net>
References: <20071107190714.9c404e28.akpm@linux-foundation.org>
	<18226.38816.486372.52353@cargo.ozlabs.ibm.com>
	<20071107212005.f039c279.akpm@linux-foundation.org>
	<20071107.222530.156152513.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 07 Nov 2007 22:25:30 -0800 (PST) David Miller <davem@davemloft.net> wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Wed, 7 Nov 2007 21:20:05 -0800
> 
> > Yup.  But userspace will already have a fit if either the start or end time
> > advanced into the glibc-thought-that-was-an-error range.
> 
> On x86 only.  We could use force_successful_syscall_return()
> to make sure the condition codes get set correctly on
> other platforms.
> 
> But even in that case we'd still be broken when the return
> value is exactly -1 and that's what the application is going
> to compare against to test for errors.

I don't think that's a big problem?  This syscall can (oddly) return any
32-bit (64-bit) number and a smart application developer (after saying wtf)
would realise that he just can't check for errors and have correctly
working code.

Then again, if he was smart he just wouldn't use times(2)'s return value
for anything.  But what is the alternative?  I don't think there is one,
apart from much saner things like gettimeofday().

