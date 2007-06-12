Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbXFLOz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbXFLOz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 10:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbXFLOzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 10:55:21 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:61968 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbXFLOzU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 10:55:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ANm9ndbz7BVPMXtjv0ZAj0pQowhmDEfnryEjRh/q2jvyqp4PV6a12XYTV6zEKDI2RSpJC7/J3HBmucqv/Br5Zd9dL7qCxyw1H0sxrZRPY09zg+f9P8GskbjXgrVBkhKiHHqT2W9lwa2MCwQoRFc8XdhkNt/+vMVgbEqjz7VIHR0=
Message-ID: <2accc2ff0706120755sf0176e6yc55e65ec0502da5b@mail.gmail.com>
Date: Tue, 12 Jun 2007 09:55:17 -0500
From: "Nelson Castillo" <nelsoneci@gmail.com>
To: "Stelian Pop" <stelian@popies.net>
Subject: Re: [RFC][PATCH 1/1] support for user-space buffers in kfifo
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1181655781.4620.77.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070611212614.GB21025@emqbit.com>
	 <1181655781.4620.77.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/07, Stelian Pop <stelian@popies.net> wrote:
> Le lundi 11 juin 2007 à 16:26 -0500, Nelson Castillo a écrit :
> > Hi.
> >
> > I just added support for user space buffers in kfifo. I found useful
> > __kfifo_get_user to copy data to a user buffer in a read call. I didn't
> > like the idea of having an extra buffer.
> >
> > * Is it ok to add this support?
>
> I suppose it is, however:
>
> > +     spin_lock_irqsave(fifo->lock, flags);
> > +
> > +     ret = __kfifo_put_user(fifo, buffer, len);
> > +
> > +     spin_unlock_irqrestore(fifo->lock, flags);
> [...]
>
> > +int __kfifo_put_user(struct kfifo *fifo, const unsigned char __user *buffer,
> > +             unsigned int len)
> [...]
>
> > +     if(copy_from_user(fifo->buffer + (fifo->in & (fifo->size - 1)),
> > +                       buffer, l))
> > +             return  -EFAULT;
> [...]
>
> accessing userspace memory with a spinlock taken (moreover an irqsave()
> one) is bad bad bad.

Yes.

Perhaps then only the functions __kfifo_put_user and __kfifo_get_user should
be allowed. Those are the ones I'm using now , anyway.
I added the others for completeness but adding them is probably a mistake.

Regards,
Nelson.-

-- 
http://arhuaco.org
http://emQbit.com
