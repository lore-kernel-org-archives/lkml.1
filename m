Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbXF0Ies@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbXF0Ies (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 04:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbXF0Iem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 04:34:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38668 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbXF0Iel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 04:34:41 -0400
Message-ID: <4682211D.4040808@garzik.org>
Date: Wed, 27 Jun 2007 04:34:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Peer Chen <pchen@nvidia.com>
CC: Robert Hancock <hancockr@shaw.ca>, kuan luo <kuanluo@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Kuan Luo <kluo@nvidia.com>
Subject: Re: [PATCH] ata: Add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61
References: <fa.5TBvnXzjCgAIfcuKOLBWeXi+y5I@ifi.uio.no> <4681F06F.1050302@shaw.ca> <15F501D1A78BD343BE8F4D8DB854566B15830128@hkemmail01.nvidia.com>
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B15830128@hkemmail01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peer Chen wrote:
> We did the many test with the new version driver and didn't encounter
> that problem, but in certain cases, DMASETUP command packets from drive
> to the controller are corrupted, and the controller issues an R_ERR to
> the drive. Drives that comply with SATA spec will re-transmit the
> corrupted packet and normal operation continues. However, some Maxtor
> NCQ drives do not re-transmit the DMASETUP command packet, resulting in
> software timeout for this command. So if you are using the Maxtor HD and
> meet this problem,please don't enable the NCQ function.

Users should not be expected to know those details, nor be forced to 
suffer discovering this in the field (over and over again for each 
customer).

We have a list of problem devices ata_device_blacklist[] in 
drivers/ata/libata-core.c that should be modified to note each drive 
where NCQ should never be used.

	Jeff


