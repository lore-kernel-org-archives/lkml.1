Return-Path: <linux-kernel-owner+w=401wt.eu-S1762271AbXHEUl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762271AbXHEUl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 16:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762010AbXHEUl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 16:41:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:47092 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761548AbXHEUlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 16:41:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g+9Ex9T1hVPNS3vLHhNyvJ52BWBM2lS7XFpFjwE+M27lkHKgvDUJTEBA5yp5r0l8ChgCQizQntmpOic8N2x9ZjCrWtKEJZ9oi4MXs/drOYNEWDooYXeWUvCDmhSfl1lZNspWrxS8hOarqRYB0TboE6qdfbcXePOqieoMQy+gd04=
Message-ID: <86802c440708051341q66aa1et3ea612beeab0f299@mail.gmail.com>
Date: Sun, 5 Aug 2007 13:41:24 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH/RFT] finish i386 and x86-64 sysdata conversion
Cc: "Muli Ben-Yehuda" <muli@il.ibm.com>, "Andi Kleen" <ak@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, riku.seppala@kymp.net,
       "Andy Whitcroft" <apw@shadowen.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46B60A93.80107@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B3A7BB.9000102@redhat.com>
	 <20070804093222.f0d7f3c7.akpm@linux-foundation.org>
	 <200708050140.49590.ak@suse.de>
	 <20070805050410.GB4960@rhun.haifa.ibm.com>
	 <86802c440708042238h39fa1b4ude2836fd9732213b@mail.gmail.com>
	 <20070805075307.GA25890@rhun.haifa.ibm.com>
	 <86802c440708050149u4c0ef4d8j7ea3478b07312525@mail.gmail.com>
	 <20070805115457.GD19963@rhun.haifa.ibm.com>
	 <86802c440708050939t7853ad74w5f039d1478964857@mail.gmail.com>
	 <46B60A93.80107@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/07, Jeff Garzik <jeff@garzik.org> wrote:
> Yinghai Lu wrote:
> > pci_scan_bus_on_node(int bus, struct pci_ops *ops, int node)
> > x86_pci_scan_root_bus(int bus)
> > {
> >   pci_scan_bus_on_node(bus, &pci_root_ops, -1);
> > }
> >
> > i need node as one param for my patch later in irq.c and legacy.c
>
>
> It is a mistake to start coding NUMA details into pci scan functions.
>
> Anywhere the current code does not set the NUMA node, set it to -1 or
> some other default value.

Can you check
http://lkml.org/lkml/2007/7/26/377
http://lkml.org/lkml/2007/7/26/378
http://lkml.org/lkml/2007/7/26/379

it will make sure numa_node on device get correct value after pci scan.
esp for k8 system with second peer root bus on second node.

Thanks

Yinghai Lu
