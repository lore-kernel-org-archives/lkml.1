Return-Path: <linux-kernel-owner+w=401wt.eu-S1759438AbZJMKiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbZJMKiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759424AbZJMKiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:38:03 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:41793 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483AbZJMKiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:38:01 -0400
Subject: Re: [patch 13/28] s390: Remove BKL from prng
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <20091010153349.601625576@linutronix.de>
References: <20091010153314.827301943@linutronix.de>
	 <20091010153349.601625576@linutronix.de>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 12:36:14 +0000
Message-Id: <1255437374.10239.545.camel@bender>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-10 at 15:36 +0000, Thomas Gleixner wrote:
> einfaches Textdokument attachment (s390-remove-bkl-from-prng.patch)
> cycle_kernel_lock() was added during the big BKL pushdown. It should
> ensure the serializiation against driver init code. In this case there
> is nothing to serialize. Remove it.

Looks good.
Acked-by: Jan Glauber <jang.linux.vnet.ibm.com>

-- Jan

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  arch/s390/crypto/prng.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> Index: linux-2.6-tip/arch/s390/crypto/prng.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/s390/crypto/prng.c
> +++ linux-2.6-tip/arch/s390/crypto/prng.c
> @@ -6,7 +6,6 @@
>  #include <linux/fs.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> -#include <linux/smp_lock.h>
>  #include <linux/miscdevice.h>
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
> @@ -49,7 +48,6 @@ static unsigned char parm_block[32] = {
>  
>  static int prng_open(struct inode *inode, struct file *file)
>  {
> -	cycle_kernel_lock();
>  	return nonseekable_open(inode, file);
>  }
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

