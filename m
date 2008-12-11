Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYLKBo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYLKBo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 20:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbYLKBoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 20:44:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:47077 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbYLKBoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 20:44:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,749,1220252400"; 
   d="scan'208";a="472952610"
Date: Thu, 11 Dec 2008 09:43:13 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 16/16 v6] PCI: document the new PCI boot parameters
Message-ID: <20081211014313.GA4947@yzhao12-linux.sh.intel.com>
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <20081022084531.GP3773@yzhao12-linux.sh.intel.com> <20081106043235.GA30292@kroah.com> <4913AA03.5060807@intel.com> <20081107025032.GA12824@kroah.com> <4913B8A5.5010806@intel.com> <20081107041721.GB15439@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107041721.GB15439@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 12:17:22PM +0800, Matthew Wilcox wrote:
> On Fri, Nov 07, 2008 at 11:40:21AM +0800, Zhao, Yu wrote:
> > Greg KH wrote:
> > >We've thought about this in the past, and even Microsoft said it was
> > >going to happen for Vista, but they realized in the end, like we did a
> > >few years previously, that it would require full support of all PCI
> > >drivers as well (if you rebalance stuff that is already bound to a
> > >driver.)  So they dropped it.
> > >
> > >When would you want to do this kind of rebalancing?  Before any PCI
> > >driver is bound to any devices?  Or afterwards?
> > 
> > I guess if we want the rebalance dynamic, then we should have it full -- 
> > the rebalance would be functional even after the driver is loaded.
> > 
> > But in most cases, there will be problem when we unload driver from a 
> > hard disk controller, etc. We can mount root on a ramdisk and do the 
> > rebalance there, but it's complicated for a real user.
> > 
> > So looks like doing rebalancing before any driver is bound to any device 
> > is also a nice idea, if user can get a shell to do rebalance before 
> > built-in PCI driver grabs device.
> 
> Can we use the suspend/resume code to do this?  Some drivers (sym2 for
> one) would definitely need to rerun some of their init code to cope with
> a BAR address changing.

Yes, that is what I was thinking. But after some grep on the PCI device
drivers, I feel frustrated because all those drivers only do 'ioremap'
once at the 'probe' stage.

I believe this is the only problem that preclude us having the run-time
resource rebalance. And I'm not sure how much effort we can fix it. Any
comments?


Thanks,
Yu
