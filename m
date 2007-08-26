Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbXHZLGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbXHZLGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 07:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbXHZLGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 07:06:41 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:41466 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbXHZLGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 07:06:38 -0400
X-Greylist: delayed 9352 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Aug 2007 07:06:38 EDT
Date: Sun, 26 Aug 2007 13:06:31 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       blinux-list@redhat.com, cluster-devel@redhat.com, discuss@x86-64.org,
       jffs-dev@axis.com, linux-acpi@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-mips@linux-mips.org,
       linux-mm@kvack.org, linux-mtd@lists.infradead.org,
       linux-scsi@vger.kernel.org, mpt_linux_developer@lsi.com,
       netdev@vger.kernel.org, osst-users@lists.sourceforge.net,
       parisc-linux@parisc-linux.org, tpmdd-devel@lists.sourceforge.net,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] Prefix each line of multiline printk(KERN_<level>
 "foo\nbar") with KERN_<level>
In-Reply-To: <8bd0f97a0708260354xb4c8546od0cc19a590820f32@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708261305020.31149@anakin>
References: <1187999098.32738.179.camel@localhost> <Pine.LNX.4.64.0708261028120.31149@anakin>
 <8bd0f97a0708260354xb4c8546od0cc19a590820f32@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Aug 2007, Mike Frysinger wrote:
> On 8/26/07, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Fri, 24 Aug 2007, Joe Perches wrote:
> > > Corrected printk calls with multiple output lines which
> > > did not correctly preface each line with KERN_<level>
> > >
> > > Fixed uses of some single lines with too many KERN_<level>
> >
> > > --- a/arch/arm/kernel/ecard.c
> > > +++ b/arch/arm/kernel/ecard.c
> > > @@ -547,7 +547,8 @@ static void ecard_check_lockup(struct irq_desc *desc)
> > >       if (last == jiffies) {
> > >               lockup += 1;
> > >               if (lockup > 1000000) {
> > > -                     printk(KERN_ERR "\nInterrupt lockup detected - "
> > > +                     printk(KERN_ERR "\n"
> > > +                            KERN_ERR "Interrupt lockup detected - "
> > >                              "disabling all expansion card interrupts\n");
> > >
> > >                       desc->chip->mask(IRQ_EXPANSIONCARD);
> >
> > What's the purpose of having lines printed with e.g. `KERN_ERR "\n"' only?
> > Shouldn't these just be removed?
> >
> > Usually lines starting with `\n' are continuations, but given some other
> > module may call printk() in between, there's no guarantee continuations
> > appear on the same line.
> 
> erm, i thought the prink lock was grabbed per-buffer, not per-line ...
> so yes, if the function calls were like printk(KERN_ERR "\n");
> printk(KERN_ERR "..."); things could be broken up, but this is on
> function call, so it shouldnt ...

Yes it is.

What I mean is that probably there used to be a printk() call starting with
`\n'. Then someone added a `KERN_ERR' in front of it.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
