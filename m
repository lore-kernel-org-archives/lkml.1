Return-Path: <linux-kernel-owner+w=401wt.eu-S1759130AbXKHAub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130AbXKHAub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 19:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbXKHAuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 19:50:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40408
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754253AbXKHAuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 19:50:23 -0500
Date: Wed, 07 Nov 2007 16:50:22 -0800 (PST)
Message-Id: <20071107.165022.69369307.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: lkml@davidb.org, linux-kernel@vger.kernel.org, drepper@redhat.com,
       mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071107152833.6f302c2a.akpm@linux-foundation.org>
References: <20071107224722.GA20204@old.davidb.org>
	<20071107152833.6f302c2a.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 7 Nov 2007 15:28:33 -0800

> Perhaps this is a bug in glibc: it is interpreting the times() return value
> in the same way as other syscalls.

The problem is more likely that we are failing to
invoke force_successful_syscall_return() here.

Otherwise the syscall return path interprets negative
values as errors, and sets the cpu condition codes.

And that is what userspace is actually checking for
to determine if there is an error or not.
