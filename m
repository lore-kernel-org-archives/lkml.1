Return-Path: <linux-kernel-owner+w=401wt.eu-S1030683AbXDLS3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030683AbXDLS3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 14:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030685AbXDLS3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 14:29:24 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:34255 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030683AbXDLS3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 14:29:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fkwGwTnp9h6Zh0keHn4qdKSEVOPQCth7vLBQ4YBfQ3ILU/PWK5XmNUbXHkxvAxVl7zp/U3Ji2cRzxb1cVTxB7FRbl6P+kjgAx+fkLyZnlRpH9eVIjj3Qy1c7+SuVoQuzJpudL6mLFXAnsqqYejWaHYnwFKQgyKGWKiQn+3bgckQ=
Message-ID: <5c49b0ed0704121129h51f852a1wbdc3192c89aec4e6@mail.gmail.com>
Date: Thu, 12 Apr 2007 11:29:21 -0700
From: "Nate Diller" <nate.diller@gmail.com>
To: "Phillip Lougher" <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH 7/17] jffs2: convert jffs2_gc_fetch_page to read_cache_page
Cc: "Andrew Morton" <akpm@osdl.org>, "David Woodhouse" <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <461E1AC9.30107@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070412024938.27380.13619.patchbomb.py@localhost>
	 <461E1AC9.30107@lougher.demon.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/07, Phillip Lougher <phillip@lougher.demon.co.uk> wrote:
> Nate Diller wrote:
>
> > +     page = read_cache_page(OFNI_EDONI_2SFFJ(f)->i_mapping,
> > +                             start >> PAGE_CACHE_SHIFT,
> > +                             (void *)jffs2_do_readpage_unlock,
> > +                             OFNI_EDONI_2SFFJ(f));
> >
> > -     if (IS_ERR(pg_ptr)) {
> > +     if (IS_ERR(page)) {
> >               printk(KERN_WARNING "read_cache_page() returned error: %ld\n", PTR_ERR(pg_ptr));
>
> should be
>
>                 printk(KERN_WARNING "read_cache_page() returned error: %ld\n", PTR_ERR(page));
>
> > -             return PTR_ERR(pg_ptr);
> > +             return PTR_ERR(page);
>

wow, you're right.  I was sure I compile-tested this ... oh, "depends
on MTD".  oops.

thanks for reviewing.  does it look OK to you otherwise?

NATE
