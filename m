Return-Path: <linux-kernel-owner+w=401wt.eu-S1757675AbXKZFTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbXKZFTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 00:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbXKZFTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 00:19:08 -0500
Received: from hqemgate04.nvidia.com ([216.228.112.152]:7782 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbXKZFTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 00:19:06 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Nov 2007 00:19:06 EST
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Sun, 25 Nov 2007 21:14:02 -0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: [PATCH 1/2] msi: set 'En' bit of MSI Mapping Capability on HT platform
Date: Sun, 25 Nov 2007 21:14:02 -0800
Message-ID: <8E5ACAE05E6B9E44A2903C693A5D4E8A2C434356@hqemmail02.nvidia.com>
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B1D8A3CF3@hkemmail01.nvidia.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] msi: set 'En' bit of MSI Mapping Capability on HT platform
thread-index: AcgvkcPzv3Vf+a/8QYiO+EEYbIIPGwATm+IAAAIXRmA=
References: <fa.o8FrHkCTygSL3HgQ8yHeTr2D3tI@ifi.uio.no> <4749C00A.8050802@shaw.ca> <15F501D1A78BD343BE8F4D8DB854566B1D8A3CF3@hkemmail01.nvidia.com>
From: "Andy Currid" <ACurrid@nvidia.com>
To: "Peer Chen" <pchen@nvidia.com>, "Robert Hancock" <hancockr@shaw.ca>,
       "peerchen" <peerchen@gmail.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 26 Nov 2007 05:14:02.0366 (UTC) FILETIME=[2884A1E0:01C82FEB]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Isn't there a way we can make this work for any upstream HT
> bridge, rather than only for specific NVIDIA chipsets?


The lines Peer indicates below will work for any vendor's bridge device
that implements an HT MSI mapping and is an upstream bridge of the
endpoint requesting MSI.

On some NVIDIA chipsets, the host bridge that implements HT MSI mapping
is not hierarchically upstream from the MSI endpoint; it may be a peer
on the same bus as the endpoint or the PCIe root complex that's above
the endpoint. The NVIDIA-specific code in the patch is to detect those
specific chipsets where this can occur. We have tested the patch with
both internal and PCI Express MSI endpoints on each of these NVIDIA
chipsets.

It may be that other vendors have Hypertransport chipsets with similar
requirements for HT MSI mapping, but we don't have that information or
the ability to test code on those vendors' chipsets.

Regards,

Andy
--
Andy Currid, NVIDIA Corporation
acurrid@nvidia.com  408 566 6743


-----Original Message-----
From: Peer Chen 
Sent: Sunday, November 25, 2007 20:02
To: Robert Hancock; peerchen
Cc: linux-kernel; akpm; Andy Currid
Subject: RE: [PATCH 1/2] msi: set 'En' bit of MSI Mapping Capability on
HT platform

I think the following lines are suitable for other bridges besides
nvidia's, :) :
===================
+		if (pci_enable_msi_ht_cap(dev) != 0) {
+			return 0;
+		} else {
+			/* Get upstream bridge device handle */
+
+			bridge_dev = dev->bus->self;
+			while(bridge_dev != 0) {
+				if (pci_enable_msi_ht_cap(bridge_dev) !=
0) {
+					return 0;
+				} else
+					bridge_dev =
bridge_dev->bus->self;
+			}
+
+			return 1;
+		} 


BRs
Peer Chen

-----Original Message-----
From: Robert Hancock [mailto:hancockr@shaw.ca] 
Sent: Monday, November 26, 2007 2:34 AM
To: peerchen
Cc: linux-kernel; akpm; Peer Chen; Andy Currid
Subject: Re: [PATCH 1/2] msi: set 'En' bit of MSI Mapping Capability on
HT platform

peerchen wrote:
> According to the HyperTransport spec, 'En' indicate if the MSI Mapping
is active. So it should be set when enable the MSI.
> 
> The patch base on kernel 2.6.24-rc3
> 
> Signed-off-by: Andy Currid <acurrid@nvidia.com>
> Signed-off-by: Peer Chen <pchen@nvidia.com>

Isn't there a way we can make this work for any upstream HT bridge,
rather than only for specific NVIDIA chipsets?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca Home Page:
http://www.roberthancock.com/

-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
