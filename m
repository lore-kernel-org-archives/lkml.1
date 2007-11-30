Return-Path: <linux-kernel-owner+w=401wt.eu-S932639AbXK3MIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbXK3MIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 07:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbXK3MIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 07:08:42 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:12317 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbXK3MIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 07:08:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hcn2ztfic2qH9de5hWcCDnfhSP0a+xRN0XXXtI5zEo2KHYO4UgCdZ/erZifOgx6wPZCaPk9XC/e+7FQgDOqkqiWmj2NUsA0CGUBgELgPhNFEZw0u4V3jsrPsovPt0iRN9bX5I4nLrYCZ6Sx/T44O+sAEbvCNGYevPm+a+R8ufro=
Message-ID: <3f9a31f40711300408s4341a338n33e5b6dbaee05813@mail.gmail.com>
Date: Fri, 30 Nov 2007 17:38:39 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] Re: [BUG] 2.6.24-rc3 x86 make depends on s390 arch
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Jan Glauber" <jan.glauber@de.ibm.com>
In-Reply-To: <20071130115015.GC11682@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40711300014y576e83dldfafa340eec257f0@mail.gmail.com>
	 <3f9a31f40711300303l3260c3e7s4c35884f5e1fa6e1@mail.gmail.com>
	 <20071130115015.GC11682@osiris.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/07, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> On Fri, Nov 30, 2007 at 04:33:19PM +0530, Jaswinder Singh wrote:
> > This patch fixes s390 dependency for x86
> >
> > Signed-off-by: Jaswinder Singh <jaswinderlinux@gmail.com>
>
> Deleting random parts of the kernel tree is actually not
> supported.
>

I agree with you. I just did this to same some space because I keep
many kernel trees.

But i am curious if other arch do not depends on x86 then s390 ?

> > diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> > index 1330061..b699ed5 100644
> > --- a/arch/s390/Kconfig
> > +++ b/arch/s390/Kconfig
> > @@ -537,4 +537,6 @@ source "security/Kconfig"
> >
> >  source "crypto/Kconfig"
> >
> > +source "arch/s390/crypto/Kconfig"
> > +
>
> With this there's no dependency on CRYPTO_HW anymore.
>

Anyhow "if CRYPTO_HW" is not working in drivers/crypto/Kconfig

have you tested this patch on S390. Is this giving errors ?

And you can also add depends with CRYPTO_HW in arch/s390/crypto/Kconfig

Thank you,

Jaswinder Singh.


> > +#ifdef CONFIG_S390
> >  #include "../arch/s390/appldata/appldata.h"
> > +#endif
>
> This include can go away.
>
> Since this pops up again and again we'll come up with a patch to fix this.
>
