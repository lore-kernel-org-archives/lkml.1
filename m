Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbYAYKkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbYAYKkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYAYKkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:40:23 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:18808 "EHLO
	outbound5-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606AbYAYKkV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:40:21 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch] PCI: disable the MSI of AMD RS690
Date: Fri, 25 Jan 2008 18:39:53 +0800
Message-ID: <B90463BC30D2E446BA423D888DC85E501BFB4C@sshaexmb1.amd.com>
In-Reply-To: <47987355.1020406@inria.fr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] PCI: disable the MSI of AMD RS690
Thread-Index: AcheeoIQ6o7l8RZMQ46HIPqIaEQjZgAtIfkA
References: <5CAB7B5D6F8AB84AA868A46B47A507055D8C1D@sshaexmb1.amd.com>
 <B90463BC30D2E446BA423D888DC85E501BF78E@sshaexmb1.amd.com>
 <47987355.1020406@inria.fr>
From: "Shane Huang" <Shane.Huang@amd.com>
To: "Brice Goglin" <Brice.Goglin@inria.fr>, gregkh@suse.de
cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       htejun@gmail.com, "Shane Huang" <Shane.Huang@amd.com>
X-OriginalArrivalTime: 25 Jan 2008 10:39:57.0585 (UTC)
 FILETIME=[A11F4010:01C85F3E]
X-WSS-ID: 6B87630C2IW8769298-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brice:


> > +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS690,
> > quirk_disable_all_msi);
> 
> This patch disable MSI for the _whole_ system, not only behind the
> RS690. Is this on purpose? Is MSI really going to be broken on any
> bus that's _not_ behind RS690. If not, you might want to use 
> quirk_disable_msi() instead (as we do for AMD8131).


quirk_disable_msi() can not fix the issue in my debug, 
quirk_msi_intx_disable_bug() which can fix SB700 SATA MSI bug does not
work either.
quirk_disable_all_msi is the only workaround I found.

If there is any other guy who also has one SB600+RS690 board, and can
help
to  verify this RS690 MSI disablement patch with a new kernel version
such as
2.6.24-rc7,  that's great.


BTW:
RS690 MSI disablement should NOT affect SB700 MSI, because as I know, 
there will not be the combination of RS690+SB700 on the market.


Thanks
Shane


