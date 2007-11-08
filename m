Return-Path: <linux-kernel-owner+w=401wt.eu-S1759846AbXKHBOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759846AbXKHBOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 20:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbXKHBOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 20:14:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59751 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754281AbXKHBOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 20:14:44 -0500
Date: Wed, 7 Nov 2007 17:13:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: lkml@davidb.org, linux-kernel@vger.kernel.org, drepper@redhat.com,
       mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
Message-Id: <20071107171344.a9f0e955.akpm@linux-foundation.org>
In-Reply-To: <20071107.165022.69369307.davem@davemloft.net>
References: <20071107224722.GA20204@old.davidb.org>
	<20071107152833.6f302c2a.akpm@linux-foundation.org>
	<20071107.165022.69369307.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 07 Nov 2007 16:50:22 -0800 (PST) David Miller <davem@davemloft.net> wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Wed, 7 Nov 2007 15:28:33 -0800
> 
> > Perhaps this is a bug in glibc: it is interpreting the times() return value
> > in the same way as other syscalls.
> 
> The problem is more likely that we are failing to
> invoke force_successful_syscall_return() here.
> 
> Otherwise the syscall return path interprets negative
> values as errors, and sets the cpu condition codes.
> 
> And that is what userspace is actually checking for
> to determine if there is an error or not.

hm, I'd forgotten about that.

It seems to be a no-op on lots of architectures?
