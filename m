Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYKZRyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYKZRyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYKZRyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:54:39 -0500
Received: from sous-sol.org ([216.99.217.87]:52458 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752239AbYKZRyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:54:38 -0500
Date: Wed, 26 Nov 2008 09:54:27 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Greg KH <greg@kroah.com>
Cc: Yu Zhao <yu.zhao@intel.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [SR-IOV driver example 2/3] PF driver: integrate with SR-IOV
	core
Message-ID: <20081126175427.GE19881@sequoia.sous-sol.org>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <20081126140303.GA13641@yzhao12-linux.sh.intel.com> <20081126142156.GB13668@yzhao12-linux.sh.intel.com> <20081126165859.GA28251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126165859.GA28251@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> > +static	int
> > +igb_virtual(struct pci_dev *pdev, int nr_virtfn)
> > +{
> > +	unsigned char my_mac_addr[6] = {0x00, 0xDE, 0xAD, 0xBE, 0xEF, 0xFF};
> > +	struct net_device *netdev = pci_get_drvdata(pdev);
> > +	struct igb_adapter *adapter = netdev_priv(netdev);
> > +	int i;
> > +
> > +	if (nr_virtfn > 7)
> > +		return -EINVAL;
> 
> Why the check for 7?  Is that the max virtual functions for this card?
> Shouldn't that be a define somewhere so it's easier to fix in future
> versions of this hardware?  :)

IIRC it's 8 for the card, 1 reserved for PF.  I think both notions
should be captured w/ commented constants.

thanks,
-chris
