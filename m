Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbZBRD0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbZBRD0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 22:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZBRD0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 22:26:39 -0500
Received: from mail.lang.hm ([64.81.33.126]:51573 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbZBRD0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 22:26:38 -0500
Date: Tue, 17 Feb 2009 19:26:29 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Yinghai Lu <yinghai@kernel.org>
cc: Matthew Wilcox <matthew@wil.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       DL-MPTFusionLinux@lsi.com
Subject: Re: mpt fusion broken sometime since 2.6.24
In-Reply-To: <499B774C.5010705@kernel.org>
Message-ID: <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>  <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>  <20090217230050.GG16841@parisc-linux.org>  <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm> <86802c440902171511s1abcc0eao560df4b8fcea0e7c@mail.gmail.com>
 <alpine.DEB.1.10.0902171514120.26625@asgard.lang.hm> <499B46B2.5040601@kernel.org> <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm> <499B6BF7.9090300@kernel.org> <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm> <499B724A.2040408@kernel.org>
 <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm> <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm> <499B774C.5010705@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009, Yinghai Lu wrote:

> david@lang.hm wrote:
>> On Tue, 17 Feb 2009, david@lang.hm wrote:
>>
>>>> do you have chance to try current tip/master
>>>> http://people.redhat.com/mingo/tip.git/readme.txt
>>>> or 2.6.29-rcX
>>>> plus following patch?
>>>
>>> I will see about trying this.
>>
>> does the fact that I am compiling a monolithic kernel (no modules) make
>> any difference related to the patch below?
>
> please try this patch too. wonder if your BIOS does enable the HT MSI ...

this does solve the problem.

David Lang

>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index baad093..7e97b90 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -1981,6 +1981,9 @@ static void __devinit quirk_msi_ht_cap(struct pci_dev *dev)
> DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE,
> 			quirk_msi_ht_cap);
>
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8132_BRIDGE,
> +			quirk_msi_ht_cap);
> +
>
> /* The nVidia CK804 chipset may have 2 HT MSI mappings.
>  * MSI are supported if the MSI capability set in any of these mappings.
>
