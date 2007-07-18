Return-Path: <linux-kernel-owner+w=401wt.eu-S937214AbXGRXxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937214AbXGRXxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761888AbXGRXxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:53:06 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:38244 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642AbXGRXxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fYTwLneKS8I6qfapN1js83HmFi0q4dSM0CoBnOzcJRw+80YL3o5y30HgtioBNR/eIeVl/3a8os0lm/8YqvUvJedhr0I19JTvZWVTPj9nHxF81UVWyWQpEkcl1NFiqKiPZIbZrKxOH1nH3kvGhMH722z2MbtPXdHl1QG7CB3reVo=
Message-ID: <8bd0f97a0707181653j3d44aab2tf8b6d24689458023@mail.gmail.com>
Date: Wed, 18 Jul 2007 19:53:04 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: early_printk accessing __log_buf
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200707181939.46910.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707181756.44074.rgetz@blackfin.uclinux.org>
	 <20070718151617.fe6a2943.akpm@linux-foundation.org>
	 <200707181939.46910.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> On Wed 18 Jul 2007 18:16, Andrew Morton pondered:
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

maybe something as cheesy as early_get_log_buf() ?  that way you dont
have to do any buffer management, you can just operate read-only on
the string ...
-mike
