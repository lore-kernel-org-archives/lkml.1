Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbXGGPjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbXGGPjb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 11:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbXGGPjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 11:39:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35521 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbXGGPjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 11:39:20 -0400
Message-ID: <468FB3A5.9000008@garzik.org>
Date: Sat, 07 Jul 2007 11:39:17 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Kuan Luo <kluo@nvidia.com>, hancockr@shaw.ca, Peer Chen <pchen@nvidia.com>,
       Allen Martin <AMartin@nvidia.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-ide@vger.kernel.org
Subject: Disabling ADMA?  (was Re: [PATCH] drivers/ata: Add the SW NCQ support
 to sata_nv for MCP51/MCP55/MCP61)
References: <15F501D1A78BD343BE8F4D8DB854566B059FE131@hkemmail01.nvidia.com>
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B059FE131@hkemmail01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kuan Luo wrote:
> 	@@ -1714,3 +2761,6 @@ module_init(nv_init);
> 	 module_exit(nv_exit);
> 	 module_param_named(adma, adma_enabled, bool, 0444);
> 	 MODULE_PARM_DESC(adma, "Enable use of ADMA (Default: true)");
> 	+module_param_named(ncq, ncq_enabled, bool, 0444);
> 	+MODULE_PARM_DESC(ncq, "Enable use of NCQ (Default: false)");

After looking through sata_nv bug reports, I am leaning towards 
disabling ADMA by default, and wanted to solicit comments.

While admittedly not knowing the root cause, it seems like every current 
outstanding sata_nv bug report that remains after switching out hardware 
can be solved by setting module option 'adma' to zero.  That's my first 
suggestion upon any bugzilla sata_nv bug, and it usually works.  You can 
look through bugs assigned to or CC'd to jgarzik@pobox.com (kernel.org 
bugs) jgarzik@redhat.com (redhat.com bugs) for examples.

I still need to review the SWNCQ patch in detail, but I presume it is 
possible to still use SWNCQ without ADMA?

On a side note, I would rather default SWNCQ to 'on'.

	Jeff




