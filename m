Return-Path: <linux-kernel-owner+w=401wt.eu-S1761237AbZCPVHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761237AbZCPVHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZCPVH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:07:29 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54318 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbZCPVH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:07:29 -0400
Date: Mon, 16 Mar 2009 15:07:26 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 6/6] PCI MSI: Add support for multiple MSI
Message-ID: <20090316210726.GO14127@parisc-linux.org>
References: <1235410082-5016-1-git-send-email-matthew@wil.cx> <1235410082-5016-7-git-send-email-matthew@wil.cx> <1236039373.8230.107.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236039373.8230.107.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 11:16:13AM +1100, Michael Ellerman wrote:
> > diff --git a/arch/powerpc/kernel/msi.c b/arch/powerpc/kernel/msi.c
> > index 3bb7d3d..0c16e2a 100644
> > --- a/arch/powerpc/kernel/msi.c
> > +++ b/arch/powerpc/kernel/msi.c
> > @@ -19,6 +19,10 @@ int arch_msi_check_device(struct pci_dev* dev, int nvec, int type)
> >  		return -ENOSYS;
> >  	}
> >  
> > +	/* PowerPC doesn't support multiple MSI yet */
> > +	if (type == PCI_CAP_ID_MSI && nvec > 1)
> > +		return 1;
> > +
> >  	if (ppc_md.msi_check_device) {
> >  		pr_debug("msi: Using platform check routine.\n");
> >  		return ppc_md.msi_check_device(dev, nvec, type);
> 
> That bit:
> 
> Acked-by: Michael Ellerman <michael@ellerman.id.au>
> 
> I'll tell benh to expect this hunk to show up sometime via Jesse's tree.

Thanks!

> Looks good otherwise, not sure if we'll ever implement it, but good to
> have. Is AHCI the only driver you're planning on using it for ATM?

That's the only one I know where it's important.  I think some PCIe
bridges would like to have multiple MSI.  And I think some hardware
designs (not from Intel, from other companies who've talked to me) are
in the pipe to use multiple MSI, because it's cheaper than using MSI-X.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
