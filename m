Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbXF3KnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbXF3KnA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 06:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbXF3Kmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 06:42:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44091 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbXF3Kmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 06:42:51 -0400
Date: Sat, 30 Jun 2007 11:42:44 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] fsblock
Message-ID: <20070630104244.GC24123@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jeff Garzik <jeff@garzik.org>, Nick Piggin <npiggin@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-fsdevel@vger.kernel.org
References: <20070624014528.GA17609@wotan.suse.de> <467DE00A.9080700@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467DE00A.9080700@garzik.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 11:07:54PM -0400, Jeff Garzik wrote:
> >- In line with the above item, filesystem block allocation is performed
> >  before a page is dirtied. In the buffer layer, mmap writes can dirty a
> >  page with no backing blocks which is a problem if the filesystem is
> >  ENOSPC (patches exist for buffer.c for this).
> 
> This raises an eyebrow...  The handling of ENOSPC prior to mmap write is 
> more an ABI behavior, so I don't see how this can be fixed with internal 
> changes, yet without changing behavior currently exported to userland 
> (and thus affecting code based on such assumptions).

Not really, the current behaviour is a bug.  And it's not actually buffer
layer specific - XFS now has a fix for that bug and it's generic enough
that everyone could use it.

