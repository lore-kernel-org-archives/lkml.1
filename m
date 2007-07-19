Return-Path: <linux-kernel-owner+w=401wt.eu-S936069AbXGSA0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936069AbXGSA0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932555AbXGSA0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:26:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60440 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932471AbXGSA0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:26:36 -0400
Date: Wed, 18 Jul 2007 17:26:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: early_printk accessing __log_buf
Message-Id: <20070718172603.231351ea.akpm@linux-foundation.org>
In-Reply-To: <200707181939.46910.rgetz@blackfin.uclinux.org>
References: <200707181756.44074.rgetz@blackfin.uclinux.org>
	<20070718151617.fe6a2943.akpm@linux-foundation.org>
	<200707181939.46910.rgetz@blackfin.uclinux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 19:39:46 -0400
Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> On Wed 18 Jul 2007 18:16, Andrew Morton pondered:
> > 
> > I'd suggest that any interface into here should be via function calls,
> > not via direct access to printk internals: think up some nice
> > copy_me_some_of_the_log_buffer() interface.
> 
> If so - I would still like to put it in:
>  - ifdef CONFIG_EARLY_PRINTK
>  - and define as __init
> 
> so that people don't use it when they shouldn't (when the kernel is up an 
> running).
> 
> Something simple like - early_copy_log_buff(void *dest, size_t n) 
> 
> copies n bytes from log_buf to memory area dest. Returns number of bytes that 
> could not be copied. Can find out how many bytes are in the log_buff by 
> calling with zero size.
> 
> This is not destructive to existing interfaces (log_start and con_start are 
> not updated/used). This should ensure that if booting does work - that normal 
> messages come out the standard method.
> 
> Any other suggestions?
> 

When I was at $EARLIER_EMPLOYER, we had code in there to copy the last
kilobyte-odd of the log buffer into flash when the box oopsed.

So there's one instance proof that something more general would be needed. 
Probably there are others, but they'll mainly be in the consumer/embedded
area, and those sorts of engineers don't read this mailing list much.

