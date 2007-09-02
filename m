Return-Path: <linux-kernel-owner+w=401wt.eu-S934177AbXIBRPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934177AbXIBRPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 13:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbXIBRPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 13:15:44 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:15433 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085AbXIBRPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 13:15:43 -0400
Message-ID: <46DAEFA5.70800@oracle.com>
Date: Sun, 02 Sep 2007 10:15:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86/x86-64 PCI domain support
References: <20070901143223.GA32216@havoc.gtf.org>	<200709020000.03375.ak@suse.de>	<46D9E254.6010702@garzik.org>	<200709020026.52725.ak@suse.de>	<46D9EA5B.9010101@garzik.org> <20070902094637.6750f068.randy.dunlap@oracle.com> <46DAEB58.3070109@garzik.org>
In-Reply-To: <46DAEB58.3070109@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Randy Dunlap wrote:
>> On Sat, 01 Sep 2007 18:40:27 -0400 Jeff Garzik wrote:
>>
>>> Andi Kleen wrote:
>>>>>> The second function is redundant? 
>>>>> No, it's a hook we must implement, when CONFIG_PCI_DOMAINS is enabled.
>>>> Then the other function is redundant.
>>> No, both functions are required by the interface.
>>
>> by what interface?  and why, please?  (instead of just stating 
>> "required")
> 
> grep for CONFIG_PCI_DOMAINS in arch code and include/linux/pci.h.

Thanks, I get it.

> This is normal "arch" interface:  you enable a define, and a group of 
> functions is assumed to be present.  Otherwise (!defined), a set of stub 
> no-ops is activated for your arch.
> 
> I have implemented the [small] group of functions the code assumes to be 
> present, when CONFIG_PCI_DOMAINS is enabled, like all the other arches 
> that implement PCI domain support.


+#ifdef CONFIG_PCI_DOMAINS
+static inline int pci_domain_nr(struct pci_bus *bus)
+{
+	struct pci_sysdata *sd = bus->sysdata;
+	return sd->domain;
+}
+
+static inline int pci_proc_domain(struct pci_bus *bus)
+{
+	return pci_domain_nr(bus);
+}
+#endif /* CONFIG_PCI_DOMAINS */

So if CONFIG_PCI_DOMAINS=y, proc_proc_domain() decides to print the domain nr
in /proc iff the domain nr != 0 ?  so that the /proc file format is
different depending on the domain nr (0 vs. !0) ?

I suppose that is similar to what arch/powerpc/kernel/pci_64.c does
with hose->buid.  I think that I had rather see the domain nr printed
whenever CONFIG_PCI_DOMAINS=y... oh well.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
