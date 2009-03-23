Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbZCWFVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbZCWFVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 01:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZCWFV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 01:21:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:64280 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbZCWFV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 01:21:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,406,1233561600"; 
   d="scan'208";a="499961793"
Date: Mon, 23 Mar 2009 13:22:08 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/6] ATS capability support for Intel IOMMU
Message-ID: <20090323052208.GA1803@yzhao-otc.sh.intel.com>
References: <1234443038-15437-1-git-send-email-yu.zhao@intel.com> <20090319193043.583ad601@hobbes.lan> <49C303B5.5040707@intel.com> <1237547751.16570.27.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237547751.16570.27.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 07:15:51PM +0800, David Woodhouse wrote:
> On Fri, 2009-03-20 at 10:47 +0800, Zhao, Yu wrote:
> > If it's possible, I'd like it go through the PCI tree because the ATS 
> > depends on the SR-IOV. This dependency is not reflected in this v3 
> > series since the SR-IOV is not in-tree and I don't want to break the 
> > build after people apply the ATS on their tree.
> 
> In what way will it depend on SR-IOV?

The SR-IOV spec section 3.7.4 says that the Smallest Translation Unit and
the Invalidate Queue Depth fields in the Virtual Function's ATS capability
are hard-wired to 0. So we need some special handling when enabling the ATS
capability for the Virtual Function.

                  Table 3-26: ATS Capability Register
-------------+-----------------------------------------+---------------+--------------
Bit Location | PF and VF Register Differences From ATS | PF Attributes | VF Attributes
-------------+-----------------------------------------+---------------+--------------
             |    Smallest Translation Unit (STU)      |               |
   20:16     |    Hardwired to 0 for VFs.              |      ATS      |      RO
             |    PF value applies to all VFs.         |               |
-------------+-----------------------------------------+---------------+--------------
             |    Invalidate Queue Depth               |               |
   28:24     |    Hardwired to 0 for VFs.              |      ATS      |      RO
             |    Depth of shared PF input queue.      |               |
-------------+-----------------------------------------+---------------+--------------

> > So Dave, can I get an ack from you and let Jesse pull the IOMMU change
> > to his tree? Or let this ATS go to 2.6.31?
> 
> Want to show the latest version of the patches which depend on SR-IOV,
> and I can ack them?

Sure, thanks!
