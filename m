Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbZIYIZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbZIYIZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbZIYIZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:25:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbZIYIZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:25:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <7d86d44a0909242139v32a0ef6bh68386cbda31d0682@mail.gmail.com>
References: <7d86d44a0909242139v32a0ef6bh68386cbda31d0682@mail.gmail.com> <20090924141310.19746.31678.stgit@warthog.procyon.org.uk>
To: graff yang <graff.yang@gmail.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Paul Mundt <lethal@linux-sh.org>, Mel Gorman <mel@csn.ul.ie>,
       Greg Ungerer <gerg@snapgear.com>
Subject: Re: [PATCH] NOMMU: Fix MAP_PRIVATE mmap() of objects where the data can be mapped directly
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Date: Fri, 25 Sep 2009 09:24:27 +0100
Message-ID: <11260.1253867067@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

graff yang <graff.yang@gmail.com> wrote:

> > +       if (capabilities & BDI_CAP_MAP_DIRECT) {
> 
> This will breaks many drivers, e.g. some frame-buffer drivers, on NOMMU
> system.  Because they don't have get_unmapped_area().  These drivers depend
> on it's mmap() to return the frame-buffer base address.

Then they won't work on NOMMU.  Read Documentation/nommu-mmap.txt:

	============================================
	PROVIDING SHAREABLE CHARACTER DEVICE SUPPORT
	============================================

	To provide shareable character device support, a driver must provide a
	file->f_op->get_unmapped_area() operation. The mmap() routines will
	call this to get a proposed address for the mapping. This may return an
	error if it doesn't wish to honour the mapping because it's too long,
	at a weird offset, under some unsupported combination of flags or
	whatever.

The chardev driver doesn't provide the virtual address through its mmap() fop
in MMU-mode either - that's provided by do_mmap_pgoff().

David
