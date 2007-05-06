Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbXEFTqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbXEFTqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 15:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbXEFTqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 15:46:45 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:53597 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbXEFTqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 15:46:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U6rL26VofN+x3dIpjOa0JZaHK9i6BpJ0zM6hOaNeG5l0WgcBHKrY/lo5qx2iW5cUPJu1U+RgfG8+cN6w3gpMIEf0Xzg6i6jGgV7eCkDRNnlnZQ7TBzWh7LKoAJdf37lMWyW9bqXvAn25tECSrg3koEp+712OKB2fczKQI6Vy/rU=
Message-ID: <a781481a0705061246y10568c25h8d82233dbc43ce5c@mail.gmail.com>
Date: Mon, 7 May 2007 01:16:42 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Bert Wesarg" <wesarg@informatik.uni-halle.de>
Subject: Re: [RFC 1/3] SLUB: slab_ops instead of constructors / destructors
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       dgc@sgi.com, "Eric Dumazet" <dada1@cosmosbay.com>,
       "Mel Gorman" <mel@csn.ul.ie>
In-Reply-To: <463E2A37.2030400@informatik.uni-halle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070504221555.642061626@sgi.com>
	 <20070504221708.363027097@sgi.com>
	 <463E2A37.2030400@informatik.uni-halle.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/07, Bert Wesarg <wesarg@informatik.uni-halle.de> wrote:
> clameter@sgi.com wrote:
> > +     if (ctor || dtor) {
> > +             so = kzalloc(sizeof(struct slab_ops), GFP_KERNEL);
> > +             so->ctor = ctor;
> > +             so->dtor = dtor;
> > +     }
> > +     return  __kmem_cache_create(s, size, align, flags, so);
> Is this a memory leak?

Yes, but see:

On 5/5/07, clameter@sgi.com <clameter@sgi.com> wrote:
> If constructor or destructor are specified then we will allocate a slab_ops
> structure and populate it with the values specified. Note that this will
> cause a memory leak if the slab is disposed of later. If you need disposable
> slabs then the new API must be used.

BTW:

> > +     if (ctor || dtor) {
> > +             so = kzalloc(sizeof(struct slab_ops), GFP_KERNEL);
> > +             so->ctor = ctor;

It's also a potential oops, actually. kzalloc's return must be checked.
