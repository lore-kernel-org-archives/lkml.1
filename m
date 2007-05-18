Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbXERIj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbXERIj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 04:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbXERIjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 04:39:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45864 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbXERIjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 04:39:19 -0400
Date: Fri, 18 May 2007 09:38:35 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, dedekind@infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ubi: kill homegrown endian macros
Message-ID: <20070518083835.GX4095@ftp.linux.org.uk>
References: <20070517143200.GA30850@lst.de> <1179413443.3642.49.camel@sauron> <20070517145653.GA968@lst.de> <1179414590.3642.69.camel@sauron> <20070517102931.6bbbad1a.akpm@linux-foundation.org> <20070517204234.GR4095@ftp.linux.org.uk> <20070517205339.GS4095@ftp.linux.org.uk> <464D4E91.1000000@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464D4E91.1000000@yandex.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 09:58:25AM +0300, Artem Bityutskiy wrote:
> Al Viro wrote:
> >BTW, you can simply typedef __be16 ubi16_t; etc. and define conversion
> >functions as cpu_to_ubi16(x) being (__force ubi16_t)cpu_to_be16(x), etc.
> >
> >sparse will do all checks just fine, you still have bitwise operations
> >(might or might be not relevant in your case) and for gcc it simply
> >becomes __be16, etc - i.e. an integer type.
> 
> Err, what is the benefit of it? If we relied on sparce, why not would we be
> just using __be16 directly?

Because you might legitimately want your type to be *not* mixed with whatever
other big-endian 16bit types you have out there?
