Return-Path: <linux-kernel-owner+w=401wt.eu-S965430AbXCFCEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965430AbXCFCEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965702AbXCFCEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:04:14 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:49876 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965430AbXCFCEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:04:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UQZSAeAs5vBjuyaCeu/ucnCmmlI3a7dxdiSws5L1AVRsVxugzfWoY4jhp+yp+fhlIycSepxEvd5h5xPjSIviZfydMiwY1HhgVHHcffMa4HKJvJcwh0uJqm8P1bEax8RB5C9BrO17tjANHDKAtuVWlrHOcABSKk2KeVA/PhYhHEc=
Message-ID: <8bd0f97a0703051804g730d99dhbfc419897538c955@mail.gmail.com>
Date: Mon, 5 Mar 2007 21:04:13 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>, "Wu, Bryan" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
In-Reply-To: <20070305092346.GB11664@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1172722480.5264.75.camel@roc-desktop>
	 <20070305092346.GB11664@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/5/07, Paul Mundt <lethal@linux-sh.org> wrote:
> > +config DEBUG_HUNT_FOR_ZERO
> > +     bool "Catch NULL pointer reads/writes"
> > +     default y
>
> Is this sane to have conditional?

yes ... with the ability to change the load address of the kernel, you
can create a reserved chunk of memory for users to utilize in their
custom kernel/userspace apps

an abuse of no-mmu to be sure ;)

> > +#ifdef CONFIG_BUG
> > +#define HAVE_ARCH_BUG
> > +#define BUG() do { \
> > +     dump_stack(); \
> > +     printk(KERN_WARNING "\nkernel BUG at %s:%d!\n",\
> > +              __FILE__, __LINE__); \
> > +     panic("BUG!"); \
> > +} while (0)
> > +#endif
> > +
> > +#include <asm-generic/bug.h>
> > +#endif
>
> What do you need HAVE_ARCH_BUG for? You're not doing anything with it..

last i checked, the default BUG() does not include the dump_stack()
... if things have changed, then sure the generic bug implementation
is OK, otherwise this helps us with debugging
-mike
