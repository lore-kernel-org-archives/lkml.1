Return-Path: <linux-kernel-owner+w=401wt.eu-S933245AbXF2Fdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbXF2Fdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 01:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbXF2Fdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 01:33:41 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:32801 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbXF2Fdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 01:33:40 -0400
Date: Fri, 29 Jun 2007 01:22:43 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: ye janboe <janboe.ye@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: is this a bug of elf_core_dump
Message-ID: <20070629052243.GA9495@fattire.cabal.ca>
References: <af3ea28a0706282203r16764118vd163cb48a25d9d99@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af3ea28a0706282203r16764118vd163cb48a25d9d99@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 01:03:06PM +0800, ye janboe wrote:
> 			if (get_user_pages(current, current->mm, addr, 1, 0, 
> 			1,
> 						&page, &vma) <= 0) {
> 				DUMP_SEEK(PAGE_SIZE);
> 			} else {
> 
> 
> does get_user_pages directly use page variable which is not
> initialized is a bug?
> 

Why not look at mm/memory.c::get_user_pages and look at how it uses the
**pages argument? The fact that it is passing in the address of a
pointer to a struct page, along with the function name should be a big
hint as to what it is doing...

<spoiler>
more or less it is looking up the struct page pointer for the user address
passed in and returning it to the calling function via &page...
</spoiler>

Chees,
	Kyle M
