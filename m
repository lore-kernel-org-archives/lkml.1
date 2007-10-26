Return-Path: <linux-kernel-owner+w=401wt.eu-S1765036AbXJZVtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765036AbXJZVtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbXJZVt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:49:28 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53222 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbXJZVt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:49:27 -0400
Date: Fri, 26 Oct 2007 17:49:10 -0400
From: Jeff Dike <jdike@addtoit.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Fix linux/swap.h build wart
Message-ID: <20071026214910.GA11112@c2.user-mode-linux.org>
References: <20071026192548.GA9174@c2.user-mode-linux.org> <617E1C2C70743745A92448908E030B2A02C9D4B6@scsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <617E1C2C70743745A92448908E030B2A02C9D4B6@scsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 01:38:12PM -0700, Luck, Tony wrote:
> Not fundamental reasons, but these patches break the ia64 build for most
> configs with:
> 
> In file included from kernel/futex.c:59:
> include/asm/futex.h: In function `futex_atomic_op_inuser':
> include/asm/futex.h:62: error: implicit declaration of function `pagefault_disable'
> include/asm/futex.h:86: error: implicit declaration of function `pagefault_enable'
> make[1]: *** [kernel/futex.o] Error 1
> 
> Adding an include of <linux/uaccess.h> to kernel/futex.c is sufficient (but
> not necessarily right) to unbreak this.

Yeah, I've been changing <asm/uaccess.h> to <linux/uaccess.h> for
these.  Looks like I'll need to make a pass over all the futex.h's.

> A few configs also fail with:
> mm/migrate.c: In function `migrate_page_copy':
> mm/migrate.c:359: error: implicit declaration of function `copy_highpage'
> make[1]: *** [mm/migrate.o] Error 1
> 
> Making mm/migrate.c include <linux/highmem.h> fixes this one.

Excellent, I hadn't yet figured out who used migrate.c.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
