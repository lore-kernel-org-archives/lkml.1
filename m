Return-Path: <linux-kernel-owner+w=401wt.eu-S1763926AbXIXRCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763926AbXIXRCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757574AbXIXRCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:02:31 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48430 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbXIXRCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:02:30 -0400
Date: Mon, 24 Sep 2007 13:02:20 -0400
From: Jeff Dike <jdike@addtoit.com>
To: lepton <ytht.net@gmail.com>
Cc: lkm <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.6.22.6 user-mode linux: use address instead of value as argument in os_free_irq_by_cb
Message-ID: <20070924170220.GE23078@c2.user-mode-linux.org>
References: <20070922043955.GA4550@router.lepton.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070922043955.GA4550@router.lepton.home>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 12:39:55PM +0800, lepton wrote:
>   There is a bug in os_free_irq_by_cb, when the first element
>   of active_fds list  is free, the value of active_fds is not
>   updated, just value in stack is updated.

Man, that sucks.

Nice spotting.

> 
>   The intresting thing is that without this patch, a poweroff
>   in user mode linux guest will halt the host linux system.It
>   seems that after the tracing thread is dead, the syscall to
>   sys_reboot of the traced thread is executed by host. I don't
>   know if it is another bug.

I would say that you shouldn't be running UMLs as root.  However, a
sys_reboot shouldn't escape being ptraced either.  This is a bug, but
I don't see any connection between it and ptrace missing a final
system call.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
