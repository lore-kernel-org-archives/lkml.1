Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbXIXHoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbXIXHoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 03:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbXIXHoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 03:44:37 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:13730 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbXIXHog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 03:44:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=izYq7pHrzIcY6yt22PaWVb1hsmQuDOcCBUGgGZ/pLuHqlDLxx259VifjlRjzXkLgcmC0piHEssiEfrxt+iI3FY0zx3IfJjMc6nrVB5yRbt4BZjHY5VLazKs22ohj+Nx2We9XC+ObSkRcsX7Vg4MkSelwOXjA1vx6YcDvADgdgbs=
Message-ID: <b6fcc0a0709240044x62369dbcv1b5c69ce0be68581@mail.gmail.com>
Date: Mon, 24 Sep 2007 11:44:35 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] Uninline kcalloc()
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <25045.1190612108@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070922200349.GA2119@martell.zuzino.mipt.ru>
	 <25045.1190612108@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/24/07, Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:
> On Sun, 23 Sep 2007 00:03:49 +0400, Alexey Dobriyan said:
>
> > -static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
> > -{
> > -	if (n != 0 && size > ULONG_MAX / n)
> > -		return NULL;
> > -	return __kmalloc(n * size, flags | __GFP_ZERO);
> > -}
> > +void *kcalloc(size_t n, size_t size, gfp_t flags);
>
> NAK.
>
> This busticates some pretty subtle code in mm/slab.c that uses
> uses __builtin_return_address() for debugging

Interesting. Here is output from kernel with patch applied and leak
plugged into proc_dointvec() (I checked twice):

        $ grep kcalloc /proc/slab_allocators
        $ grep proc_dointvec /proc/slab_allocators
        size-64: 19 proc_dointvec+0x48/0xa0
