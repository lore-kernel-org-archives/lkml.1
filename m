Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbZGGPX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbZGGPX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbZGGPXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:23:49 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:52972 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbZGGPXs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:23:48 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz14c3M98dN936eMzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KMF434-02-7YX-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: IOMMU and graphics cards
Date: Tue, 7 Jul 2009 10:24:46 -0500
Message-ID: <6453C3CB8E2B3646B0D020C11261327303FA5888@sausexmb4.amd.com>
In-Reply-To: <0DDD3FAD-969A-421B-A36A-77AB645E8BCA@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: IOMMU and graphics cards
Thread-Index: Acn/FLG/PAUo6NcDSbK16YE1twsX2QAAIofQ
References: <20090507164742V.fujita.tomonori@lab.ntt.co.jp><20090507100114.GF4059@amd.com><1241691721.3531.73.camel@macbook.infradead.org><20090507.113632.210373283.davem@davemloft.net><20090508093526.GB13708@8bytes.org><1246883177.2615.33.camel@macbook.infradead.org><20090706131156.GL5380@amd.com><1246889932.2615.81.camel@macbook.infradead.org><alpine.DEB.2.00.0907062232350.5769@skynet.skynet.ie> <0DDD3FAD-969A-421B-A36A-77AB645E8BCA@gmail.com>
From: "Duran, Leo" <leo.duran@amd.com>
To: "Dave Airlie" <airlied@gmail.com>, "Dave Airlie" <airlied@linux.ie>
CC: "Zhenyu Wang" <zhenyu.z.wang@intel.com>, <linux-kernel@vger.kernel.org>,
       <fujita.tomonori@lab.ntt.co.jp>, <eric@anholt.net>,
       <iommu@lists.linux-foundation.org>, <mingo@redhat.com>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 07 Jul 2009 15:23:34.0923 (UTC) FILETIME=[E4C4B5B0:01C9FF16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07/07/2009, at 10:08 CST, Dave Airlie <airlied@linux.ie> wrote:
> Could you also enumerate any limitations of the IOMMUs
> on the amount of memory they can remap per device if any.

Here's the spec for the AND IOMMU:
http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/
34434.pdf

Below is a cut-paste of "Table 3: Device Table Entry Field Definitions".
As an example, paging mode 4 supports a 48-bit virtual address space
(well beyond 4GB's). In terms of physical address space, "Figure 7: I/O
Page Translation Entry (PTE)" shows supports for up-to a 52-bit page
address.

Leo.


11:9 Mode: paging mode. Specify how the IOMMU performs page translation
on behalf of the device. If
page translation is enabled, the mode specifies the depth of the
device's I/O page tables (1 to 6
levels).

000b Translation disabled (Access controlled by IR and IW bits)
001b 1 Level Page Table (provides a 21-bit device virtual address space)
010b 2 Level Page Table (provides a 30-bit device virtual address space)
011b 3 Level Page Table (provides a 39-bit device virtual address space)
100b 4 Level Page Table (provides a 48-bit device virtual address space)
101b 5 Level Page Table (provides a 57-bit device virtual address space)
110b 6 Level Page Table (provides a 64-bit device virtual address space)
111b Reserved
Note: the page table root pointer is ignored when Mode=000b and when
Mode=111b.
Note: Mode=111b is reported as an error when V=1 and TV=1.

