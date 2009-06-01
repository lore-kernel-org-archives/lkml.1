Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbZFABwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbZFABwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 21:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbZFABwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 21:52:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:14839 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbZFABwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 21:52:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,281,1241420400"; 
   d="scan'208";a="462106418"
Message-ID: <4A2333CF.2040601@intel.com>
Date: Mon, 01 Jun 2009 09:50:07 +0800
From: Yu Zhao <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
CC: Grant Grundler <grundler@parisc-linux.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "marc.c.dionne@gmail.com" <marc.c.dionne@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: use fixed-up device class when configuring device
References: <1243441505-5477-1-git-send-email-yu.zhao@intel.com> <20090529171956.GE28355@lackof.org>
In-Reply-To: <20090529171956.GE28355@lackof.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

Can you please take this fix for 2.6.30 RC if possible? It fixes a 
regression introduced by the SR-IOV patch series.

Thanks,
Yu

Grant Grundler wrote:
> On Thu, May 28, 2009 at 12:25:05AM +0800, Yu Zhao wrote:
>> The device class may be changed after the early fixup. Need to
>> re-read the class value from pci_dev when configuring the device.
>> Otherwise some devices such as JMicron SATA controller won't work.
> 
> I looked at pci_setup_device() and was thinking pci_fixup_device()
> should be called before pci_cfg_space_size() and thus avoid having
> to setup local "class" variable twice. pci_cfg_space_size() only
> seems to care if the device is a PCI_CLASS_BRIDGE_HOST (or not).
> 
> But dev->class has to be set up in any case and the current order
> makes more sense to me.
> 
> Reviewed-by: Grant Grundler <grundler@parisc-linux.org>
> 
> thanks,
> grant
> 
>> Tested-by: Marc Dionne <marc.c.dionne@gmail.com>
>> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
>> ---
>>  drivers/pci/probe.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index e3c3e08..f1ae247 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -745,6 +745,8 @@ int pci_setup_device(struct pci_dev *dev)
>>  
>>  	/* Early fixups, before probing the BARs */
>>  	pci_fixup_device(pci_fixup_early, dev);
>> +	/* device class may be changed after fixup */
>> +	class = dev->class >> 8;
>>  
>>  	switch (dev->hdr_type) {		    /* header type */
>>  	case PCI_HEADER_TYPE_NORMAL:		    /* standard header */
>> -- 
>> 1.6.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

