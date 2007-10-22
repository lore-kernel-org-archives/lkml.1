Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbXJVNGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbXJVNGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 09:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbXJVNGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 09:06:24 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:5950 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbXJVNGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 09:06:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DLEi0Y3ffWvzKj9yJTwNcWP4EfDEIJL5Lk61U14HbkO3ub7Sjje/n4Tolw+rRBqy7QMGzGtbBngdfnfj8cPdoY30ZGXFdIxik2LEhTEdcvUlQphZ2h4fpuofTvoywbWIireK8PYgo1tXzQYJ6gT4Iiq7ZU2QJNDmw0c3cInngzk=
Message-ID: <84144f020710220606o2e52afbfu66a2146c5433d96f@mail.gmail.com>
Date: Mon, 22 Oct 2007 16:06:23 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Alexey Dobriyan" <adobriyan@sw.ru>
Subject: Re: [PATCH] Bogus KERN_ALERT on oops
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
In-Reply-To: <20071022115704.GA6271@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071022115704.GA6271@localhost.sw.ru>
X-Google-Sender-Auth: 0bb12fee715092fa
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

On 10/22/07, Alexey Dobriyan <adobriyan@sw.ru> wrote:
> printing eip: f881b9f3 *pdpt = 0000000000003001 <1>*pde = 000000000480a067 *pte = 0000000000000000

> --- a/arch/x86/mm/fault_32.c
> +++ b/arch/x86/mm/fault_32.c
> @@ -550,7 +550,7 @@ no_context:
>                         page &= PAGE_MASK;
>                         page = ((__typeof__(page) *) __va(page))[(address >> PMD_SHIFT)
>                                                                  & (PTRS_PER_PMD - 1)];
> -                       printk(KERN_ALERT "*pde = %016Lx ", page);
> +                       printk("*pde = %016Lx ", page);

Use the new KERN_CONT annotation here?
