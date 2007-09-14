Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbXINHvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbXINHvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 03:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbXINHvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 03:51:41 -0400
Received: from colin.muc.de ([193.149.48.1]:4582 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbXINHvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 03:51:40 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Sep 2007 03:51:40 EDT
Date: 14 Sep 2007 09:44:59 +0200
Date: Fri, 14 Sep 2007 09:44:58 +0200
From: Andi Kleen <ak@muc.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Introduce "used_vectors" bitmap which can be used to reserve vectors.
Message-ID: <20070914074458.GA63069@muc.de>
References: <1189746849.7262.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189746849.7262.29.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 03:14:09PM +1000, Rusty Russell wrote:
> This simplifies the io_apic.c __assign_irq_vector() logic and removes
> the explicit SYSCALL_VECTOR check, and also allows for vectors to be
> reserved by other mechanisms (ie. lguest).

Seems reasonable even as a cleanup.

>  
>  int panic_on_unrecovered_nmi;
> +
> +DECLARE_BITMAP(used_vectors, NR_VECTORS);
> +EXPORT_SYMBOL_GPL(used_vectors);

But what is the export good for? Since it's only used at boot
a module cannot do anything useful with it.

-Andi
