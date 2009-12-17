Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbZLQF7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbZLQF7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 00:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZLQF7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 00:59:33 -0500
Received: from mga07.intel.com ([143.182.124.22]:40354 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752823AbZLQF7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 00:59:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="223881608"
Date: Thu, 17 Dec 2009 08:34:55 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: "Youquan,Song" <youquan.song@linux.intel.com>, jbarnes@virtuousgeek.org,
       andi@firstfloor.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH]PCIe AER: reject aer inject if hardware mask error reporting
Message-ID: <20091217133455.GD11466@youquan-linux.bj.intel.com>
References: <20091211234855.GB7196@youquan-linux.bj.intel.com> <1260836954.19155.84.camel@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260836954.19155.84.camel@bluto.andrew>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I have udpate and sent the patch according to your comments.
 
> >  	dev = pci_get_bus_and_slot(einj->bus, devfn);
> 
> This does not apply.  Please respin against latest linux-2.6 or pci-2.6.
Yes, it is true that it is udapted at 32 final. Thanks.

> >  
> > +	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_COR_MASK, &mask);
> > +	if (einj->cor_status && !(einj->cor_status & ~mask)) {
> > +		ret = -EINVAL;
> > +		printk(KERN_WARNING "The correctable error is masked by device\n");
> 
> You can inject multiple correctable errors with the aer-inject user-land
> tool, so perhaps this should be re-worded as:
> 
> "The correctable error(s) are masked by the device\n"
Yes. it is update.

> You can also simultaneously inject correctable and uncorrectable errors,
> so I don't particularly like returning errors here.  Perhaps you should
> just print the warning message out and just not inject the masked
> errors.
I do not agree with you at this point. If the hardware is not support
some error reporting, it need direct report this information to user
who use aer_inject userspace tool. He need change the his inject
configuration file, rather than kernel report him successful inject
AER but no any useful information at console or dmesg output. 

Anyway, In my mind, it should not be very important issue to stop this patch
 go to mainline. 

Thanks.

-Youquan

