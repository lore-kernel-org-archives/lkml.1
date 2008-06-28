Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbYF1O6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbYF1O6A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 10:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbYF1O5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 10:57:51 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:48280 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbYF1O5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 10:57:50 -0400
X-BigFish: VPS-40(zz1432R98dR7efV1805M1442Jzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K36HJX-02-HUZ-01
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Date: Sat, 28 Jun 2008 09:58:22 -0500
Message-ID: <6453C3CB8E2B3646B0D020C1126132730120C51A@sausexmb4.amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Thread-Index: AcjZDsZMy19Ey33QRYKOW7BROMrBfgAHYGIwAACJXIA=
References: <20080627170546.GE10197@8bytes.org> <6453C3CB8E2B3646B0D020C1126132730120C444@sausexmb4.amd.com> <20080627222931.GB7201@il.ibm.com> <6453C3CB8E2B3646B0D020C1126132730120C4EE@sausexmb4.amd.com> <20080628110426.GJ10197@8bytes.org> 
From: "Duran, Leo" <leo.duran@amd.com>
To: "Duran, Leo" <leo.duran@amd.com>, "Joerg Roedel" <joro@8bytes.org>
CC: "Muli Ben-Yehuda" <muli@il.ibm.com>, "Adrian Bunk" <bunk@kernel.org>,
       "Richter, Robert" <rrichter@elbe.amd.com>,
       <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Biemueller, Sebastian" <Sebastian.Biemueller@amd.com>,
       <tglx@linutronix.de>, <mingo@redhat.com>,
       "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>
X-OriginalArrivalTime: 28 Jun 2008 14:57:41.0114 (UTC) FILETIME=[5021C5A0:01C8D92F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 28, 2008 6:04 AM, Joerg Roedel wrote:

> Yes, there is only one exclusion range per IOMMU. The problem is that 
> an exclusion range from 64MB to the end may not be possible because 
> there is an exclusion range already configured in the ACPI table. On 
> my System for example the exclusion range is somewhere in the first 
> megabyte of RAM.
> In this case the direct mapping using page tables is needed. If there 
> is no exclusion range defined in ACPI this idea would work of course.
> 
> Joerg
> 

It would OK to have ONE all inclusive exclusion range (e.g., 64MB to
'end' if you want).
That is, any pre-defined areas would simply fall inside the larger
range.
And, if the ACPI table calls for exclusion of a range inside the
aperture (e.g., inside 64MB),
that range would have to be 'reserved', and set for 1:1 mapping.

Leo.

