Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbYDUItR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbYDUItR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbYDUIs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:48:29 -0400
Received: from rv-out-0708.google.com ([209.85.198.244]:27317 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755479AbYDUIsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:48:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rYCtr88cbSnVpICK4U799kccNSOeuBIHK1CC6vf6qR1olkq//ELJItCJ6xBKZAUszDOlk2xRr/f6oHFrDaqvydeMEGkRg44z8ZaUJESIrB/E+ar5ZN4nFn9+N+A8hhB+rrq9FxE75r2bi8SOyYTRPca/Qdel0Rzsd1ek/RlDdr4=
Message-ID: <bc64b4640804210148p2d1c2fe0qe469152fa1a9697e@mail.gmail.com>
Date: Mon, 21 Apr 2008 12:48:24 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Paul Walmsley" <paul@pwsan.com>
Subject: Re: [PATCH 0/5] Clocklib: generic clocks framework
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "pHilipp Zabel" <philipp.zabel@gmail.com>,
       "Pavel Machek" <pavel@ucw.cz>, tony@atomide.com,
       "David Brownell" <david-b@pacbell.net>, hiroshi.DOYU@nokia.com
In-Reply-To: <alpine.DEB.1.00.0804210057000.17857@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080420082925.GA32739@doriath.ww600.siemens.net>
	 <alpine.DEB.1.00.0804210057000.17857@utopia.booyaka.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Paul,

2008/4/21, Paul Walmsley <paul@pwsan.com>:
> Hello Dmitry,
>
>  By way of introduction, I've been working on the Linux-OMAP clock tree
>  over the past several months.  I recently had the opportunity to take a
>  brief look at these clocklib patches that you're posting, and had a few
>  thoughts:
>
>  - I understand from the discussions in this thread that the usage of your
>   clocklib code will be optional. However, the way you implement various
>   parts of the clock interface may effectively become mandatory, and
>   clocklib may not be able to handle many of the platform-specific clock
>   details that are necessary with more complex clock layouts like OMAP.
>   Would you consider the main goal of your clocklib code to be simply the
>   removal of several of the simpler ARM clock tree implementations?  Or is
>   your intention for it to ultimately replace all of the current Linux
>   clock implementations?  If the latter, your patchset will presumably
>   need a higher standard of review, since once it is integrated, any
>   changes will affect several architectures, rather than simply one.

Yes, I pretty much understand that. That's why I've posted the
patchserie to the LKML and added such long cc list full of arch.
maintainers. I hope it will be usefull not only to few arm arches, but
to a wide list of linux-supported systems.

I've reviewed the code for most linux/clk.h implementations in the
kernel. The OMAP code was... a bit scary for me. I don't have any deep
knowledge of this platform, and there were lots of structures, lots of
structs embedding struct clk, etc.
Tell me please, what do you need, that can't be done with this framework?


>  - As others have mentioned earlier on this thread, it seems difficult to
>   construct a good "one-size-fits-all" struct clk.  At the very least,
>   I would also suggest adding a 'void *' to allow storage of clock-specific
>   data.

This was already discussed. It was suggested to use struct embedding
and container_of,
instead of pointers. If you do really need a pointer, you can writes
struct my_clk {
      void *data;
      struct clk clk;
};

>  - Hiroshi DOYU has proposed an alternate debugfs implementation for the
>   Linux-OMAP clock tree.  I prefer it to yours, as it implements each
>   clock as a separate dentry, which makes it easy to implement additional
>   debugging functions, such as set_rate/set_parent/round_rate debugging.
>   Perhaps you'd consider it, or something similar to it, instead?  It is
>   proposed here:
>      http://www.mail-archive.com/linux-omap@vger.kernel.org/msg00751.html

I'll look at this. However, if we are going to use such
implementation, may we should
move instead to sysfs?

>  - I don't think that I understand the clk_functions part of your code.
>   Is this a shorthand to construct aliases to other struct clks?

Yes, that's one of usages for it. E.g. current AT91 code has same
functionality named
at91_clock_associate.  Also onece we get to multiple chips
providers/users, we'll see,
that the clock simply can't have just one record in the clocks tree.
It's provided by some
pin (provider_name) and then consumed by several devices (several
consumer_name + consumer_device pairs). That is it.

-- 
With best wishes
Dmitry
