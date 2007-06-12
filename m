Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbXFLWMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbXFLWMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 18:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbXFLWM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 18:12:29 -0400
Received: from sd291.sivit.org ([194.146.225.122]:1234 "EHLO sd291.sivit.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbXFLWM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 18:12:28 -0400
Subject: Re: [RFC][PATCH 1/1] support for user-space buffers in kfifo
From: Stelian Pop <stelian@popies.net>
To: Nelson Castillo <nelsoneci@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070612162413.GB12369@emqbit.com>
References: <20070612162413.GB12369@emqbit.com>
Content-Type: text/plain; charset=ISO-8859-15
Date: Wed, 13 Jun 2007 00:12:26 +0200
Message-Id: <1181686346.7991.3.camel@voyager.dsnet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 12 juin 2007 à 11:24 -0500, Nelson Castillo a écrit :
> On 6/12/07, Stelian Pop <stelian@popies.net> wrote:
> (cut)
> > accessing userspace memory with a spinlock taken (moreover an
> > irqsave()
> > one) is bad bad bad.
> 
> Hi Stelian.
> 
> I'm sending the new patch without kfifo_put_user and kfifo_get_user.

Ok, I have a few formatting/documentation comments:

> + * This function copies at most @len bytes from the @buffer into
> + * the FIFO depending on the free space, and returns the number of
> + * bytes copied.

... or -EFAULT if copy_from_user fails

> + *
> + * Note that with only one concurrent reader and one concurrent
> + * writer, you don't need extra locking to use these functions.
> + */
> +int __kfifo_put_user(struct kfifo *fifo, const unsigned char __user *buffer,
> +	        unsigned int len)

spacing ?

> +	if(copy_from_user(fifo->buffer + (fifo->in & (fifo->size - 1)),
> +			  buffer, l))

leave a space after the if please

> + * This function copies at most @len bytes from the FIFO into the
> + * @buffer and returns the number of copied bytes.

or -EFAULT

> + *
> + * Note that with only one concurrent reader and one concurrent
> + * writer, you don't need extra locking to use these functions.
> + */
> +
> +int __kfifo_get_user(struct kfifo *fifo,
> +			 unsigned char __user *buffer, unsigned int len)

spacing.

Other than that I'm ok with this patch.

Thanks,

Stelian.
-- 
Stelian Pop <stelian@popies.net>

