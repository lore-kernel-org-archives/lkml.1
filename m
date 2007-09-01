Return-Path: <linux-kernel-owner+w=401wt.eu-S932875AbXIAWGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875AbXIAWGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 18:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbXIAWGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 18:06:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48113 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105AbXIAWGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 18:06:14 -0400
Message-ID: <46D9E254.6010702@garzik.org>
Date: Sat, 01 Sep 2007 18:06:12 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86/x86-64 PCI domain support
References: <20070901143223.GA32216@havoc.gtf.org> <200709020000.03375.ak@suse.de>
In-Reply-To: <200709020000.03375.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>  
>> +config PCI_DOMAINS
>> +	bool "PCI domain support"
>> +	depends on PCI
> 
> I don't think this should be a config option.

CONFIG_PCI_DOMAINS is referenced in arch-neutral code, so the symbol 
_must_ be defined.

It can be hidden, perhaps, if that makes our x86 maintainer happy :)


> But there should be a pci=... option with Documentation to turn it off at runtime

OK


>> +static inline int pci_proc_domain(struct pci_bus *bus)
>> +{
>> +	return pci_domain_nr(bus);
>> +}
> 
> The second function is redundant? 

No, it's a hook we must implement, when CONFIG_PCI_DOMAINS is enabled.

	Jeff



