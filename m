Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbXLSQdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbXLSQdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbXLSQdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:33:43 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:48463 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbXLSQdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:33:42 -0500
Message-ID: <476947C1.2010405@s5r6.in-berlin.de>
Date: Wed, 19 Dec 2007 17:33:05 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       krh@bitplanet.net, linux1394-devel@lists.sourceforge.net
Subject: Re: No dma_sync_* during pci_probe? (Sparc, post 2.6.22 regression)
References: <47670BDF.80409@s5r6.in-berlin.de>	<20071217.165032.41424988.davem@davemloft.net>	<4767A323.7090205@s5r6.in-berlin.de> <20071218.142956.26529678.davem@davemloft.net>
In-Reply-To: <20071218.142956.26529678.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Date: Tue, 18 Dec 2007 11:38:27 +0100
> 
>> Also note:
>>   - The very same code did not oops at this point in 2.6.22.  It only
>>     started doing so in 2.6.23.
> 
> 2.6.23 is when the sparc64 IOMMU code started relying upon
> the dev_archdata bits being correct.

And why are the dev_archdata corrupt?
Does arch/sparc64/kernel/pci.c fill them in incorrectly or too late?

drivers/firewire/fw_ohci.c needs them for dma_map_single() +
dma_sync_single_for_device() in the pci_driver.probe(), sometime after
it called pci_enable_device(), before finishing the probe.
-- 
Stefan Richter
-=====-=-=== ==-- =--==
http://arcgraph.de/sr/
