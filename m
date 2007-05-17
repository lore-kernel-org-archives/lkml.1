Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbXEQSqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbXEQSqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbXEQSqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:46:12 -0400
Received: from mail.screens.ru ([213.234.233.54]:50309 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752AbXEQSqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:46:11 -0400
Date: Thu, 17 May 2007 22:45:56 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Zilvinas Valinskas <zilvinas@wilibox.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Kernel NFS lockd freezes notebook on shutdown (Linux 2.6.22-rc1 + CFS v12)
Message-ID: <20070517184556.GA81@tv-sign.ru>
References: <1179338441.4265.13.camel@zv.wilibox.com> <20070516121538.7b108c10.akpm@linux-foundation.org> <20070516225543.GA337@tv-sign.ru> <1179390065.4760.5.camel@zv.wilibox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179390065.4760.5.camel@zv.wilibox.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Zilvinas,

On 05/17, Zilvinas Valinskas wrote:
> 
> Patch seems to help and it seems kernel doesn't free anymore. I've
> booted new kernel and did :

OK, thank you very much. So, we have some other problems, and I _think_
that workqueue.c is not the source of them.

However, I can't understand why cleanup_workqueue_thread() hangs anyway.
It shouldn't. Looks like rpciod/1 was preempted, and can't get CPU. According
to kernel-nfs-freeze.log it is TASK_RUNNING. Strange.

It is very sad, because this code was supposed to be cleanuped anyway,
but if it is really buggy, it would be great to know why.

Perhaps, we can understand the problem with your help. Could you please
revert the patch I sent, and send me (privately) the output of

	objdump -d kernel/workqueue.o

? I doubt very much I'll see something interesting, but who knows...

Thanks!

Oleg.

