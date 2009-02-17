Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbZBQRDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbZBQRDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbZBQRDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:03:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:29806 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbZBQRDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:03:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rA+p/9isupOR7duay1uFCJ67vTvwccm6iO25fOVrvV2hwrxV+K7FGqgS9atQQzD6zl
         eQ7/FfRMjDfr0qYcLqIFmI1cWTPJAuE/06TOO1wky9b627bGEe9AM598WqdkXZ8AmVQL
         YeKuiCBWb0OtS1CXx6/OfgpUzYupN7W2nfGuU=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0902171115010.29986@qirst.com>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name>
	 <20090212104349.GA13859@gondor.apana.org.au>
	 <1234435521.28812.165.camel@penberg-laptop>
	 <20090212105034.GC13859@gondor.apana.org.au>
	 <1234454104.28812.175.camel@penberg-laptop>
	 <20090215133638.5ef517ac.akpm@linux-foundation.org>
	 <1234734194.5669.176.camel@calx>
	 <20090215135555.688ae1a3.akpm@linux-foundation.org>
	 <1234741781.5669.204.camel@calx>
	 <alpine.DEB.1.10.0902171115010.29986@qirst.com>
Date: Tue, 17 Feb 2009 19:03:28 +0200
X-Google-Sender-Auth: 42f3a38704f2b959
Message-ID: <84144f020902170903g5756cf4cy57f98cd5955ff2e3@mail.gmail.com>
Subject: Re: [PATCH] Export symbol ksize()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-crypto@vger.kernel.org, Geert.Uytterhoeven@sonycom.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 6:17 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Sun, 15 Feb 2009, Matt Mackall wrote:
>
>> And it -is- a category error. The fact that kmalloc is implemented on
>> top of kmem_cache_alloc is an implementation detail that callers should
>> not assume. They shouldn't call kfree() on kmem_cache_alloc objects
>> (even though it might just happen to work), nor should they call
>> ksize().
>
> ksize does not take a kmem_cache pointer and it is mainly used for
> figuring out how much space kmalloc really allocated for an object. As
> such its more part of the kmalloc/kfree set of calls than the
> kmem_cache_* calls.
>
> We could add another call
>
>        kmem_cache_size()
>
> for symmetries sake.

Hmm, kmem_cache_size() seems bit pointless to me. For
kmem_cache_create()'d caches, actual allocated size should be more or
less optimal with no extra space.

                                     Pekka
