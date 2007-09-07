Return-Path: <linux-kernel-owner+w=401wt.eu-S965138AbXIGBEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965138AbXIGBEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 21:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964907AbXIGBEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 21:04:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:45322 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964898AbXIGBEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 21:04:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,218,1186383600"; 
   d="scan'208";a="295764851"
Subject: Re: [RFC] disable PCIE 'Enable No Snoop' bit by default
From: Shaohua Li <shaohua.li@intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
In-Reply-To: <20070906115730.GE14130@parisc-linux.org>
References: <1189056908.24368.9.camel@sli10-conroe.sh.intel.com>
	 <20070906115730.GE14130@parisc-linux.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 07 Sep 2007 08:51:27 +0800
Message-Id: <1189126287.14845.4.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-06 at 05:57 -0600, Matthew Wilcox wrote:
> On Thu, Sep 06, 2007 at 01:35:08PM +0800, Shaohua Li wrote:
> > PCIE 'Enable No Snoop' bit is set by default per PCIE spec, but OS
> > assumes PCI DMA is snooped, which is legacy PCI device does. Enabling no
> > snoop might cause potential DMA issues. This patch disables it, if a
> > driver can work with no snoop, we can provide a helper to enable it.
> 
> I'm not sure your analysis is correct.  Here's what my draft copy of
> the pcie 2.0 spec says:
> 
>   Enble No Snoop ­ If this bit is Set, the Function is permitted to
>   Set the No Snoop bit in the Requester Attributes of transactions it
>   initiates that do not require hardware enforced cache coherency (see
>   Section 2.2.6.5). Note that setting this bit to 1b should not cause
>   a Function to Set the No Snoop attribute on all transactions that it
>   initiates. Even when this bit is Set, a Function is only permitted
>   to Set the No Snoop attribute on a transaction when it can guarantee
>   that the address of the transaction is not stored in any cache in
>   the system.  This bit permitted to be hardwired to 0b if a Function
>   would never Set the No Snoop attribute in transactions it initiates.
>   Default value of this bit is 1b.
> 
> That implies that devices are only allowed to set it when it's safe to
> do so ... and we don't need to turn it off.
Yes, I saw this in spec too. Devices don't know how OS handle DMA, so
it's possible the bit is wrongly set. My point is setting the bit can be
done by driver based. If a driver thinks it's really safe to do so, it
can set the bit.

Thanks,
Shaohua
