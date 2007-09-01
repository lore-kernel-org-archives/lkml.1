Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbXIAVbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbXIAVbR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 17:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbXIAVbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 17:31:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52744 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbXIAVbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 17:31:06 -0400
Message-ID: <46D9DA12.6050805@garzik.org>
Date: Sat, 01 Sep 2007 17:30:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>,
       Jason Gaston <jason.d.gaston@intel.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, khali@linux-fr.org,
       i2c@lm-sensors.nu
Subject: Re: [PATCH 2.6.23-rc4] irq: irq and pci_ids patch for Intel Tolapai
References: <200708301546.56998.jason.d.gaston@intel.com> <20070901211939.GA10442@colo.lackof.org>
In-Reply-To: <20070901211939.GA10442@colo.lackof.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Thu, Aug 30, 2007 at 03:46:56PM -0700, Jason Gaston wrote:
>> This updated patch adds the Intel Tolapai LPC and SMBus Controller DID's.
>>
>> Signed-off-by: ?Jason Gaston <jason.d.gaston@intel.com>
>>
>> --- linux-2.6.23-rc4/arch/i386/pci/irq.c.orig	2007-08-27 18:32:35.000000000 
>> -0700
>> +++ linux-2.6.23-rc4/arch/i386/pci/irq.c	2007-08-28 16:58:31.000000000 -0700
>> @@ -550,6 +550,7 @@
>>  		case PCI_DEVICE_ID_INTEL_ICH9_3:
>>  		case PCI_DEVICE_ID_INTEL_ICH9_4:
>>  		case PCI_DEVICE_ID_INTEL_ICH9_5:
>> +		case PCI_DEVICE_ID_INTEL_Tolapai_0:
> 
> If this is the only place it's used, the prefence is to define the
> constant locally (in the file) and not in pci_ids.h.

Kinda sorta:  if you must define a constant, it should go into 
linux/pci_ids.h.  Otherwise someone will come along later, do the same 
locally in another file, then you have two independent symbols with the 
same meaning.

Ideally, in pci_device_id tables and such, you can just use the hex 
number, since they are all arbitrary and lack meaning anyway.


> Please do submit new PCI device IDs to pciids.sf.net project.

Yep.


>>  #define PCI_DEVICE_ID_INTEL_MCH_PC	0x3599
>>  #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
>>  #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
>> +#define PCI_DEVICE_ID_INTEL_Tolapai_0	0x5031
>> +#define PCI_DEVICE_ID_INTEL_Tolapai_1	0x5032

And change the StudlyCaps to ALLCAPS.

	Jeff



