Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbXK3NAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbXK3NAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbXK3NAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:00:47 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:18862 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbXK3NAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:00:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AJbBM96nOemPiWAcV0FCXjavuVitt2a+I08R/qsP/qQRMmlIRWfcq7faizVDI1Ejned/GzKiKXjxuU+ff0Wt+pPFssB6F2JhayYHCaEJrtWMx5STMdBDW0b6UXTKy724R83nbFcDE23PipEyv749yQEeesgF2HJ8ccQxJnqwNnU=
Message-ID: <3f9a31f40711300500h6d13625ua08417ae53acbbea@mail.gmail.com>
Date: Fri, 30 Nov 2007 18:30:45 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] Re: [BUG] 2.6.24-rc3 x86 make depends on s390 arch
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Jan Glauber" <jan.glauber@de.ibm.com>
In-Reply-To: <20071130124958.GD11682@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40711300014y576e83dldfafa340eec257f0@mail.gmail.com>
	 <3f9a31f40711300303l3260c3e7s4c35884f5e1fa6e1@mail.gmail.com>
	 <20071130115015.GC11682@osiris.boeblingen.de.ibm.com>
	 <3f9a31f40711300408s4341a338n33e5b6dbaee05813@mail.gmail.com>
	 <20071130124958.GD11682@osiris.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We have two options:

1. Either move arch/s390/crypto/Kconfig to drivers/crypto/Kconfig

OR

2. In arch/s390/crypto/Kconfig , replace "depends on S390" to "depends
on CRYPRO_HW"

I think 2nd option is better for everyone.

Thank you,

Jaswinder Singh.

On 11/30/07, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > > > diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> > > > index 1330061..b699ed5 100644
> > > > --- a/arch/s390/Kconfig
> > > > +++ b/arch/s390/Kconfig
> > > > @@ -537,4 +537,6 @@ source "security/Kconfig"
> > > >
> > > >  source "crypto/Kconfig"
> > > >
> > > > +source "arch/s390/crypto/Kconfig"
> > > > +
> > >
> > > With this there's no dependency on CRYPTO_HW anymore.
> > >
> >
> > Anyhow "if CRYPTO_HW" is not working in drivers/crypto/Kconfig
> >
> > have you tested this patch on S390. Is this giving errors ?
> >
> > And you can also add depends with CRYPTO_HW in arch/s390/crypto/Kconfig
>
> Jan just created a patch which moves everything from
> arch/s390/crypto/Kconfig
> to drivers/crypto/Kconfig. Probably will be merged during the 2.6.25 merge
> window.
>
