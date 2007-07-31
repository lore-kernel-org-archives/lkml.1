Return-Path: <linux-kernel-owner+w=401wt.eu-S969517AbXGaErC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969517AbXGaErC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:47:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758189AbXGaEqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:46:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38327 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758061AbXGaEqv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:46:51 -0400
Date: Mon, 30 Jul 2007 21:46:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fernando Luis =?ISO-8859-1?B?VuF6cXVleg==?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Debug handling of early spurious interrupts
Message-Id: <20070730214610.9868cbe3.akpm@linux-foundation.org>
In-Reply-To: <1185848726.23316.50.camel@sebastian.kern.oss.ntt.co.jp>
References: <1184666997.5271.5.camel@sebastian.kern.oss.ntt.co.jp>
	<20070718154659.c8b5ffea.akpm@linux-foundation.org>
	<1184896459.27369.36.camel@sebastian.kern.oss.ntt.co.jp>
	<1184896944.27369.50.camel@sebastian.kern.oss.ntt.co.jp>
	<1184898043.28418.3.camel@sebastian.kern.oss.ntt.co.jp>
	<20070720144302.2785e961.akpm@linux-foundation.org>
	<1185789494.9831.107.camel@sebastian.kern.oss.ntt.co.jp>
	<20070730112223.7b52cf63.akpm@linux-foundation.org>
	<1185848726.23316.50.camel@sebastian.kern.oss.ntt.co.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 11:25:26 +0900 Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp> wrote:

> > runtime.  Some drivers don't get used by many people and users of some
> > architectures (esp embedded) tend to lag kernel.org by a long time.  So it
> > could be years before all the fallout from this change is finally wrapped
> > up.
> Yes, that is a big concern. However, the same embedded people is
> starting to use both kexec and kdump, so they may suffer the issues we
> are trying to weed out anyway, even if these patches are not applied.
> The difference is that with this new functionality it is possible to
> catch potential problems relatively easily, because any incorrect
> behaviour this may cause will be easily reproducible and, in most cases,
> will reveal itself early at boot time.
> 
> As things stand now, I guess we will keep seeing occasional crashes and
> strange behaviour in kexec-booted kernels, which in some cases will be
> due to incorrect handling of spurious interrupts. Besides, such problems
> are really difficult to reproduce because, commonly, we would need to
> hit an obscure corner case.

Please have a think about what we can do to aid this debugging.  For
example, add an uncondtional printk into request_irq() for now which tells
us what irq is being registered - a print_symbol() of the irq_handler_t
would be pretty good, although I suspect there are a lot of interrupt
handlers with the same name..


