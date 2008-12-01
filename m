Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbYLAMk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbYLAMk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYLAMkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:40:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:48063 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbYLAMkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:40:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,695,1220252400"; 
   d="scan'208";a="469761752"
Date: Tue, 2 Dec 2008 00:44:27 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Greg KH <greg@kroah.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [SR-IOV driver example 2/3] PF driver: integrate with SR-IOV
	core
Message-ID: <20081201164427.GB1464@yzhao12-linux.sh.intel.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <20081126140303.GA13641@yzhao12-linux.sh.intel.com> <20081126142156.GB13668@yzhao12-linux.sh.intel.com> <20081126165859.GA28251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126165859.GA28251@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 12:58:59AM +0800, Greg KH wrote:
> On Wed, Nov 26, 2008 at 10:21:56PM +0800, Yu Zhao wrote:
> > +			my_mac_addr[5] = (unsigned char)i;
> > +			igb_set_vf_mac(netdev, i, my_mac_addr);
> > +			igb_set_vf_vmolr(adapter, i);
> > +		}
> > +	} else
> > +		printk(KERN_INFO "SR-IOV is disabled\n");
> 
> Is that really true?  (oh, use dev_info as well.)  What happens if you
> had called this with "5" and then later with "0", you never destroyed
> those existing virtual functions, yet the code does:
> 
> > +	adapter->vfs_allocated_count = nr_virtfn;
> 
> Which makes the driver think they are not present.  What happens when
> the driver later goes to shut down?  Are those resources freed up
> properly?

For now we hard-code the tx/rx queues allocation so this doesn't
matter. Eventually this will become dynamic allocation: when number
of VFs changes the corresponding resources need to be freed.

I'll put more comments here.

Thanks,
Yu
