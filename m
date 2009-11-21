Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbZKUXg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbZKUXg5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 18:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZKUXg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 18:36:56 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55726 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbZKUXgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 18:36:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Skxri+q42l3qzfMelocLHgnhb7MiylvI8BFr28CCBchDdL3XD5U8/4fjeZxiZd8Ljp
         0T8SJmqF5G0vyhO5wnFmVO0KZWRm2UvsL541RdcZhTLf9DRIrRjVBdKePVlXuylGzb43
         bvRlcERB0SjZY5KCXvWYB+FgkH63xklpC+aMo=
Date: Sun, 22 Nov 2009 02:36:59 +0300
From: Ilya Loginov <isloginov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Peter Horton <phorton@bitbox.co.uk>,
       "Ed L. Cashin" <ecashin@coraid.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] mtd: fix mtd_blkdevs problem with caches on some
 architectures (2.6.31)
Message-Id: <20091122023659.a9cf6980.isloginov@gmail.com>
In-Reply-To: <20091121152633.8c79e341.akpm@linux-foundation.org>
References: <20091118170810.2bb9cd54.isloginov@gmail.com>
	<20091120163751.731781e8.akpm@linux-foundation.org>
	<20091121170437.0839daef.isloginov@gmail.com>
	<20091121095429.1378828c.akpm@linux-foundation.org>
	<20091122021128.db47e202.isloginov@gmail.com>
	<20091121152633.8c79e341.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And then, in a .c file:
> 
> #ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
> #error "you lose"
> #endif
> 
> and, of course:
> 
> #if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
> <implement real code>
> #else
> <implement empty stubs>
> #endif
> 
> 
> This way
> 
> a) the definition site for ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE is
>    right next to the definition site for flush_dcache_page(), instead
>    of being in some random remote file and
> 
> b) people can't forget to implement ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE.
> 
> 
> Generally we prefer to avoid defining ARCH_HAS_FOO in header files and
> we prefer to control the definition in Kconfig.  But it sounds like we
> have a special case here..
> 

I agree. I think this is the best way. I will rewrite the patch.
Thank you!

-- 
Ilya Loginov <isloginov@gmail.com>
