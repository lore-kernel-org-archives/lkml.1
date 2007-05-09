Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbXEIWTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbXEIWTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759085AbXEIWTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:19:23 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758570AbXEIWTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:19:22 -0400
Date: Wed, 9 May 2007 15:18:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, suparna@in.ibm.com,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: aio is unlikely
Message-Id: <20070509151831.f5956b66.akpm@linux-foundation.org>
In-Reply-To: <46424602.3090404@garzik.org>
References: <200705092101.l49L1CF1023363@hera.kernel.org>
	<46424602.3090404@garzik.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 May 2007 18:06:58 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> > -#define in_aio() !is_sync_wait(current->io_wait)
> > +#define in_aio() (unlikely(!is_sync_wait(current->io_wait)))
> 
> Please revert.  Workload-dependent "likelihood" should not cause 
> programmers to add such markers.
> 
> This is a common misunderstanding about unlikely() and likely().  The 
> branch prediction used for each assumes 99% unlikely or 99% likely, 
> which is not true at all for workload-dependent code.
> 
> Even if only 1% of Linux users use AIO, for that 1%, the 'unlikely' 
> marker causes repeated branch mispredictions.
> 
> likely() and unlikely() should be used for cases where code is 
> likely/unlikely for EVERYBODY.

a) disagree with the above

b) if in_aio() ever returns true we do

	printk(KERN_ERR "%s(%s:%d) called in async context!\n",
		__FUNCTION__, __FILE__, __LINE__);

   so I sure hope it's unlikely for all workloads.
	
