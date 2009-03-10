Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbZCJQLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbZCJQLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbZCJQLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:11:37 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:54326 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991AbZCJQLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:11:36 -0400
Date: Tue, 10 Mar 2009 17:08:41 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
       linux-next@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Greg Banks <gnb@sgi.com>, Herbert Xu <herbert@gondor.apana.org.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: driver-core tree build failure
Message-ID: <20090310170841.2257de86@skybase>
In-Reply-To: <alpine.LRH.2.00.0903101626450.25436@vixen.sonytel.be>
References: <20090310192440.949884a1.sfr@canb.auug.org.au>
	<alpine.LRH.2.00.0903101423200.25436@vixen.sonytel.be>
	<20090310145311.6bf9d9e9@skybase>
	<alpine.LRH.2.00.0903101626450.25436@vixen.sonytel.be>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009 16:29:50 +0100 (CET)
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> > The same could be done with the problematic pr_fmt definition:
> > 
> > #define pr_fmt(fmt)     __func__ ": " fmt
> 
> No, that also doesn't work:
> 
> | crypto/zlib.c:150: error: expected '}' before string constant
> | crypto/zlib.c:150: error: expected ')' before '__func__'
> | crypto/zlib.c:162: error: expected '}' before string constant
> | crypto/zlib.c:162: error: expected ')' before '__func__'
> | crypto/zlib.c:166: error: expected '}' before string constant
> | crypto/zlib.c:166: error: expected ')' before '__func__'
> | crypto/zlib.c:170: error: expected '}' before string constant
> | crypto/zlib.c:170: error: expected ')' before '__func__'
> 
> > > BTW, Martin: Is `#define pr_fmt(fmt)     "%s: " fmt, __func__' a valid and
> > > intended usage of your pr_fmt() infrastructure?
> > 
> > The indended use is a simple prefix to the format string. To paste an
> > additional parameter is an interesting use of the pr_fmt macro ..
> 
> Bummer, I was so happy I could do things like
> 
> | #define pr_fmt(fmt)	"%s:%u: " fmt, __func__, __LINE__

Actually that seem like a nice thing to have. With the upstream version of
dynamic_pr_debug this works, there the format string is used only on a printk.
git commit 25b67b75587d43ff3f09ad88c03c70a38372d95d introduces the code
that pastes the format string to the _ddebug structure.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

