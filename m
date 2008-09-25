Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbYIYPyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbYIYPyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 11:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYIYPxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 11:53:55 -0400
Received: from colo.lackof.org ([198.49.126.79]:40682 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbYIYPxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 11:53:54 -0400
Date: Thu, 25 Sep 2008 09:53:43 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: David Miller <davem@davemloft.net>
Cc: grundler@parisc-linux.org, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Notes from LPC PCI/MSI BoF session
Message-ID: <20080925155343.GC2997@colo.lackof.org>
References: <200809221229.18501.jbarnes@virtuousgeek.org> <20080924055116.GA3101@colo.lackof.org> <20080923.234705.261909334.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923.234705.261909334.davem@davemloft.net>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 11:47:05PM -0700, David Miller wrote:
> From: Grant Grundler <grundler@parisc-linux.org>
> Date: Tue, 23 Sep 2008 23:51:16 -0600
> 
> > Dave Miller (and others) have clearly stated they don't want to see
> > CPU affinity handled in the device drivers and want irqbalanced
> > to handle interrupt distribution. The problem with this is irqbalanced
> > needs to know how each device driver is binding multiple MSI to it's queues.
> > Some devices could prefer several MSI go to the same processor and
> > others want each MSI bound to a different "node" (NUMA).
> > 
> > Without any additional API, this means the device driver has to
> > update irqbalanced for each device it supports. We thought pci_ids.h
> > was a PITA...that would be trivial compared to maintaining this.
> 
> We just need a consistent naming scheme for the IRQs to disseminate
> this information to irqbalanced, then there is one change to irqbalanced
> rather than one for each and every driver as you seem to suggest.

That's sort of what I proposed at the end of my email:
| A second solution I thought of later might be for the device driver to
| export (sysfs?) to irqbalanced which MSIs the driver instance owns and
| how many "domains" those MSIs can serve.  irqbalanced can then write
| back into the same (sysfs?) the mapping of MSI to domains and update
| the smp_affinity mask for each of those MSI.

> Anything that's complicated and takes more than a paragraph or two
> to describe is not what we want.

I agree. The discussion will need more though.

thanks,
grant

> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
