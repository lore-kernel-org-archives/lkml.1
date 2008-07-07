Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbYGGQCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbYGGQCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYGGQCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:02:32 -0400
Received: from colo.lackof.org ([198.49.126.79]:59196 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbYGGQCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:02:31 -0400
Date: Mon, 7 Jul 2008 10:02:03 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Michael Ellerman <michael@ellerman.id.au>, linux-pci@vger.kernel.org,
       kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu, tglx@linutronix.de,
       davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] PCI MSI: Store the number of messages in the
	msi_desc
Message-ID: <20080707160203.GA7521@colo.lackof.org>
References: <20080705132728.GO14894@parisc-linux.org> <1215264855-4372-1-git-send-email-matthew@wil.cx> <1215396324.19157.14.camel@localhost> <20080707024125.GU14894@parisc-linux.org> <1215402512.9862.16.camel@localhost> <20080707120418.GZ14894@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080707120418.GZ14894@parisc-linux.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 06:04:18AM -0600, Matthew Wilcox wrote:
> On Mon, Jul 07, 2008 at 01:48:32PM +1000, Michael Ellerman wrote:
> > Yeah seriously :)  The _ is part of it, but MSI_ATTRIB is uglier than
> > PCI_CAP_ID_MSI exactly because it's not PCI_CAP_ID_MSI, which exists and
> > is well defined and is used in the rest of the code.
> 
> Here's an improvement over both the status quo and my patch -- simply
> use a single bit called is_msix.

I prefer the "is_msix" for readability though I'm not particularly fond
of bit fields (in any form).


...
> @@ -589,12 +558,13 @@ void pci_msi_shutdown(struct pci_dev* dev)
>  		u32 mask = entry->msi_attrib.maskbits_mask;
>  		msi_set_mask_bits(dev->irq, mask, ~mask);
>  	}
> -	if (!entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI)
> +	if (!entry->dev || entry->msi_attrib.is_msix)
>  		return;

This is why I don't like bit fields.
"uninitialized" (3rd state) doesn't exist.
Is there something else in place to catch that state?

(It's clearly a bug if someone did that and maybe I'm
being too paranoid.)

hth,
grant
