Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYJVOvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYJVOvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYJVOvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:51:18 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:13703 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbYJVOvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:51:16 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yu Zhao <yu.zhao@uniscape.net>
Subject: Re: [PATCH 2/16 v6] PCI: define PCI resource names in an 'enum'
Date: Wed, 22 Oct 2008 08:51:11 -0600
User-Agent: KMail/1.9.9
Cc: Yu Zhao <yu.zhao@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <200810220824.21356.bjorn.helgaas@hp.com> <48FF3C48.9060809@uniscape.net>
In-Reply-To: <48FF3C48.9060809@uniscape.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810220851.13413.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 October 2008 08:44:24 am Yu Zhao wrote:
> Bjorn Helgaas wrote:
> > On Wednesday 22 October 2008 02:40:41 am Yu Zhao wrote:
> >> This patch moves all definitions of the PCI resource names to an 'enum',
> >> and also replaces some hard-coded resource variables with symbol
> >> names. This change eases introduction of device specific resources.
> > 
> > Thanks for removing a bunch of magic numbers from the code.
> > 
> >>  static void
> >>  pci_restore_bars(struct pci_dev *dev)
> >>  {
> >> -	int i, numres;
> >> -
> >> -	switch (dev->hdr_type) {
> >> -	case PCI_HEADER_TYPE_NORMAL:
> >> -		numres = 6;
> >> -		break;
> >> -	case PCI_HEADER_TYPE_BRIDGE:
> >> -		numres = 2;
> >> -		break;
> >> -	case PCI_HEADER_TYPE_CARDBUS:
> >> -		numres = 1;
> >> -		break;
> >> -	default:
> >> -		/* Should never get here, but just in case... */
> >> -		return;
> >> -	}
> >> +	int i;
> >>  
> >> -	for (i = 0; i < numres; i++)
> >> +	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++)
> >>  		pci_update_resource(dev, i);
> >>  }
> > 
> > The behavior of this function used to depend on dev->hdr_type.  Now
> > we don't look at hdr_type at all, so we do the same thing for all
> > devices.
> > 
> > For example, for a CardBus device, we used to call pci_update_resource()
> > only for BAR 0; now we call it for BARs 0-6.
> > 
> > Maybe this is safe, but I can't tell from the patch, so I think you
> > should explain *why* it's safe in the changelog.
> 
> It's safe because pci_update_resource() will ignore unused resources. 
> E.g., for a Cardbus, only BAR 0 is used and its 'flags' is set, then 
> pci_update_resource() only updates it. BAR 1-6 are ignored since their 
> 'flags' are 0.
> 
> I'll put more explanation in the changelog.

This is a logically separate change from merely substituting enum
names for magic numbers, so you might even consider splitting it
into a separate patch.  Better bisection and all that, you know :-)

Bjorn
