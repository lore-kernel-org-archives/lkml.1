Return-Path: <linux-kernel-owner+w=401wt.eu-S937045AbXHHBXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937045AbXHHBXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 21:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936061AbXHHBVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 21:21:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33506 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935992AbXHHBVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 21:21:32 -0400
Message-ID: <46B91A94.7000509@garzik.org>
Date: Tue, 07 Aug 2007 21:21:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Muli Ben-Yehuda <muli@il.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       riku.seppala@kymp.net, Andy Whitcroft <apw@shadowen.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFT] finish i386 and x86-64 sysdata conversion
References: <46B3A7BB.9000102@redhat.com> <200708041130.42038.ak@suse.de>	 <20070804093222.f0d7f3c7.akpm@linux-foundation.org>	 <200708050140.49590.ak@suse.de>	 <20070805050410.GB4960@rhun.haifa.ibm.com>	 <86802c440708042238h39fa1b4ude2836fd9732213b@mail.gmail.com>	 <20070805075307.GA25890@rhun.haifa.ibm.com>	 <20070807154911.5fe93b40.akpm@linux-foundation.org>	 <20070807225635.GJ4278@rhun.haifa.ibm.com>	 <46B911C4.8010909@garzik.org> <86802c440708071809g7a204200lde6f027a1bf496e9@mail.gmail.com>
In-Reply-To: <86802c440708071809g7a204200lde6f027a1bf496e9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> the sysdata stuff try to fix:
> when calgary iommu code was introduced, it is trying to share sysdata
> that orginally is initialized k8_bus.c and used by pcibus_to_node. but
> that only happen with AMD K8 platform. and have nothing to do with
> calgary.

incorrect:  sysdata is initialized when the structure is created, which 
clearly not only in k8_bus.c


> Then my patch get_mp_bus_to_node_as_early will use that sysdata as
> node as early as possible before the pci_scan bus is called.

that's incorrect, since it assumes NUMA owns ->sysdata


> then Mul came out his patch ...to split the sharing that will never happen.

that's incorrect, ->sysdata will be shared among Calgary, NUMA, and 
PCI-domain support.


> Also i don't think anyone test muli sysdata patch with amd64 platform
> with acpi=off. even muli himself.

I did.  I did all PCI domain support development on AMD64 platform.


> calgary support bus numa at this time? i mean mult peer root bus on
> different node..

My PCI domains patch add support for multiple peer root buses.  That's 
the definition of PCI domain support.

Branch 'pciseg' of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

	Jeff


