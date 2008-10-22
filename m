Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbYJVOwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbYJVOwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYJVOwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:52:13 -0400
Received: from outbound-mail-125.bluehost.com ([67.222.38.25]:41972 "HELO
	outbound-mail-125.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752857AbYJVOwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:52:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=uniscape.net;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=G3/gz4jTbjvJDjp8jbK5B8/0Y0xcLBq+qFIjt89R0PQ/wp5lbj1uDpkI+PmApZnbFeTlrA3vypitr/J4rdoVk4Osty1deFVdXA7JvXT2qO3x2GCMMwo6SiiOnSKyKSJS;
Message-ID: <48FF3C48.9060809@uniscape.net>
Date: Wed, 22 Oct 2008 22:44:24 +0800
From: Yu Zhao <yu.zhao@uniscape.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Yu Zhao <yu.zhao@intel.com>,
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
Subject: Re: [PATCH 2/16 v6] PCI: define PCI resource names in an 'enum'
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <20081022084041.GB3773@yzhao12-linux.sh.intel.com> <200810220824.21356.bjorn.helgaas@hp.com>
In-Reply-To: <200810220824.21356.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {2990:host272.hostmonster.com:uniscape:uniscape.net} {sentby:smtp auth 58.38.26.55 authed with yu.zhao@uniscape.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Wednesday 22 October 2008 02:40:41 am Yu Zhao wrote:
>> This patch moves all definitions of the PCI resource names to an 'enum',
>> and also replaces some hard-coded resource variables with symbol
>> names. This change eases introduction of device specific resources.
> 
> Thanks for removing a bunch of magic numbers from the code.
> 
>>  static void
>>  pci_restore_bars(struct pci_dev *dev)
>>  {
>> -	int i, numres;
>> -
>> -	switch (dev->hdr_type) {
>> -	case PCI_HEADER_TYPE_NORMAL:
>> -		numres = 6;
>> -		break;
>> -	case PCI_HEADER_TYPE_BRIDGE:
>> -		numres = 2;
>> -		break;
>> -	case PCI_HEADER_TYPE_CARDBUS:
>> -		numres = 1;
>> -		break;
>> -	default:
>> -		/* Should never get here, but just in case... */
>> -		return;
>> -	}
>> +	int i;
>>  
>> -	for (i = 0; i < numres; i++)
>> +	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++)
>>  		pci_update_resource(dev, i);
>>  }
> 
> The behavior of this function used to depend on dev->hdr_type.  Now
> we don't look at hdr_type at all, so we do the same thing for all
> devices.
> 
> For example, for a CardBus device, we used to call pci_update_resource()
> only for BAR 0; now we call it for BARs 0-6.
> 
> Maybe this is safe, but I can't tell from the patch, so I think you
> should explain *why* it's safe in the changelog.

It's safe because pci_update_resource() will ignore unused resources. 
E.g., for a Cardbus, only BAR 0 is used and its 'flags' is set, then 
pci_update_resource() only updates it. BAR 1-6 are ignored since their 
'flags' are 0.

I'll put more explanation in the changelog.

Thanks,
Yu
