Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbXGDMBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbXGDMBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbXGDMBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:01:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:11389 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338AbXGDMBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:01:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y1e69pKKIGy6DyYmpT+8yyoxtgFAMv9829mGkAIJ5Yx19g8N3NOogY5k2f9fLl1DqQhv0TIw83eo3tzxFQ4Bilb0RJ9oywLJTEB7UpRp2KDaqUpaEzxWY92UYNx5rrT/4Yn4r4TjSluAl2qQrWVXSN2GKnjCEt0AFaFTyIcXZDc=
Message-ID: <fb249edb0707040500o42e945afr9040cbd268942555@mail.gmail.com>
Date: Wed, 4 Jul 2007 14:00:58 +0200
From: "andrzej zaborowski" <balrogg@gmail.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: Don't miss the ARM-scsi fix.
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20070703193104.GA27542@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707031503.56561.rob@landley.net>
	 <20070703122145.447c7d2c.akpm@linux-foundation.org>
	 <20070703193104.GA27542@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/07, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Tue, Jul 03, 2007 at 12:21:45PM -0700, Andrew Morton wrote:
> > On Tue, 3 Jul 2007 15:03:56 -0400
> > Rob Landley <rob@landley.net> wrote:
> > > diff --git a/arch/arm/mach-versatile/pci.c b/arch/arm/mach-versatile/pci.c
> > > index ba58223..ca82901 100644
> > > --- a/arch/arm/mach-versatile/pci.c
> > > +++ b/arch/arm/mach-versatile/pci.c
> > > @@ -117,7 +117,10 @@ static int versatile_read_config(struct pci_bus *bus, unsigned int devfn, int wh
> > >     } else {
> > >             switch (size) {
> > >             case 1:
> > > -                   v = __raw_readb(addr);
> > > +                   v = __raw_readl(addr);
> > > +                   if (where & 2) v >>= 16;
> > > +                   if (where & 1) v >>= 8;
> >
> > Someone's enter key broke?
>
> Probably, but I'd rather have the fix in than worry about that at this
> stage.

It's just the case of being consistent with the already broken style
in a function vs. correct style and inconsistency. I can never decide.

Regards,
