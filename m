Return-Path: <linux-kernel-owner+w=401wt.eu-S1752190AbXHZKyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbXHZKyZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 06:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbXHZKyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 06:54:14 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:10093 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbXHZKyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 06:54:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l6C7NLThJau5MeP+w3HiBkgGvGuLQz8bT++Cmi9i8SkbiYc3JuIZnwaWywaPZX3BkEoKSKiy6j5K4HSu7KYHEd4NoHKlOCyVi/GIMVfoMoGA3XEHtQAbPpjHJ20YaOtXHyCyW7rToFXbT/DG8QCi+zN9WnGfoTDm/2Jiv2AZawI=
Message-ID: <8bd0f97a0708260354xb4c8546od0cc19a590820f32@mail.gmail.com>
Date: Sun, 26 Aug 2007 06:54:10 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: Re: [PATCH] Prefix each line of multiline printk(KERN_<level> "foo\nbar") with KERN_<level>
Cc: "Joe Perches" <joe@perches.com>, linux-kernel@vger.kernel.org,
       blinux-list@redhat.com, cluster-devel@redhat.com, discuss@x86-64.org,
       jffs-dev@axis.com, linux-acpi@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-mips@linux-mips.org,
       linux-mm@kvack.org, linux-mtd@lists.infradead.org,
       linux-scsi@vger.kernel.org, mpt_linux_developer@lsi.com,
       netdev@vger.kernel.org, osst-users@lists.sourceforge.net,
       parisc-linux@parisc-linux.org, tpmdd-devel@lists.sourceforge.net,
       uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <Pine.LNX.4.64.0708261028120.31149@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1187999098.32738.179.camel@localhost>
	 <Pine.LNX.4.64.0708261028120.31149@anakin>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/07, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Fri, 24 Aug 2007, Joe Perches wrote:
> > Corrected printk calls with multiple output lines which
> > did not correctly preface each line with KERN_<level>
> >
> > Fixed uses of some single lines with too many KERN_<level>
>
> > --- a/arch/arm/kernel/ecard.c
> > +++ b/arch/arm/kernel/ecard.c
> > @@ -547,7 +547,8 @@ static void ecard_check_lockup(struct irq_desc *desc)
> >       if (last == jiffies) {
> >               lockup += 1;
> >               if (lockup > 1000000) {
> > -                     printk(KERN_ERR "\nInterrupt lockup detected - "
> > +                     printk(KERN_ERR "\n"
> > +                            KERN_ERR "Interrupt lockup detected - "
> >                              "disabling all expansion card interrupts\n");
> >
> >                       desc->chip->mask(IRQ_EXPANSIONCARD);
>
> What's the purpose of having lines printed with e.g. `KERN_ERR "\n"' only?
> Shouldn't these just be removed?
>
> Usually lines starting with `\n' are continuations, but given some other
> module may call printk() in between, there's no guarantee continuations
> appear on the same line.

erm, i thought the prink lock was grabbed per-buffer, not per-line ...
so yes, if the function calls were like printk(KERN_ERR "\n");
printk(KERN_ERR "..."); things could be broken up, but this is on
function call, so it shouldnt ...
-mike
