Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbYILV55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbYILV55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbYILV5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 17:57:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53873
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755626AbYILV5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 17:57:48 -0400
Date: Fri, 12 Sep 2008 14:57:41 -0700 (PDT)
Message-Id: <20080912.145741.59974282.davem@davemloft.net>
To: rmk+lkml@arm.linux.org.uk
Cc: roland@redhat.com, linux-arch@vger.kernel.org, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: CONFIG_HAVE_ARCH_TRACEHOOK and you
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080912131351.GA31545@flint.arm.linux.org.uk>
References: <20080912025733.E55F415420D@magilla.localdomain>
	<20080912131351.GA31545@flint.arm.linux.org.uk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+lkml@arm.linux.org.uk>
Date: Fri, 12 Sep 2008 14:13:51 +0100

> However, in looking at other architectures, I notice that sparc does this
> when initializing its regsets:
> 
>                 .n = 38 * sizeof(u32),
>                 .size = sizeof(u32), .align = sizeof(u32),
> 
> and sparc64:
> 
>                 .n = 36 * sizeof(u64),
>                 .size = sizeof(u64), .align = sizeof(u64),
> 
> which, given that fs/binfmt_elf.c does this:
> 
>                         size_t size = regset->n * regset->size;
>                         void *data = kmalloc(size, GFP_KERNEL);
>                         if (unlikely(!data))
>                                 return 0;
> 
> means sparc ends up allocating 38 * sizeof(u32) * sizeof(u32), and
> sparc64 ends up with 36 * sizeof(u64) * sizeof(u64), which must surely
> be wrong?

Yep, definitely a bug, good catch.  I guess, better to allocate
too much by accident rather than too little in this case :-)

I'll fix this up, thanks!

