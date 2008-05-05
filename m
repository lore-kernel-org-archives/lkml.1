Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbYEEVOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbYEEVOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760278AbYEEVOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:14:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760000AbYEEVOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:14:40 -0400
Date: Mon, 5 May 2008 14:13:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: bunk@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [2.6 patch] mm/page_alloc.c: cleanups
Message-Id: <20080505141352.703dbee8.akpm@linux-foundation.org>
In-Reply-To: <2f11576a0805051359g7614f5f1l9d184539c715fff4@mail.gmail.com>
References: <20080505182542.GS17139@cs181133002.pp.htv.fi>
	<2f11576a0805051324r46d3ab03ybf14a289d9841cb6@mail.gmail.com>
	<20080505134509.2c8a9b94.akpm@linux-foundation.org>
	<2f11576a0805051359g7614f5f1l9d184539c715fff4@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 05:59:31 +0900
"KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com> wrote:

> >  > >  -void free_cold_page(struct page *page)
> >  > >  -{
> >  > >  -       free_hot_cold_page(page, 1);
> >  > >  -}
> >  >
> >  > Wow, I didn't know nobody use cold page :)
> >
> >  that's a bug, surely?  I bet there are plenty of places which should be
> >  using this hint.
> 
> Hm, as far as I investigate
> 
> 1. nobody used free_cold_page() in kernel code tree.
> 2. free_cold_page() doesn't exported.
> 
> I investigated to 2.6.25-mm1.
> I don't understand yet why you think plenty....

Any place in the kernel which frees a page which is probably cache-cold
should be using this function.  (Including any place which caused the page
to be evicted from CPU cache by placing it under DMA).

But nobody thinks about providing the hint.

Probably it doesn't matter much at all, except in those few places which
free a lot of pages.

