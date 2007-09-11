Return-Path: <linux-kernel-owner+w=401wt.eu-S966128AbXIKGk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966128AbXIKGk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761823AbXIKGjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:39:17 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55159 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761726AbXIKGjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:39:15 -0400
Date: Mon, 10 Sep 2007 23:15:38 -0700
From: Greg KH <greg@kroah.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: David Miller <davem@davemloft.net>, matthew@wil.cx,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       akpm@linux-foundation.org, gregkh@suse.de
Subject: Re: [RFC] disable PCIE 'Enable No Snoop' bit by default
Message-ID: <20070911061538.GE27404@kroah.com>
References: <1189056908.24368.9.camel@sli10-conroe.sh.intel.com> <20070906115730.GE14130@parisc-linux.org> <20070906.054038.74750747.davem@davemloft.net> <20070909164343.GC9199@kroah.com> <1189474183.3080.0.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189474183.3080.0.camel@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 09:29:43AM +0800, Shaohua Li wrote:
> On Sun, 2007-09-09 at 09:43 -0700, Greg KH wrote:
> > On Thu, Sep 06, 2007 at 05:40:38AM -0700, David Miller wrote:
> > > From: Matthew Wilcox <matthew@wil.cx>
> > > Date: Thu, 6 Sep 2007 05:57:31 -0600
> > > 
> > > > I'm not sure your analysis is correct.  Here's what my draft copy of
> > > > the pcie 2.0 spec says:
> > > > 
> > > >   Enble No Snoop ? If this bit is Set, the Function is permitted to
> > > >   Set the No Snoop bit in the Requester Attributes of transactions it
> > > >   initiates that do not require hardware enforced cache coherency (see
> > > >   Section 2.2.6.5). Note that setting this bit to 1b should not cause
> > > >   a Function to Set the No Snoop attribute on all transactions that it
> > > >   initiates. Even when this bit is Set, a Function is only permitted
> > > >   to Set the No Snoop attribute on a transaction when it can guarantee
> > > >   that the address of the transaction is not stored in any cache in
> > > >   the system.  This bit permitted to be hardwired to 0b if a Function
> > > >   would never Set the No Snoop attribute in transactions it initiates.
> > > >   Default value of this bit is 1b.
> > > > 
> > > > That implies that devices are only allowed to set it when it's safe to
> > > > do so ... and we don't need to turn it off.
> > > 
> > > This is my understanding of this area of PCI-E as well, and I
> > > also agree that therefore we should not turn this bit off.
> > 
> > I agree.  But Shaohua, do you see any problems that this patch fixes?
> No, I didn't see any breakage, just worry about it's a potential issue.

Hm, well, if you don't mind, I'd like to leave it as is for now, as no
one is reporting any problems with this, and there seems to be some
disagreement as to if it is really needed or not.

Is that ok?

thanks,

greg k-h
