Return-Path: <linux-kernel-owner+w=401wt.eu-S1763048AbXFASMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763048AbXFASMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762916AbXFASM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:12:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35387 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761731AbXFASM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:12:28 -0400
Date: Fri, 1 Jun 2007 19:12:25 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, andrew.vasquez@qlogic.com
Subject: Re: [PATCH] quiet down swiotlb warnings
Message-ID: <20070601181225.GA16460@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	andrew.vasquez@qlogic.com
References: <466057B1.9090309@redhat.com> <p73odjzbism.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73odjzbism.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 09:01:45PM +0200, Andi Kleen wrote:
> Bad idea imho. swiotlb mappings should always lead to printk by default
> because it is pretty dangerous.
> 
> One possible solution for this I could think of would be to define a
> new pci_map_sg_couldfail() or similar that doesn't warn and use a weak
> fallback just calling pci_map_sg on other IOMMU implementations. 

pci_map_sg is defined to be failing when running out of ressources, which
is perfectly fine.  We don't printk on kmalloc failures either (actually
in some cases which is highly annoying and leads people to stick a
__GFP_NOWARN into various places)

