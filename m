Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbZKVTSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbZKVTSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 14:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZKVTSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 14:18:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39077 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbZKVTSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 14:18:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=mg8U9bYEUl3LvbVaenMhHgb/FKiK+tfe91tvKrtL7nTkjXrI5FwUQkXB0IjklCQMGC
         NPXmDqNeax7LB+Dj4KKaHt+21yexga/ISG/JCTrCh3yq/nJJItqy7WjT/4p11ZbCJd50
         NlI1NLpmd6EXFPbCaFWHqnuqOGPFx7/U0NGbU=
Date: Sun, 22 Nov 2009 22:18:36 +0300
From: Ilya Loginov <isloginov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Peter Horton <phorton@bitbox.co.uk>,
       "Ed L. Cashin" <ecashin@coraid.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] mtd: fix mtd_blkdevs problem with caches on some
 architectures (2.6.31)
Message-Id: <20091122221836.d2d7535d.isloginov@gmail.com>
In-Reply-To: <20091122104816.b6920ede.akpm@linux-foundation.org>
References: <20091118170810.2bb9cd54.isloginov@gmail.com>
	<20091120163751.731781e8.akpm@linux-foundation.org>
	<20091121170437.0839daef.isloginov@gmail.com>
	<20091121095429.1378828c.akpm@linux-foundation.org>
	<20091122021128.db47e202.isloginov@gmail.com>
	<20091121152633.8c79e341.akpm@linux-foundation.org>
	<20091122124631.908a32c4.isloginov@gmail.com>
	<20091122132915.GA3046@elte.hu>
	<20091122165521.0b488e05.isloginov@gmail.com>
	<20091122104816.b6920ede.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Nov 2009 10:48:16 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> I don't think the non-stub versions of these should be inlined.  They
> will generate quite a lot of code and they're pretty heavyweight.
> Better to implement them in block/ somewhere, and EXPORT_SYMBOL().

I tried this way from the beginning, and to avoid redefinitions I enclose
everything in #if #endif in *.c files. I think it is not very good.
So there are two possibilities.

1. To keep it like it is now and in this way there will be quite a lot of code.
But in previous letters I gave statistics on the flush_dcache_page call in a
kernel. And our case is particular. There will not be generated a lot of code.
Or just take away inline.

2. Or it is better to carry over normal realization to *.c file and enclose
everything by one more #if #endif.

What do you consier to be better?

-- 
Ilya Loginov <isloginov@gmail.com>
