Return-Path: <linux-kernel-owner+w=401wt.eu-S932665AbYF0XR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665AbYF0XR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764734AbYF0XLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 19:11:16 -0400
Received: from mail-wa4.bigfish.com ([216.32.181.111]:10202 "EHLO
	mail26-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932170AbYF0XLN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 19:11:13 -0400
X-Greylist: delayed 1419 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jun 2008 19:11:13 EDT
X-BigFish: VPS-41(zz1432R98dR7efV1805M3117Kzzzzz32i6bh)
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K358MN-01-32O-01
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Date: Fri, 27 Jun 2008 17:47:56 -0500
Message-ID: <6453C3CB8E2B3646B0D020C1126132730120C4EE@sausexmb4.amd.com>
In-Reply-To: <20080627222931.GB7201@il.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Thread-Index: AcjYppi7UCpSKDytRTWVq8Ng/SrZ2wAACW6Q
References: <20080627170546.GE10197@8bytes.org> <6453C3CB8E2B3646B0D020C1126132730120C444@sausexmb4.amd.com> <20080627222931.GB7201@il.ibm.com>
From: "Duran, Leo" <leo.duran@amd.com>
To: "Muli Ben-Yehuda" <muli@il.ibm.com>
Cc: "Joerg Roedel" <joro@8bytes.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Richter, Robert" <rrichter@elbe.amd.com>,
       <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Biemueller, Sebastian" <Sebastian.Biemueller@amd.com>,
       <tglx@linutronix.de>, <mingo@redhat.com>,
       "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>
X-OriginalArrivalTime: 27 Jun 2008 22:47:23.0487 (UTC) FILETIME=[C3B8DEF0:01C8D8A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 27, 2008 5:30 PM, Muli Ben-Yehuda wrote:

> > 2) IOMMU will not translate if the exclusion range has been enabled,
> and
> > the DMA address falls inside that range.
> > The exclusion range can be enabled for specific devices, or for all
> > devices... Enabling the exclusion range can be considered a
> 'performance
> > optimization' (no table-walks), with the caveat of not being able to
> > provide protection for devices sharing the exclusion range (BTW,
> there's
> > a single exclusion address range per IOMMU).
> 
> So, if I understand this correctly, could we implement Joerg's
> "almost-direct-map" by having 0-64MB translated for host-owned
> devices, and then 64MB-end excluded (again, for host-owned devices
> only)? If yes, it should provide a small boost in performance (may or
> may not be measurable) over having 64MB-end be an identity
> translation.
> 
> Cheers,
> Muli

Hi Muli,

Yes, you could set an exclusion range for addresses about the virtual
address space (or 'translation aperture').
I played with that in the context of "dma.ops" (not surprisingly, the
exclusion range was pretty busy!).

Again, keep in mind: no protection in the exclusion range (sort of
defeating the purpose of having an IOMMU in the first place), and only
ONE exclusion range per IOMMU.

Leo.



