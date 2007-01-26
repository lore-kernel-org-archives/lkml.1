Return-Path: <linux-kernel-owner+w=401wt.eu-S933163AbXAZLNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163AbXAZLNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 06:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbXAZLNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 06:13:22 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56194 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933163AbXAZLNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 06:13:21 -0500
Date: Fri, 26 Jan 2007 03:13:00 -0800
From: Andrew Morton <akpm@osdl.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Track mlock()ed pages
Message-Id: <20070126031300.59f75b06.akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0701252234490.11230@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0701252141570.10629@schroedinger.engr.sgi.com>
	<45B9A00C.4040701@yahoo.com.au>
	<Pine.LNX.4.64.0701252234490.11230@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007 22:36:17 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 26 Jan 2007, Nick Piggin wrote:
> 
> > Christoph Lameter wrote:
> > > Add NR_MLOCK
> > > 
> > > Track mlocked pages via a ZVC

Why?

> > I think it is not quite right. You are tracking the number of ptes
> > that point to mlocked pages, which can be >= the actual number of pages.
> 
> Mlocked pages are not inherited. I would expect sharing to be very rare.
>  
> > Also, page_add_anon_rmap still needs to be balanced with page_remove_rmap.
> 
> Hmmm.... 
>  
> > I can't think of an easy way to do this without per-page state. ie.
> > another page flag.
> 
> Thats what I am trying to avoid.

You could perhaps go for a walk across all the other vmas which presently
map this page.  If any of them have VM_LOCKED, don't increment the counter.
Similar on removal: only decrement the counter when the final mlocked VMA
is dropping the pte.

