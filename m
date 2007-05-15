Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbXEOVbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbXEOVbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 17:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbXEOVbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 17:31:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:37862 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbXEOVbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 17:31:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f0SYoo25BG6QOBqLuPdnc8eplQhTqEqkNl642r4T9940u396j1BnLYtvW73qc7GEtptnZm+EEYflj9xualp9ixQkf7VWp3bX9tqB0UxSGicvSWa92mhmjs5U8THhIPpclBVXNLDdTKo6CmMNOIB/SINxn3QkB9CRwkr+MLri5nU=
Message-ID: <92a12cdb0705151431r57cdd98cq9b77e218f5293214@mail.gmail.com>
Date: Tue, 15 May 2007 22:31:15 +0100
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
To: "Heikki Orsila" <shdl@zakalwe.fi>
Subject: Re: [PATCH] ALSA sound driver for SEGA Dreamcast AICA (pcm)
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net
In-Reply-To: <92a12cdb0705151430o66e11fc3m2ec0abd423dc4a6e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92a12cdb0705141514v4c928041i6030267fd322e87@mail.gmail.com>
	 <20070515004751.GD10873@zakalwe.fi>
	 <92a12cdb0705151430o66e11fc3m2ec0abd423dc4a6e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/05/07, Adrian McMenamin <adrianmcmenamin@gmail.com> wrote:
> On 15/05/07, Heikki Orsila <shdl@zakalwe.fi> wrote:
> > I still noticed some type cleanups, and possibly a good debug message..
> >
> > On Mon, May 14, 2007 at 11:14:55PM +0100, Adrian McMenamin wrote:
> > > +/* spu_memload - write to SPU address space */
> > > +static void spu_memload(u32 toi, void __iomem * from, int length)
> > > +{
> > > +     u32 __iomem *froml = from;
> > > +     u32 __iomem *to = (u32 __iomem *) (SPU_MEMORY_BASE + toi);
> > > +     int i, val;
> >
> > You should use "void *from" because it's not IO memory. Also, use "u32 val"
> > since that is the native type of "u32 *from".
> >
> > > +     length = DIV_ROUND_UP(length, 4);
> > > +     spu_write_wait();
> > > +     for (i = 0; i < length; i++) {
> > > +             val = *froml;
> > > +             writel(val, to);
> > > +             froml++;
> > > +             to++;
> > > +             if (i && !(i % 8))
> > > +                     spu_write_wait();
> > > +     }
> > > +}
> >
> > It seems a small simplification is possible:
> >
> >         /* remove first spu_write_wait(); */
> >         for (i = 0; i < length; i++) {
> >                 if (!(i % 8))
> >                         spu_write_wait();
> >                 val = *froml;
> >                 ...
> >         }
> >
>
> No, that would be dangerous because we don't know what state the FIFO
> is in when this is called.
>


Sorry, should think before I post!
