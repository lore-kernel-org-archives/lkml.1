Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbYF1Okj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbYF1Okj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 10:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYF1Oka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 10:40:30 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:58074 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbYF1Ok3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 10:40:29 -0400
X-BigFish: VPS-38(zz1432R98dR7efV1805M1442Jzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K36GQY-02-HOC-01
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Date: Sat, 28 Jun 2008 09:40:57 -0500
Message-ID: <6453C3CB8E2B3646B0D020C1126132730120C518@sausexmb4.amd.com>
In-Reply-To: <20080628110426.GJ10197@8bytes.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Thread-Index: AcjZDsZMy19Ey33QRYKOW7BROMrBfgAHYGIw
References: <20080627170546.GE10197@8bytes.org> <6453C3CB8E2B3646B0D020C1126132730120C444@sausexmb4.amd.com> <20080627222931.GB7201@il.ibm.com> <6453C3CB8E2B3646B0D020C1126132730120C4EE@sausexmb4.amd.com> <20080628110426.GJ10197@8bytes.org>
From: "Duran, Leo" <leo.duran@amd.com>
To: "Joerg Roedel" <joro@8bytes.org>
CC: "Muli Ben-Yehuda" <muli@il.ibm.com>, "Adrian Bunk" <bunk@kernel.org>,
       "Richter, Robert" <rrichter@elbe.amd.com>,
       <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Biemueller, Sebastian" <Sebastian.Biemueller@amd.com>,
       <tglx@linutronix.de>, <mingo@redhat.com>,
       "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>
X-OriginalArrivalTime: 28 Jun 2008 14:40:17.0568 (UTC) FILETIME=[E2214A00:01C8D92C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 28, 2008 6:04 AM, Joerg Roedel wrote:

> Yes, there is only one exclusion range per IOMMU. The problem is that
> an
> exclusion range from 64MB to the end may not be possible because there
> is
> an exclusion range already configured in the ACPI table. On my System
> for
> example the exclusion range is somewhere in the first megabyte of RAM.
> In this case the direct mapping using page tables is needed. If there
> is
> no exclusion range defined in ACPI this idea would work of course.
> 
> Joerg
> 

Direct 1:1 mappings have a couple of issues:
1) They don't provide a performance optimization (i.e., table-walk still
required)
2) Your aperture would have to be large enough so that virtual==physical
(i.e., lots of memory for page-tables)

Leo.


