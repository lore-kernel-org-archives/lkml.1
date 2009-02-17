Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbZBQQYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbZBQQYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 11:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZBQQYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 11:24:41 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:43508 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751640AbZBQQYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 11:24:40 -0500
Date: Tue, 17 Feb 2009 11:17:19 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Matt Mackall <mpm@selenic.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-crypto@vger.kernel.org, Geert.Uytterhoeven@sonycom.com
Subject: Re: [PATCH] Export symbol ksize()
In-Reply-To: <1234741781.5669.204.camel@calx>
Message-ID: <alpine.DEB.1.10.0902171115010.29986@qirst.com>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name>  <84144f020902100535i4d626a9fj8cbb305120cf332a@mail.gmail.com>  <20090210134651.GA5115@epbyminw8406h.minsk.epam.com>  <Pine.LNX.4.64.0902101605070.20991@melkki.cs.Helsinki.FI> 
 <20090212104349.GA13859@gondor.apana.org.au>  <1234435521.28812.165.camel@penberg-laptop>  <20090212105034.GC13859@gondor.apana.org.au>  <1234454104.28812.175.camel@penberg-laptop>  <20090215133638.5ef517ac.akpm@linux-foundation.org>  <1234734194.5669.176.camel@calx>
  <20090215135555.688ae1a3.akpm@linux-foundation.org> <1234741781.5669.204.camel@calx>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Feb 2009, Matt Mackall wrote:

> And it -is- a category error. The fact that kmalloc is implemented on
> top of kmem_cache_alloc is an implementation detail that callers should
> not assume. They shouldn't call kfree() on kmem_cache_alloc objects
> (even though it might just happen to work), nor should they call
> ksize().

ksize does not take a kmem_cache pointer and it is mainly used for
figuring out how much space kmalloc really allocated for an object. As
such its more part of the kmalloc/kfree set of calls than the
kmem_cache_* calls.

We could add another call

	kmem_cache_size()

for symmetries sake.


