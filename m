Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbYJVPB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbYJVPB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbYJVPBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:01:39 -0400
Received: from outbound-mail-26.bluehost.com ([69.89.17.191]:54679 "HELO
	outbound-mail-26.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754587AbYJVPBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:01:38 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 11:01:37 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=uniscape.net;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BuosOKGPtnwRnwkUJlDkC8B+uEL+mXtqfAWzXQJXokHwDOTFaBCUOIJdsF0nyZHojwRMzlKLzXiamibtNi8IqSX1nYleWTAdEhYNvmbF6FyS/wDxm6I1JueaWFxGgJq6;
Message-ID: <48FF3E87.4090407@uniscape.net>
Date: Wed, 22 Oct 2008 22:53:59 +0800
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
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <200810220824.21356.bjorn.helgaas@hp.com> <48FF3C48.9060809@uniscape.net> <200810220851.13413.bjorn.helgaas@hp.com>
In-Reply-To: <200810220851.13413.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {2990:host272.hostmonster.com:uniscape:uniscape.net} {sentby:smtp auth 58.38.26.55 authed with yu.zhao@uniscape.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Wednesday 22 October 2008 08:44:24 am Yu Zhao wrote:
>> Bjorn Helgaas wrote:
>>> On Wednesday 22 October 2008 02:40:41 am Yu Zhao wrote:
>>>> This patch moves all definitions of the PCI resource names to an 'enum',
>>>> and also replaces some hard-coded resource variables with symbol
>>>> names. This change eases introduction of device specific resources.
>>> Thanks for removing a bunch of magic numbers from the code.
>>>
>>>>  static void
>>>>  pci_restore_bars(struct pci_dev *dev)
>>>>  {
>>>> -	int i, numres;
>>>> -
>>>> -	switch (dev->hdr_type) {
>>>> -	case PCI_HEADER_TYPE_NORMAL:
>>>> -		numres = 6;
>>>> -		break;
>>>> -	case PCI_HEADER_TYPE_BRIDGE:
>>>> -		numres = 2;
>>>> -		break;
>>>> -	case PCI_HEADER_TYPE_CARDBUS:
>>>> -		numres = 1;
>>>> -		break;
>>>> -	default:
>>>> -		/* Should never get here, but just in case... */
>>>> -		return;
>>>> -	}
>>>> +	int i;
>>>>  
>>>> -	for (i = 0; i < numres; i++)
>>>> +	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++)
>>>>  		pci_update_resource(dev, i);
>>>>  }
>>> The behavior of this function used to depend on dev->hdr_type.  Now
>>> we don't look at hdr_type at all, so we do the same thing for all
>>> devices.
>>>
>>> For example, for a CardBus device, we used to call pci_update_resource()
>>> only for BAR 0; now we call it for BARs 0-6.
>>>
>>> Maybe this is safe, but I can't tell from the patch, so I think you
>>> should explain *why* it's safe in the changelog.
>> It's safe because pci_update_resource() will ignore unused resources. 
>> E.g., for a Cardbus, only BAR 0 is used and its 'flags' is set, then 
>> pci_update_resource() only updates it. BAR 1-6 are ignored since their 
>> 'flags' are 0.
>>
>> I'll put more explanation in the changelog.
> 
> This is a logically separate change from merely substituting enum
> names for magic numbers, so you might even consider splitting it
> into a separate patch.  Better bisection and all that, you know :-)

Will do.

Thanks,
Yu
