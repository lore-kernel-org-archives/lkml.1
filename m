Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZCII2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZCII2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 04:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbZCII22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 04:28:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:19066 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbZCII21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 04:28:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,328,1233561600"; 
   d="scan'208";a="496177560"
Date: Mon, 9 Mar 2009 16:29:30 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Matthew Wilcox <matthew@wil.cx>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 4/7] PCI: add SR-IOV API for Physical Function
	driver
Message-ID: <20090309082930.GE4638@yzhao-otc.sh.intel.com>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-5-git-send-email-yu.zhao@intel.com> <20090306203717.GG25995@parisc-linux.org> <49B19A31.6070205@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B19A31.6070205@xenotime.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot, Randy!

On Sat, Mar 07, 2009 at 05:48:33AM +0800, Randy Dunlap wrote:
> Matthew Wilcox wrote:
> > On Fri, Feb 20, 2009 at 02:54:45PM +0800, Yu Zhao wrote:
> > 
> >> +	if (nres != iov->nres) {
> >> +		dev_err(&dev->dev, "no enough MMIO for SR-IOV\n");
> >> +		return -ENOMEM;
> >> +	}
> 
> 		"not enough MMIO BARs for SR-IOV"
> 	or
> 		"not enough MMIO resources for SR-IOV"
> 	or
> 		"too few MMIO BARs for SR-IOV"
> ?
> 
> > Randy, can you help us out with better wording here?
> > 
> >> +		dev_err(&dev->dev, "no enough bus range for SR-IOV\n");
> > 
> > and here.
> 
> 		"SR-IOV: bus number too large"
> 	or
> 		"SR-IOV: bus number out of range"
> 	or
> 		"SR-IOV: cannot allocate valid bus number"
> ?
> 
> >> +	if (iov->link != dev->devfn) {
> >> +		rc = -ENODEV;
> >> +		list_for_each_entry(link, &dev->bus->devices, bus_list) {
> >> +			if (link->sriov && link->devfn == iov->link)
> >> +				rc = sysfs_create_link(&iov->dev.kobj,
> >> +						&link->dev.kobj, "dep_link");
