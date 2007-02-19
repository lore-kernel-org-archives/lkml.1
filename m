Return-Path: <linux-kernel-owner+w=401wt.eu-S932105AbXBSLN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbXBSLN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932109AbXBSLN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:13:28 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:28616 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105AbXBSLN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:13:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kbGsoBwQvvkA5Hv4sALF3Vo/zKEzJyUbegPtGxuQHdcCusXWOyBV0RpgmURFN6s6JSk9ljhse5ZHv66C69myPInnQTIoXKGxW2gDc56KJtbHmzeVEfG6MJdcn1gVdHSqAyKQHuSZULGAE7QlTdEAob9ZOup7GBCzvYpywuYNhJM=
Message-ID: <84144f020702190313m38b670eew204a5017e777851e@mail.gmail.com>
Date: Mon, 19 Feb 2007 13:13:23 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Artem Bityutskiy" <dedekind@infradead.org>
Subject: Re: [PATCH 12/44 take 2] [UBI] allocation unit implementation
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Frank Haverkamp" <haver@vnet.ibm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Josh Boyer" <jwboyer@linux.vnet.ibm.com>
In-Reply-To: <20070217165525.5845.78155.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165525.5845.78155.sendpatchset@localhost.localdomain>
X-Google-Sender-Auth: 77ecada3e7fb4ae9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/07, Artem Bityutskiy <dedekind@infradead.org> wrote:
> +void *ubi_kzalloc(size_t size)
> +{
> +       void *ret;
> +
> +       ret = kzalloc(size, GFP_KERNEL);
> +       if (unlikely(!ret)) {
> +               ubi_err("cannot allocate %zd bytes", size);
> +               dump_stack();
> +               return NULL;
> +       }
> +
> +       return ret;
> +}

[snip, snip]

NAK. Please drop all of these utterly pointless kmalloc() and
kmem_cache_alloc() wrappers.

                                             Pekka
