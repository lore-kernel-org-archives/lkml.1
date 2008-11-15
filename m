Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbYKOU1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbYKOU1Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 15:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYKOU07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 15:26:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:55031 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbYKOU06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 15:26:58 -0500
Date: Sat, 15 Nov 2008 12:27:46 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org, htejun@gmail.com, akpm@linux-foundation.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] Fix kunmap() argument in sg_miter_stop
Message-ID: <20081115122746.75a0f2e3@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0811152003360.1618@blonde.site>
References: <20081115112751.1d38c072@infradead.org>
	<Pine.LNX.4.64.0811152003360.1618@blonde.site>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Nov 2008 20:15:15 +0000 (GMT)
Hugh Dickins <hugh@veritas.com> wrote:

> On Sat, 15 Nov 2008, Arjan van de Ven wrote:
> > >From fd5530ac75a919a20bf7951e90a2b12323e9c0a0 Mon Sep 17 00:00:00
> > >2001
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Sat, 15 Nov 2008 11:23:58 -0800
> > Subject: [PATCH] Fix kunmap() argument in sg_miter_stop
> > 
> > kunmap() takes as argument the struct page that orginally got
> > kmap()'d, however the sg_miter_stop() function passed it the kernel
> > virtual address instead, resulting in "kernel BUG at
> > arch/x86/mm/highmem_32.c:115!"
> 
> Your patch looks like a good fix to me, but I don't get how its bug
> would manifest as highmem_32.c:115 - that's a check in
> kunmap_atomic(), whereas you're fixing a bad address to kunmap().
> 

blarg

this is a new dimension to "off by one bug" L(


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
