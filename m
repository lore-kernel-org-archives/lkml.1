Return-Path: <linux-kernel-owner+w=401wt.eu-S1422634AbXBUPsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422634AbXBUPsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161296AbXBUPsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:48:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:34320 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161297AbXBUPsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:48:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=G5YpfIQgs4x5SRLQ6+n2FdkRHvcSHUusxIP3BIkegmXkZj1KMmqVUaqgjOypRdcp70p5k484vT7mNdp1GGxUEaHXvJkWhVJVg2/C8YIUqIj4P0gRTWzgjy6+hYaOoiccr7YXVJXGXPVG6mjNcTsChwTFwQb8/hmgc10Lt1rLJQU=
Message-ID: <84144f020702210747t50d7d92ei1a2f5da8bf117d40@mail.gmail.com>
Date: Wed, 21 Feb 2007 17:47:59 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 08/29] mm: kmem_cache_objs_to_pages()
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Thomas Graf" <tgraf@suug.ch>, "David Miller" <davem@davemloft.net>
In-Reply-To: <20070221144842.299190000@taijtu.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221144304.512721000@taijtu.programming.kicks-ass.net>
	 <20070221144842.299190000@taijtu.programming.kicks-ass.net>
X-Google-Sender-Auth: dfbc172d11f0cbca
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 2/21/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Provide a method to calculate the number of pages needed to store a given
> number of slab objects (upper bound when considering possible partial and
> free slabs).

So how does this work? You ask the slab allocator how many pages you
need for a given number of objects and then those pages are available
to it via the page allocator? Can other users also dip into those
reserves?

I would prefer we simply have an API for telling the slab allocator to
keep certain number of pages in a reserve for a cache rather than
exposing internals such as object size to rest of the world.

                                 Pekka
