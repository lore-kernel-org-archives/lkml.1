Return-Path: <linux-kernel-owner+w=401wt.eu-S932305AbXIOALA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbXIOALA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 20:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbXIOAKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 20:10:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:40569 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189AbXIOAKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 20:10:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,257,1186383600"; 
   d="scan'208";a="307350400"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [PATCH] Refactor hypercall infrastructure
Date: Fri, 14 Sep 2007 17:10:03 -0700
Message-ID: <97D612E30E1F88419025B06CB4CF1BE10379ED0A@scsmsx412.amr.corp.intel.com>
In-Reply-To: <46EB1285.5050807@goop.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [PATCH] Refactor hypercall infrastructure
Thread-Index: Acf3IzNJy7q+iSl0RpK8hIB4pPaWSQABkxtQ
References: <11897991353793-git-send-email-aliguori@us.ibm.com><46EAF4C6.8090903@goop.org> <46EAF6FC.80207@codemonkey.ws><46EAFBA0.4020503@goop.org> <46EB0136.6080105@codemonkey.ws><46EB02BA.6030909@goop.org> <46EB0657.40603@codemonkey.ws> <97D612E30E1F88419025B06CB4CF1BE10379EBF9@scsmsx412.amr.corp.intel.com> <46EB1285.5050807@goop.org>
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Anthony Liguori" <anthony@codemonkey.ws>,
       <kvm-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       "Avi Kivity" <avi@qumranet.com>
X-OriginalArrivalTime: 15 Sep 2007 00:10:04.0408 (UTC) FILETIME=[C41B1780:01C7F72C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Nakajima, Jun wrote:
> > > > one.  Start the kvm leaves at 0x40001000 or something?
> > > > 
> > > > 
> > > Yeah, that works with me.
> > > 
> > 
> > To me this is the beginning of fragmentation. Why do we need
different
> > and VMM-specific Linux paravirtualization for hardware-assisted
> > virtualization? That would not be good for Linux.
> > 
> 
> On the contrary.  Xen already has a hypercall interface, and we need
to
> keep supporting it.  If we were to also support a vmm-independent
> interface (aka "kvm interface"), then we need to be able to do that in
> parallel.  If we have a cpuid leaf clash, then its impossible to do
so;
> if we define the new interface to be disjoint from other current users
> of cpuid, then we can support them concurrently.
> 
>     J

Today, 3 CPUID leaves starting from 0x4000_0000 are defined in a generic
fashion (hypervisor detection, version, and hypercall page), and those
are the ones used by Xen today. We should extend those leaves (e.g.
starting from 0x4000_0003) for the vmm-independent features as well.

If Xen needs additional Xen-specific features, we need to allocate some
leaves for those (e.g. 0x4000_1000)

Jun
---
Intel Open Source Technology Center
