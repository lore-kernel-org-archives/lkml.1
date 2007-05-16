Return-Path: <linux-kernel-owner+w=401wt.eu-S1761365AbXEPTSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761365AbXEPTSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759293AbXEPTRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:17:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45452 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759072AbXEPTRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:17:54 -0400
Date: Wed, 16 May 2007 12:15:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: zilvinas@wilibox.com
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: Kernel NFS lockd freezes notebook on shutdown (Linux 2.6.22-rc1
 + CFS v12)
Message-Id: <20070516121538.7b108c10.akpm@linux-foundation.org>
In-Reply-To: <1179338441.4265.13.camel@zv.wilibox.com>
References: <1179338441.4265.13.camel@zv.wilibox.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 21:00:41 +0300
Zilvinas Valinskas <zilvinas@wilibox.com> wrote:

> Hello, 
> 
> In short, on shutdown my laptop is always freezing now. I was able to
> capture the 'sysrq-P' (hit that several times), sysrq-T outputs. Please
> see .config and log messages at http://barclay.balt.net/~zilvinas/oops/ 
> 
> Kernel version I had built according git is :
> 
> zilvinas@zv:/projects/linux-amd64.git$ git describe HEAD
> v2.6.22-rc1-29-gfaa8b6c
> 
> On top of that I have CFS v12 applied (no other changes otherwise).
> Please note that there is ''fglrx.ko'' loaded and kernel is tainted
> because of that (feel free to ignore the report ...).
> 
> Anyway, 'sysrq-P' always show that PC is stuck at (NFS lockd?) and it is
> always the same backtrace is shown. 'sysrq-t' output is in
> 'kernel-nfs-freeze.log' file (did not want to post it here).
> 
>  Pid: 3652, comm: lockd Tainted: P       2.6.22-rc1-cfs-v12 #1
> 
> [<ffffffff8024a5a0>] wq_barrier_func+0x0/0x10
> [<ffffffff8024a7e5>] destroy_workqueue+0x75/0xa0
> [<ffffffff8833cd34>] :sunrpc:rpciod_down+0xf4/0x170
> [<ffffffff8836dd74>] :lockd:lockd+0x244/0x300
> [<ffffffff80233e1f>] schedule_tail+0x3f/0xb0
> [<ffffffff8020b0f8>] child_rip+0xa/0x12
> [<ffffffff8836db30>] :lockd:lockd+0x0/0x300
> [<ffffffff8836db30>] :lockd:lockd+0x0/0x300
> [<ffffffff8020b0ee>] child_rip+0x0/0x12
> 
> Hope this helps. Thanks in advance for any advice how to solve problem !
> For now I am back to '2.6.21.1-cfs-v10'.
> 

Thanks for the report.   I'm thinking "Oleg".
