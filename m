Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbXHXKtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbXHXKtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 06:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbXHXKs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 06:48:56 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:16449 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbXHXKsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 06:48:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cOjLOU3NuXFX+ZqOHx2XWSqGGUWzOrQOPly7h5KeptXVvjZK8WFXh5R/s7W4zBKYaYU8FMkW1jLAstSUv80TXsbn6vpvM2nRni7QagyRBLxZ3/SWoKEgld1WlGapVVm/IcgYCiDsCjucxF/eL9MhZbaPPLchzqTiQsND6r4Y5EU=
Message-ID: <9a8748490708240348q5317d013kc4148897b0871c75@mail.gmail.com>
Date: Fri, 24 Aug 2007 12:48:54 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
Subject: Re: [PATCH 09/30] mtd: Don't cast kmalloc() return value in drivers/mtd/maps/pmcmsp-flash.c
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "David Woodhouse" <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
In-Reply-To: <200708241141.06358.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
	 <5ebfb93eca0dd43cf17876e643079cbcfeb3111c.1187912217.git.jesper.juhl@gmail.com>
	 <200708241141.06358.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/08/07, Denys Vlasenko <vda.linux@googlemail.com> wrote:
> On Friday 24 August 2007 00:52, Jesper Juhl wrote:
> > kmalloc() returns a void pointer.
> > No need to cast it.
>
> > -     msp_flash = (struct mtd_info **)kmalloc(
> > -                     fcnt * sizeof(struct map_info *), GFP_KERNEL);
> > -     msp_parts = (struct mtd_partition **)kmalloc(
> > -                     fcnt * sizeof(struct mtd_partition *), GFP_KERNEL);
> > -     msp_maps = (struct map_info *)kmalloc(
> > -                     fcnt * sizeof(struct mtd_info), GFP_KERNEL);
> > +     msp_flash = kmalloc(fcnt * sizeof(struct map_info *), GFP_KERNEL);
> > +     msp_parts = kmalloc(fcnt * sizeof(struct mtd_partition *), GFP_KERNEL);
> > +     msp_maps = kmalloc(fcnt * sizeof(struct mtd_info), GFP_KERNEL);
> >       memset(msp_maps, 0, fcnt * sizeof(struct mtd_info));
>
> This one wants kzalloc.
>
> > -             msp_parts[i] = (struct mtd_partition *)kmalloc(
> > -                     pcnt * sizeof(struct mtd_partition), GFP_KERNEL);
> > +             msp_parts[i] = kmalloc(pcnt * sizeof(struct mtd_partition),
> > +                     GFP_KERNEL);
> >               memset(msp_parts[i], 0, pcnt * sizeof(struct mtd_partition));
> >
> >               /* now initialize the devices proper */
>
> Same

Ok, thank you for that feedback.
 I'll respin the patch with that change when I resubmit all the ones
that don't get picked up (probably next week).

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
