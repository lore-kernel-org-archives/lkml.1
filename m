Return-Path: <linux-kernel-owner+w=401wt.eu-S1764024AbXKJEEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764024AbXKJEEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 23:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbXKJEEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 23:04:45 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60052 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbXKJEEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 23:04:44 -0500
Message-ID: <47352DD8.6040607@garzik.org>
Date: Fri, 09 Nov 2007 23:04:40 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: peer chen <peerchen@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Kuan Luo <kluo@nvidia.com>
Subject: Re: [PATCH] sata_nv,ahci: add the ahci legacy mode support to sata_nv
References: <200709251323031982245@gmail.com> <470FE47B.5060505@garzik.org>	 <cfaab6210710160108x1328086cse991f668e23e569e@mail.gmail.com>	 <47181CE1.4000802@garzik.org>	 <cfaab6210710182358t4de355f9wd6d605a7b8076ace@mail.gmail.com>	 <47185BFD.2010909@garzik.org> <cfaab6210710211855q7a2de35co13d3017b2a07d4cc@mail.gmail.com>
In-Reply-To: <cfaab6210710211855q7a2de35co13d3017b2a07d4cc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

peer chen wrote:
> Yes, link - http://lkml.org/lkml/2007/10/8/93 add the AHCI legacy
> support to sata_nv when IDE/RAID mode been set in SBIOS and Device IDs
> are not in ahci.c at this moment. To do so, when a new chipset come
> out and DIDs haven't been submited to LKML,user still can use ahci
> driver to handle it when setting AHCI mode in BIOS, using sata_nv when
> setting RAID/IDE in BIOS.
> For example, ahci driver in Fedora 7 doesn't include the DIDs of
> MCP78, so if you set the IDE/RAID mode in BIOS, os installation onto
> SATA drive will fail. But if Fedora 7 include this patch, installation
> will be successful.

The problem with this change is that sata_nv picks it up through the 
default entry, and then later on, ahci picks it up as well.

Rather than the confusion of "which driver is the user running on this 
hardware?" it is easier to take steps to ensure the user is always 
running in AHCI mode.

Therefore, I think the best idea is to follow the same policy as 
drivers/net/forcedeth.c (Ayaz @ NVIDIA) and Intel AHCI, and simply 
provide the individual PCI IDs in advance of product release.

If you wish to avoid this, then take steps to make sure 
drivers/ata/ahci.c has the appropriate wildcard entry in its 
pci_device_id table.

Really, look at the sata_nv bug reports that keep popping up.  We want 
to move away from that driver long term, and always drive the SATA 
interface in AHCI mode.

The proposed sata_nv patch does the opposite -- guarantees we must 
support the continually problematic legacy IDE interface ad infinitum. 
Such patches are OK for the test lab, but in this specific case users 
/suffer/ when not running AHCI mode.

	Jeff



