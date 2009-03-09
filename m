Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbZCIIMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbZCIIMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 04:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbZCIIMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 04:12:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:13542 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbZCIIMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 04:12:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,328,1233561600"; 
   d="scan'208";a="496174710"
Date: Mon, 9 Mar 2009 16:13:37 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 3/7] PCI: reserve bus range for SR-IOV device
Message-ID: <20090309081337.GB4638@yzhao-otc.sh.intel.com>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-4-git-send-email-yu.zhao@intel.com> <20090306202024.GF25995@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306202024.GF25995@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 04:20:24AM +0800, Matthew Wilcox wrote:
> On Fri, Feb 20, 2009 at 02:54:44PM +0800, Yu Zhao wrote:
> > +static inline void virtfn_bdf(struct pci_dev *dev, int id, u8 *busnr, u8 *devfn)
> > +{
> > +	u16 bdf;
> > +
> > +	bdf = (dev->bus->number << 8) + dev->devfn +
> > +	      dev->sriov->offset + dev->sriov->stride * id;
> > +	*busnr = bdf >> 8;
> > +	*devfn = bdf & 0xff;
> > +}
> 
> I find the interface here a bit clunky -- a function returning void
> while having two OUT parameters.  How about this variation on the theme
> (viewers are encouraged to come up with their own preferred
> implementations and interfaces):
> 
> static inline __pure u16 virtfn_bdf(struct pci_dev *dev, int id)
> {
> 	return (dev->bus->number << 8) + dev->devfn + dev->sriov->offset +
> 		dev->sriov->stride * id;
> }
> 
> #define VIRT_BUS(dev, id)	(virtfn_bdf(dev, id) >> 8)
> #define VIRT_DEVFN(dev, id)	(virtfn_bdf(dev, id) & 0xff)
> 
> We rely on GCC to do CSE and not actually invoke virtfn_bdf more than
> once.

Yes, that's a good idea. Will replace that function with macros.
