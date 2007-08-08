Return-Path: <linux-kernel-owner+w=401wt.eu-S936544AbXHHBJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936544AbXHHBJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 21:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933776AbXHHBJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 21:09:49 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:43073 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933113AbXHHBJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 21:09:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bnnStXlClVZqs+dhy8PMPqRND7mdxIegPiiQVgRxR6zqhazMARPsrGlag4ygWsUZoL5Jkn3vowg/4gCSbSum7Kvq4bNGee/CQwJKu9saCaiH/FdNNLkMVq0xCxk+A5nJGdqYl1kIpbRaj1Ojje4Dt/dGy+jzqvd0t1lFDJvRRKk=
Message-ID: <86802c440708071809g7a204200lde6f027a1bf496e9@mail.gmail.com>
Date: Tue, 7 Aug 2007 18:09:47 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH/RFT] finish i386 and x86-64 sysdata conversion
Cc: "Muli Ben-Yehuda" <muli@il.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       riku.seppala@kymp.net, "Andy Whitcroft" <apw@shadowen.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46B911C4.8010909@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B3A7BB.9000102@redhat.com> <200708041130.42038.ak@suse.de>
	 <20070804093222.f0d7f3c7.akpm@linux-foundation.org>
	 <200708050140.49590.ak@suse.de>
	 <20070805050410.GB4960@rhun.haifa.ibm.com>
	 <86802c440708042238h39fa1b4ude2836fd9732213b@mail.gmail.com>
	 <20070805075307.GA25890@rhun.haifa.ibm.com>
	 <20070807154911.5fe93b40.akpm@linux-foundation.org>
	 <20070807225635.GJ4278@rhun.haifa.ibm.com>
	 <46B911C4.8010909@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/07, Jeff Garzik <jeff@garzik.org> wrote:
> Muli Ben-Yehuda wrote:
>
> Strongly agreed.  It overall fixes bugs that existing _before_ the
> sysdata stuff went in.

what are those bugs?

the sysdata stuff try to fix:
when calgary iommu code was introduced, it is trying to share sysdata
that orginally is initialized k8_bus.c and used by pcibus_to_node. but
that only happen with AMD K8 platform. and have nothing to do with
calgary.
Then my patch get_mp_bus_to_node_as_early will use that sysdata as
node as early as possible before the pci_scan bus is called.

then Mul came out his patch ...to split the sharing that will never happen.

But andi picked muli patch even my patch stay a while in -mm.

Also i don't think anyone test muli sysdata patch with amd64 platform
with acpi=off. even muli himself.

calgary support bus numa at this time? i mean mult peer root bus on
different node..

anyway I will produce my patch in v3...

YH
