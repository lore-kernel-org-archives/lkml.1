Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbXC3Lzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbXC3Lzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 07:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbXC3Lzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 07:55:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:25563 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbXC3Lz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 07:55:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=NBZ2XYZQAJjkG9dWeWMf96XIAxLc3wQEcttP2mmktfwVcemHZpy0hDn2UtlaPXtEwsmdbESFft9hgxZujUrc9snRZU51WAl5unVo6F/zXwrGdRCgw6J3BAyUzulk4gThpSB66oNVW4Biie3fgCQ7nfFbD1a8eQxMAJfJf8CSlkM=
Message-ID: <84144f020703300455i4fe6bdc5yf4389c2105487bb0@mail.gmail.com>
Date: Fri, 30 Mar 2007 14:55:26 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Subject: Re: [QUESTION] check for mem in slab
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
In-Reply-To: <20070330065641.GA8365@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070329160434.GA10265@cvg>
	 <20070330065641.GA8365@osiris.boeblingen.de.ibm.com>
X-Google-Sender-Auth: b3191040c13882c9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/07, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > in file mm/slab.c and routine kmem_cache_init() I found there
> > is no checking for allocated memory on line:
> >
> >       /* 4) Replace the bootstrap head arrays */
> >       {
> >               struct array_cache *ptr;
> >
> >               ptr = kmalloc(sizeof(struct arraycache_init), GFP_KERNEL);
> >
> > --> no check for ptr == NULL <--
> [...]
> > is that OK? or it's a bug?
>
> It's ok. If that allocation fails your machine won't come up anyway.

We ought to add a BUG_ON or comment at least there as this keeps
popping up again and again.
