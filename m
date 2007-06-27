Return-Path: <linux-kernel-owner+w=401wt.eu-S1760194AbXF0IRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbXF0IRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 04:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbXF0IQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 04:16:48 -0400
Received: from hqemgate01.nvidia.com ([216.228.112.170]:14534 "EHLO
	HQEMGATE01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342AbXF0IQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 04:16:46 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] ata: Add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61
Date: Wed, 27 Jun 2007 16:15:41 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B15830128@hkemmail01.nvidia.com>
In-Reply-To: <4681F06F.1050302@shaw.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ata: Add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61
Thread-Index: Ace4eQX3Rrlr0TexSUWMwLeIZzkk9gAGLLQQ
References: <fa.5TBvnXzjCgAIfcuKOLBWeXi+y5I@ifi.uio.no> <4681F06F.1050302@shaw.ca>
From: "Peer Chen" <pchen@nvidia.com>
To: "Robert Hancock" <hancockr@shaw.ca>, "kuan luo" <kuanluo@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <jeff@garzik.org>,
       <akpm@linux-foundation.org>, "Kuan Luo" <kluo@nvidia.com>
X-OriginalArrivalTime: 27 Jun 2007 08:15:43.0200 (UTC) FILETIME=[5B21E600:01C7B893]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We did the many test with the new version driver and didn't encounter
that problem, but in certain cases, DMASETUP command packets from drive
to the controller are corrupted, and the controller issues an R_ERR to
the drive. Drives that comply with SATA spec will re-transmit the
corrupted packet and normal operation continues. However, some Maxtor
NCQ drives do not re-transmit the DMASETUP command packet, resulting in
software timeout for this command. So if you are using the Maxtor HD and
meet this problem,please don't enable the NCQ function.


BRs
Peer Chen

-----Original Message-----
From: Robert Hancock [mailto:hancockr@shaw.ca] 
Sent: Wednesday, June 27, 2007 1:07 PM
To: kuan luo
Cc: linux-kernel@vger.kernel.org; jeff@garzik.org;
akpm@linux-foundation.org; Peer Chen; Kuan Luo
Subject: Re: [PATCH] ata: Add the SW NCQ support to sata_nv for
MCP51/MCP55/MCP61

kuan luo wrote:
> Add the Software NCQ support to sata_nv.c for MCP51/MCP55/MCP61 SATA 
> controller.
> NCQ function is disable by default, you can enable it with 'swncq=1'
> 
> Signed-off-by: Kuan Luo <kluo@nvidia.com>
> Signed-off-by: Peer Chen <pchen@nvidia.com>
> 

Haven't reviewed in detail, but does look cleaner than the previous
version. Some people reported seeing some unrecognized FIS, etc. errors
with the previous version, have those been looked into/fixed?

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
