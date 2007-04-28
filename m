Return-Path: <linux-kernel-owner+w=401wt.eu-S1161194AbXD1GyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161194AbXD1GyN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 02:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161235AbXD1GyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 02:54:13 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161194AbXD1GyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 02:54:11 -0400
Date: Fri, 27 Apr 2007 23:54:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: bbpetkov@yahoo.de
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] mm/memory.c: remove warning from an uninitialized
 spinlock. was: Re: 2.6.21-rc7-mm2
Message-Id: <20070427235409.c464455f.akpm@linux-foundation.org>
In-Reply-To: <20070428062516.GB4957@gollum.tnic>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<20070426182519.GA4532@gollum.tnic>
	<20070427172230.94b82829.akpm@linux-foundation.org>
	<20070428055740.GA4957@gollum.tnic>
	<20070428062516.GB4957@gollum.tnic>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 08:25:17 +0200 Borislav Petkov <bbpetkov@yahoo.de> wrote:

> > __attribute__ __address_will_be_overwritten_so_don't_bother_warning_me__?
> > 
> > /me going to read gcc docs...
> 
> Sorry, no such thing in the docs to do
> 
> spinlock_t __attribute__((__uninitialized__)) *ptl;
> 
> in order to suppress warnings.

Bummer.  Thanks for checking.

> But if function size is our concern here, even
> shorter would be:
> 
> Index: linux-mm/mm/memory.c
> ===================================================================
> --- linux-mm.orig/mm/memory.c    2007-04-26 19:57:14.000000000 +0200
> +++ linux-mm/mm/memory.c 2007-04-26 20:00:30.000000000 +0200
> @@ -1488,7 +1488,7 @@
>         pte_t *pte;
>         int err;
>         struct page *pmd_page;
> -       spinlock_t *ptl;
> +       spinlock_t *ptl = 0;
> 
>         pte = (mm == &init_mm) ?
>                 pte_alloc_kernel(pmd, addr) :

hm, that'll have the same seven-byte cost as `= NULL;', won't it?
