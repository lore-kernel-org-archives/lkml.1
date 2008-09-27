Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbYI0C4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbYI0C4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 22:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbYI0C4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 22:56:33 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34931 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbYI0C4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 22:56:33 -0400
Date: Fri, 26 Sep 2008 20:56:14 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: introduce an ioremap_pcibar(pdev, barnr) function
Message-ID: <20080927025614.GK27204@parisc-linux.org>
References: <20080926163641.288bf868@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926163641.288bf868@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 04:36:41PM -0700, Arjan van de Ven wrote:
> A common thing in many PCI drivers is to ioremap() an entire bar.
> This is a slightly fragile thing right now, needing both an address and a size,
> and many driver writers do.. various things there.
> 
> This patch introduces an ioremap_pcibar() function taking just a PCI device struct
> and the bar number as arguments, and figures this all out itself, in one place.
> In addition, we can add various sanity checks to this function (the patch already
> checks to make sure that the bar in question really is a MEM bar; few to no drivers
> do that sort of thing).

So we already have a pci_iomap() which takes a 'max' argument.  If you
make 'max' -1, don't you get this same behaviour?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
