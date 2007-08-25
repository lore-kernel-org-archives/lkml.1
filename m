Return-Path: <linux-kernel-owner+w=401wt.eu-S934451AbXHYW1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934451AbXHYW1g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 18:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757760AbXHYW1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 18:27:07 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:28182 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbXHYW1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 18:27:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BZIhu6IMxjAEh6SDyvs7i7d8Gi6sCuvZSrOzJajy1tvDlcLLF+XSEKTkq9X+ICJ0VMJiW8zTVMNm33NF6CoF3f0YLlAHjsz9qKAECphUld92zIc4/QCvTRVNv+1d/gjHN2a1IXiNNUQKwgVWnlA2mgMAiBuX0l59LWUkYLAJ+9Q=
Message-ID: <9a8748490708251527n26cc2065n5b8716bd7f65e252@mail.gmail.com>
Date: Sun, 26 Aug 2007 00:27:04 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH 09/30] mtd: Don't cast kmalloc() return value in drivers/mtd/maps/pmcmsp-flash.c
Cc: "Denys Vlasenko" <vda.linux@googlemail.com>, linux-mtd@lists.infradead.org,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0708240642500.18301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
	 <5ebfb93eca0dd43cf17876e643079cbcfeb3111c.1187912217.git.jesper.juhl@gmail.com>
	 <200708241141.06358.vda.linux@googlemail.com>
	 <Pine.LNX.4.64.0708240642500.18301@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/08/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Fri, 24 Aug 2007, Denys Vlasenko wrote:
>
> > On Friday 24 August 2007 00:52, Jesper Juhl wrote:
> > > kmalloc() returns a void pointer.
> > > No need to cast it.
> >
> > > -   msp_flash = (struct mtd_info **)kmalloc(
> > > -                   fcnt * sizeof(struct map_info *), GFP_KERNEL);
> > > -   msp_parts = (struct mtd_partition **)kmalloc(
> > > -                   fcnt * sizeof(struct mtd_partition *), GFP_KERNEL);
> > > -   msp_maps = (struct map_info *)kmalloc(
> > > -                   fcnt * sizeof(struct mtd_info), GFP_KERNEL);
> > > +   msp_flash = kmalloc(fcnt * sizeof(struct map_info *), GFP_KERNEL);
> > > +   msp_parts = kmalloc(fcnt * sizeof(struct mtd_partition *), GFP_KERNEL);
> > > +   msp_maps = kmalloc(fcnt * sizeof(struct mtd_info), GFP_KERNEL);
> > >     memset(msp_maps, 0, fcnt * sizeof(struct mtd_info));
> >
> > This one wants kzalloc.
> >
> > > -           msp_parts[i] = (struct mtd_partition *)kmalloc(
> > > -                   pcnt * sizeof(struct mtd_partition), GFP_KERNEL);
> > > +           msp_parts[i] = kmalloc(pcnt * sizeof(struct mtd_partition),
> > > +                   GFP_KERNEL);
> > >             memset(msp_parts[i], 0, pcnt * sizeof(struct mtd_partition));
> > >
> > >             /* now initialize the devices proper */
> >
> > Same
>
> actually, i would think kcalloc would be more appropriate here, no?
>

Why?

msp_parts[i] = kzalloc(pcnt * sizeof(struct mtd_partition), GFP_KERNEL);

seems better to me than

msp_parts[i] = kcalloc(1, pcnt * sizeof(struct mtd_partition), GFP_KERNEL);


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
