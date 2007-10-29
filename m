Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbXJ2KMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbXJ2KMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 06:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXJ2KMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 06:12:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42503 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbXJ2KMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 06:12:07 -0400
Subject: Re: vm_ops.page_mkwrite() fails with vmalloc on 2.6.23
From: Peter Zijlstra <peterz@infradead.org>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, stefani@seibold.net,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       linux-mm@kvack.org, Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <45a44e480710290117u492dbe82ra6344baf8bb1e370@mail.gmail.com>
References: <1193064057.16541.1.camel@matrix>
	 <20071029004002.60c7182a.akpm@linux-foundation.org>
	 <45a44e480710290117u492dbe82ra6344baf8bb1e370@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 11:11:57 +0100
Message-Id: <1193652717.27652.45.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-29 at 01:17 -0700, Jaya Kumar wrote:
> On 10/29/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Mon, 22 Oct 2007 16:40:57 +0200 Stefani Seibold <stefani@seibold.net> wrote:
> > >
> > > The problem original occurs with the fb_defio driver (driver/video/fb_defio.c).
> > > This driver use the vm_ops.page_mkwrite() handler for tracking the modified pages,
> > > which will be in an extra thread handled, to perform the IO and clean and
> > > write protect all pages with page_clean().
> > >
> 
> Hi,
> 
> An aside, I just tested that deferred IO works fine on 2.6.22.10/pxa255.
> 
> I understood from the thread that PeterZ is looking into page_mkclean
> changes which I guess went into 2.6.23. I'm also happy to help in any
> way if the way we're doing fb_defio needs to change.

Yeah, its the truncate race stuff introduced by Nick in
  d0217ac04ca6591841e5665f518e38064f4e65bd

I'm a bit at a loss on how to go around fixing this. One ugly idea I had
was to check page->mapping before going into page_mkwrite() and when
that is null, don't bother with the truncate check.



