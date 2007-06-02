Return-Path: <linux-kernel-owner+w=401wt.eu-S1761833AbXFBQrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761833AbXFBQrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 12:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbXFBQrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 12:47:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39027 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542AbXFBQrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 12:47:07 -0400
Date: Sat, 2 Jun 2007 18:47:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Andrew Vasquez <andrew.vasquez@qlogic.com>,
       Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] quiet down swiotlb warnings
Message-ID: <20070602164704.GQ7217@one.firstfloor.org>
References: <p73odjzbism.fsf@bingen.suse.de> <20070601181225.GA16460@infradead.org> <20070601193703.GI7217@one.firstfloor.org> <466075D1.8080807@redhat.com> <20070601194734.GJ7217@one.firstfloor.org> <20070601200049.GK12143@andrew-vasquezs-computer.local> <20070601201444.GK7217@one.firstfloor.org> <46607F96.7060200@redhat.com> <20070601202601.GM7217@one.firstfloor.org> <20070602152146.GE4342@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070602152146.GE4342@rhun.haifa.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2007 at 06:21:46PM +0300, Muli Ben-Yehuda wrote:
> On Fri, Jun 01, 2007 at 10:26:01PM +0200, Andi Kleen wrote:
> 
> > Normally swiotlb doesn't even try to bounce when dma mask is <=
> > end_pfn so something must be very wrong in your kernel. It
> > definitely isn't a mainline kernel. If this happens in Xen then Xen
> > just needs fixing -- it should not try to bounce when the normal
> > kernel wouldn't.
> 
> Xen needs to bounce when the requested buffer is not contiguous in
> machine memory (and indeed uses swiotlb for that).

Then it should just restrict the sg list merging at the block layer
to never merge into anything larger than a page. Then this cannot
happen or only very rarely.

-Andi
