Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbXEIJqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbXEIJqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbXEIJqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:46:02 -0400
Received: from canuck.infradead.org ([209.217.80.40]:54682 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbXEIJqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:46:00 -0400
Date: Wed, 9 May 2007 02:44:18 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: cornelia.huck@de.ibm.com, torvalds@linux-foundation.org, bunk@stusta.de,
       linux-kernel@vger.kernel.org
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
	(PCI_MULTITHREAD_PROBE)
Message-ID: <20070509094418.GA13245@kroah.com>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com> <20070508140753.GB12641@kroah.com> <20070508.135810.48808124.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508.135810.48808124.davem@davemloft.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 01:58:10PM -0700, David Miller wrote:
> From: Greg KH <greg@kroah.com>
> Date: Tue, 8 May 2007 07:07:53 -0700
> 
> > Only if it ends up working properly.  The commit you reference above
> > (which removed the PCI_MULTITHREAD_PROBE option), is fine, pci
> > multi-threaded probing is still broken as it is a model that PCI drivers
> > are not yet ready to handle properly yet.
> 
> FWIW I would like to see this working properly at some point.
> 
> It seems to me that the issues are two-fold:
> 
> 1) A proper dependency system is necessary
> 
> 2) Proper mutual exclusion for shared system resources/registers/etc.
>    that are poked at in an ad-hoc unlocked manner currently
> 
> Is that basically what it boils down to?

Yes, that's about it.

Number 1 seemed to cause the most crashes, I don't think number 2 ever
caused any problems, but it might have, there were too many weird oopses
to be able to rule that out.

But in the end, I don't think that PCI really will benefit from this
speed wise, but I think the kernel overall will benefit if we can
document those dependencies somehow.

thanks,

greg k-h
