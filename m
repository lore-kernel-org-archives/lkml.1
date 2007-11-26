Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbXKZEHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbXKZEHY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 23:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbXKZEHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 23:07:10 -0500
Received: from hqemgate03.nvidia.com ([216.228.112.145]:17725 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466AbXKZEHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 23:07:08 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Nov 2007 23:07:08 EST
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Sun, 25 Nov 2007 20:02:02 -0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: [PATCH 1/2] msi: set 'En' bit of MSI Mapping Capability on HT platform
Date: Mon, 26 Nov 2007 12:01:58 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B1D8A3CF3@hkemmail01.nvidia.com>
In-Reply-To: <4749C00A.8050802@shaw.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] msi: set 'En' bit of MSI Mapping Capability on HT platform
Thread-Index: AcgvkcPzv3Vf+a/8QYiO+EEYbIIPGwATm+IA
References: <fa.o8FrHkCTygSL3HgQ8yHeTr2D3tI@ifi.uio.no> <4749C00A.8050802@shaw.ca>
From: "Peer Chen" <pchen@nvidia.com>
To: "Robert Hancock" <hancockr@shaw.ca>, "peerchen" <peerchen@gmail.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>, "Andy Currid" <ACurrid@nvidia.com>
X-OriginalArrivalTime: 26 Nov 2007 04:01:59.0081 (UTC) FILETIME=[17A3B190:01C82FE1]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
