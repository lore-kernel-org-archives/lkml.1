Return-Path: <linux-kernel-owner+w=401wt.eu-S1751542AbZL0VyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbZL0VyF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbZL0VyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:54:01 -0500
Received: from www84.your-server.de ([213.133.104.84]:40971 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbZL0VyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:54:00 -0500
Subject: Re: [PATCH] [5/6] kfifo: Add kfifo_initialized
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20091227210315.AE55EB17C3@basil.firstfloor.org>
References: <200912271003.631128760@firstfloor.org>
	 <20091227210315.AE55EB17C3@basil.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 27 Dec 2009 22:53:55 +0100
Message-ID: <1261950835.25298.36.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 27.12.2009, 22:03 +0100 schrieb Andi Kleen:
> Simple inline that checks if kfifo_init() has been executed
> on a fifo.
> 
> This is useful for walking all per CPU fifos, when some of them
> might not have been brought up yet.
> 

Could be useful, i can implement it. But with the new macro based kfifo
there are also real in place fifo's, where the buffer is a part of the
kfifo structure. But in this case i can return always true.

Stefani

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  include/linux/kfifo.h |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> Index: linux/include/linux/kfifo.h
> ===================================================================
> --- linux.orig/include/linux/kfifo.h
> +++ linux/include/linux/kfifo.h
> @@ -117,6 +117,16 @@ extern __must_check unsigned int kfifo_o
>  extern __must_check unsigned int kfifo_out_peek(struct kfifo *fifo,
>  				void *to, unsigned int len, unsigned offset);
>  
> +/**
> + * kfifo_initialized - Check if kfifo is initialized.
> + * @fifo: fifo to check
> + * Return %true if FIFO is initialized, otherwise %false.
> + * Assumes the fifo was 0 before.
> + */
> +static inline bool kfifo_initialized(struct kfifo *fifo)
> +{
> +	return fifo->buffer != 0;
> +}
>  
>  /**
>   * kfifo_reset - removes the entire FIFO contents


