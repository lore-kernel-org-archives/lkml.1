Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbXFLOG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbXFLOG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 10:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXFLOGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 10:06:53 -0400
Received: from sd291.sivit.org ([194.146.225.122]:3030 "EHLO sd291.sivit.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbXFLOGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 10:06:52 -0400
X-Greylist: delayed 1432 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jun 2007 10:06:52 EDT
Subject: Re: [RFC][PATCH 1/1] support for user-space buffers in kfifo
From: Stelian Pop <stelian@popies.net>
To: Nelson Castillo <nelsoneci@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070611212614.GB21025@emqbit.com>
References: <20070611212614.GB21025@emqbit.com>
Content-Type: text/plain; charset=ISO-8859-15
Date: Tue, 12 Jun 2007 15:43:01 +0200
Message-Id: <1181655781.4620.77.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 11 juin 2007 à 16:26 -0500, Nelson Castillo a écrit :
> Hi.
> 
> I just added support for user space buffers in kfifo. I found useful
> __kfifo_get_user to copy data to a user buffer in a read call. I didn't
> like the idea of having an extra buffer.
> 
> * Is it ok to add this support?

I suppose it is, however:

> +	spin_lock_irqsave(fifo->lock, flags);
> +
> +	ret = __kfifo_put_user(fifo, buffer, len);
> +
> +	spin_unlock_irqrestore(fifo->lock, flags);
[...]

> +int __kfifo_put_user(struct kfifo *fifo, const unsigned char __user *buffer,
> +	        unsigned int len)
[...]

> +	if(copy_from_user(fifo->buffer + (fifo->in & (fifo->size - 1)),
> +			  buffer, l))
> +		return  -EFAULT;
[...]

accessing userspace memory with a spinlock taken (moreover an irqsave()
one) is bad bad bad.

Stelian.
-- 
Stelian Pop <stelian@popies.net>

