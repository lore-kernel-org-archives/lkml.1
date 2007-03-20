Return-Path: <linux-kernel-owner+w=401wt.eu-S932486AbXCTJYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbXCTJYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 05:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933277AbXCTJYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 05:24:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:49025 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486AbXCTJYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 05:24:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aNdUMwUESkuqhu0IyrRsO0K3oz6I9XipP9sArmjcuD3TdZQcAEJ/iYIyYFs69bL5e9+FPkUTdvhMlMjlojxbtxtxQ0r9AxkgcONJekId2cDhpEj2jjfIiym7EyDOPr0X2cSTvfhUfkQ9ao3Zl7c8B6Nffljvle7eOHGoH0Z4EOQ=
Message-ID: <9a8748490703200224v204ff9ebs5bd964abef61e9c6@mail.gmail.com>
Date: Tue, 20 Mar 2007 10:24:44 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Mikael Pettersson" <mikpe@it.uu.se>
Subject: Re: [PATCH][5/5][resend] floppy.c: Fix device_create_file() warning
Cc: ak@suse.de, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       trent.waddington@gmail.com
In-Reply-To: <200703200832.l2K8W3o5023643@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703200832.l2K8W3o5023643@harpo.it.uu.se>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/03/07, Mikael Pettersson <mikpe@it.uu.se> wrote:
> On Mon, 19 Mar 2007 18:42:22 +0100, Jesper Juhl wrote:
> > --- a/drivers/block/floppy.c
> > +++ b/drivers/block/floppy.c
> > @@ -4302,7 +4302,12 @@ static int __init floppy_init(void)
> >               if (err)
> >                       goto out_flush_work;
> >
> > -             device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
> > +             err = device_create_file(&floppy_device[drive].dev, &dev_attr_cmos);
> > +             if (err)
> > +                     goto out_flush_work;
> > +
> >               /* to be cleaned up... */
> >               disks[drive]->private_data = (void *)(long)drive;
> >               disks[drive]->queue = floppy_queue;
>
> The floppy driver's sysfs file just provides some auxiliary
> information to user-space, none of which matters for most of
> its users. It is IMO totally inappropriate to fail floppy
> driver init in this case.
>

Which is why my original patch just output a warning to let the user
know that creating the file had failed.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
