Return-Path: <linux-kernel-owner+w=401wt.eu-S1761683AbYF0Uia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761683AbYF0Uia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbYF0UiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:38:18 -0400
Received: from mail-sin.bigfish.com ([207.46.51.74]:16615 "EHLO
	mail182-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbYF0UiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:38:17 -0400
X-BigFish: VPS-39(zz1432R98dR7efV1805M10d1Izzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K352MY-02-066-01
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Date: Fri, 27 Jun 2008 15:39:31 -0500
Message-ID: <6453C3CB8E2B3646B0D020C1126132730120C444@sausexmb4.amd.com>
In-Reply-To: <20080627170546.GE10197@8bytes.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Thread-Index: AcjYeCH8zkUDhfHyRhulsKaa/78m5gAGogGg
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com><1214508490-29683-2-git-send-email-joerg.roedel@amd.com><20080627142558.GG18644@cs181140183.pp.htv.fi><878wwrq6im.fsf@basil.nowhere.org><20080627163945.GA26130@il.ibm.com><20080627165430.GD10197@8bytes.org><20080627165947.GB26130@il.ibm.com> <20080627170546.GE10197@8bytes.org>
From: "Duran, Leo" <leo.duran@amd.com>
To: "Joerg Roedel" <joro@8bytes.org>, "Muli Ben-Yehuda" <muli@il.ibm.com>
Cc: "Adrian Bunk" <bunk@kernel.org>, "Richter, Robert" <rrichter@elbe.amd.com>,
       <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Biemueller, Sebastian" <Sebastian.Biemueller@amd.com>,
       <tglx@linutronix.de>, <mingo@redhat.com>,
       "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>
X-OriginalArrivalTime: 27 Jun 2008 20:37:57.0452 (UTC) FILETIME=[AECDF8C0:01C8D895]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 12:06 PM, Joerg Roedel wrote

> On Fri, Jun 27, 2008 at 12:59:47PM -0400, Muli Ben-Yehuda wrote:
> > On Fri, Jun 27, 2008 at 06:54:30PM +0200, Joerg Roedel wrote:
> >
> > > True. At least for the case without device isolation I have some
> > > optimizations in mind which will minimize the performance
> > > tradeoff. I hope to have them ready for 2.6.28 :)
> >
> > Do you mean the case where you have a single I/O address space which
> > is shared by all devices?
> 
> Yes. I think this will be the case used most when IOMMU is used for
> virtualization and to handle devices with limited DMA address ranges.
> In
> this case there is a lot to optimize.
> 

With the AMD IOMMU there are basically two options with regards to
(untranslated) DMA handling:
1) IOMMU will translate using page tables, which can be set on per
device-table-entry basis; sharing page tables between devices could be
considered a 'resource usage optimization', with the caveat of not being
to provide protection for devices sharing the page tables.

2) IOMMU will not translate if the exclusion range has been enabled, and
the DMA address falls inside that range.
The exclusion range can be enabled for specific devices, or for all
devices... Enabling the exclusion range can be considered a 'performance
optimization' (no table-walks), with the caveat of not being able to
provide protection for devices sharing the exclusion range (BTW, there's
a single exclusion address range per IOMMU).

Leo.

