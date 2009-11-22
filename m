Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbZKVStv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbZKVStv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 13:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbZKVStu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 13:49:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:44869 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZKVStt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 13:49:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=qJyTTtbpn3EF2EAFVoPdEyWRZeEVDEYQbdEsr8pt4eoZnJFiZfbwgB6xgRYVrFaN+T
         3mVmp9YTIzR+HoVjc9ODe/JbHQ6iFVK7XARWZLuu+TiZnxu78/uy2t1cmDaRsa/YAOe2
         ltSDi6LJOKBpflIGxe6oqrGjWbqZX+hh/Lty0=
Date: Sun, 22 Nov 2009 21:49:49 +0300
From: Ilya Loginov <isloginov@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Horton <phorton@bitbox.co.uk>,
       "Ed L. Cashin" <ecashin@coraid.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] mtd: fix mtd_blkdevs problem with caches on some
 architectures (2.6.31)
Message-Id: <20091122214949.e1ffa058.isloginov@gmail.com>
In-Reply-To: <1258883630.1127.45.camel@macbook.infradead.org>
References: <20091118170810.2bb9cd54.isloginov@gmail.com>
	<20091120163751.731781e8.akpm@linux-foundation.org>
	<20091121170437.0839daef.isloginov@gmail.com>
	<20091121095429.1378828c.akpm@linux-foundation.org>
	<20091122021128.db47e202.isloginov@gmail.com>
	<20091121152633.8c79e341.akpm@linux-foundation.org>
	<20091122124631.908a32c4.isloginov@gmail.com>
	<1258883630.1127.45.camel@macbook.infradead.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Nov 2009 09:53:50 +0000
David Woodhouse <dwmw2@infradead.org> wrote:

> The thing is, having a function called flush_dcache_page() which doesn't
> actually flush a page of the dcache is just blatantly stupid.

Unfortunately, it's well-established that all architectures have these 
functions. Many kernel systems, for example file systems drivers (ext2,
ext3, ntfs), use them.

In letter to Andrew Morton I wrote that among 20 architectures this call
is not empty only for 8 of them. And it is the problem.

But some architectures really need this call. And kernel has to work
reasonably with them too. Therefore it is required often to call for
empty functions.
 
> It's misnamed -- it should probably be called something like
> 'flush_valiased_dcache_page()' or 'unalias_dcache_page()' instead, since
> I believe it's only supposed to cope with aliasing issues with virtually
> indexed caches.

I don't think so. For example I had this bug on the processor, which 
icache don't finds for data in dcache. There was no dcache aliases.
 
> If you're talking about _extending_ the existing silly name to a new
> ARCH_IMPLEMENTS_FOO macro or Kconfig option, perhaps this would be a
> good time to fix the nomenclature, rather than propagating the error?

Andrew has showed me in his first letter another topic in this mailing.
It is said there that there is no reasonable infrastructure in kernel to
correct such things. The first patch can fix bug in the mtd but the 
problem of useless cycle on many architectures is arising. 

It is because there is nothing associated with the flush_dcache_page()
function. 

This way enable us to solve and this problem too. But I agree that it
is not elegant. Have you any idea how to make it better?

Thanks!

-- 
Ilya Loginov <isloginov@gmail.com>
