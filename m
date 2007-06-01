Return-Path: <linux-kernel-owner+w=401wt.eu-S1763300AbXFATrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763300AbXFATrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762477AbXFATrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:47:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48854 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762441AbXFATrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:47:35 -0400
Date: Fri, 1 Jun 2007 21:47:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, andrew.vasquez@qlogic.com
Subject: Re: [PATCH] quiet down swiotlb warnings
Message-ID: <20070601194734.GJ7217@one.firstfloor.org>
References: <466057B1.9090309@redhat.com> <p73odjzbism.fsf@bingen.suse.de> <20070601181225.GA16460@infradead.org> <20070601193703.GI7217@one.firstfloor.org> <466075D1.8080807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466075D1.8080807@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 03:38:57PM -0400, Rik van Riel wrote:
> Andi Kleen wrote:
> 
> >An pci_map_sg failing typically leads to an IO error and we've
> >always printk'ed those. Otherwise people will wonder why they
> >get EIO.
> 
> In some situations.  In this case the qla2xxx driver uses
> the pci_map_sg() failure as a throttling mechanism and

First WTF does it need swiotlb anyways? QA hardware should
be definitely DAC capable, shouldn't it?

> printing out all the warnings will actually slow down the
> system.

Another reason is that there is a lot of code that
still doesn't check the return values and when that
happens you might get data corruption too.

> 
> Andi, what do you propose as a solution?

A different interface; like I wrote in my earlier mail.

Another probabibility would be to have a blocking interface
to swiotlb that won't fail. That would be the better solution
long term, but i was told it is hard to fit into some current
driver interfaces.

-Andi
