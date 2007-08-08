Return-Path: <linux-kernel-owner+w=401wt.eu-S936782AbXHHB3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936782AbXHHB3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 21:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934562AbXHHB2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 21:28:52 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:39410 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449AbXHHB2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 21:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d7xli+U63zAHRAcRxl7ERbaLGkehRiJfesbl/L1/2f3SFiCWKs+RVtsAxEv7E6S2OV/yFXyztdDGVS3zNZFgx6fmqaelwd9i7nm09X7uuFo7eus5T+Gn8ZoCfBSO6zi1gII61zsdg50s4A6OgOmiQx1aEQIkv4Wle5JxPnkF6Mk=
Message-ID: <86802c440708071828n40b6faedlb950cdc987cdff0e@mail.gmail.com>
Date: Tue, 7 Aug 2007 18:28:50 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH/RFT] finish i386 and x86-64 sysdata conversion
Cc: "Muli Ben-Yehuda" <muli@il.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       riku.seppala@kymp.net, "Andy Whitcroft" <apw@shadowen.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46B91A94.7000509@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B3A7BB.9000102@redhat.com> <200708050140.49590.ak@suse.de>
	 <20070805050410.GB4960@rhun.haifa.ibm.com>
	 <86802c440708042238h39fa1b4ude2836fd9732213b@mail.gmail.com>
	 <20070805075307.GA25890@rhun.haifa.ibm.com>
	 <20070807154911.5fe93b40.akpm@linux-foundation.org>
	 <20070807225635.GJ4278@rhun.haifa.ibm.com>
	 <46B911C4.8010909@garzik.org>
	 <86802c440708071809g7a204200lde6f027a1bf496e9@mail.gmail.com>
	 <46B91A94.7000509@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/07, Jeff Garzik <jeff@garzik.org> wrote:
> Yinghai Lu wrote:
> > the sysdata stuff try to fix:
> > when calgary iommu code was introduced, it is trying to share sysdata
> > that orginally is initialized k8_bus.c and used by pcibus_to_node. but
> > that only happen with AMD K8 platform. and have nothing to do with
> > calgary.
>
> incorrect:  sysdata is initialized when the structure is created, which
> clearly not only in k8_bus.c

before his first patch, numa juse use sysdata pointer for node.

>
>
> > Then my patch get_mp_bus_to_node_as_early will use that sysdata as
> > node as early as possible before the pci_scan bus is called.
>
> that's incorrect, since it assumes NUMA owns ->sysdata

At that time, only it use that.

>
>
> > then Mul came out his patch ...to split the sharing that will never happen.
>
> that's incorrect, ->sysdata will be shared among Calgary, NUMA, and
> PCI-domain support.

but not the same time on run time system with Calgary, NUMA.

>
>
> > Also i don't think anyone test muli sysdata patch with amd64 platform
> > with acpi=off. even muli himself.
>
> I did.  I did all PCI domain support development on AMD64 platform.

really, but his first patch is broken with acpi=off.
I guess you tested his patch plus your patch. instead of test his
patch barely.  I tested his patch + my patch, and it works well, and
even test his patch only.

>
>
> > calgary support bus numa at this time? i mean mult peer root bus on
> > different node..
>
> My PCI domains patch add support for multiple peer root buses.  That's
> the definition of PCI domain support.
>
> Branch 'pciseg' of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

good, i will look at it.

YH
