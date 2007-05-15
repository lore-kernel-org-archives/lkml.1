Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbXEOVaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbXEOVaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 17:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbXEOVaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 17:30:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:37198 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbXEOVaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 17:30:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C6shr+8XSN9mmU34m3DQlK0TVjN1vR/2fTO4pVCo347lb7wAvSZ55FzwKFmvdTev3voQd673uBeDQu7S3bY1uG+3iFnu4ITWgc+dVAZRw3FHfU3tSwcPtmHfjoU7UUnLSiqeGg5hp3B9vljo704lFhAuPDI33PHsuqFy8X83NwI=
Message-ID: <92a12cdb0705151430o66e11fc3m2ec0abd423dc4a6e@mail.gmail.com>
Date: Tue, 15 May 2007 22:30:02 +0100
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
To: "Heikki Orsila" <shdl@zakalwe.fi>
Subject: Re: [PATCH] ALSA sound driver for SEGA Dreamcast AICA (pcm)
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net
In-Reply-To: <20070515004751.GD10873@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92a12cdb0705141514v4c928041i6030267fd322e87@mail.gmail.com>
	 <20070515004751.GD10873@zakalwe.fi>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/05/07, Heikki Orsila <shdl@zakalwe.fi> wrote:
> I still noticed some type cleanups, and possibly a good debug message..
>
> On Mon, May 14, 2007 at 11:14:55PM +0100, Adrian McMenamin wrote:
> > +/* spu_memload - write to SPU address space */
> > +static void spu_memload(u32 toi, void __iomem * from, int length)
> > +{
> > +     u32 __iomem *froml = from;
> > +     u32 __iomem *to = (u32 __iomem *) (SPU_MEMORY_BASE + toi);
> > +     int i, val;
>
> You should use "void *from" because it's not IO memory. Also, use "u32 val"
> since that is the native type of "u32 *from".
>
> > +     length = DIV_ROUND_UP(length, 4);
> > +     spu_write_wait();
> > +     for (i = 0; i < length; i++) {
> > +             val = *froml;
> > +             writel(val, to);
> > +             froml++;
> > +             to++;
> > +             if (i && !(i % 8))
> > +                     spu_write_wait();
> > +     }
> > +}
>
> It seems a small simplification is possible:
>
>         /* remove first spu_write_wait(); */
>         for (i = 0; i < length; i++) {
>                 if (!(i % 8))
>                         spu_write_wait();
>                 val = *froml;
>                 ...
>         }
>

No, that would be dangerous because we don't know what state the FIFO
is in when this is called.
