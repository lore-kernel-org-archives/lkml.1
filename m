Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbYHMJiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbYHMJiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 05:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYHMJip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 05:38:45 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56090 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbYHMJio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 05:38:44 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48A2AB8E.1090102@s5r6.in-berlin.de>
Date: Wed, 13 Aug 2008 11:38:22 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Grant Grundler <grundler@google.com>
CC: linux1394-devel@lists.sourceforge.net,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: fw-sbp2: enforce s/g segment size limit
References: <489CB8D8.60908@s5r6.in-berlin.de>	 <20080809063159F.fujita.tomonori@lab.ntt.co.jp>	 <489CC17F.7000208@s5r6.in-berlin.de>	 <20080809071744I.fujita.tomonori@lab.ntt.co.jp>	 <tkrat.8f7aa8cea95d423b@s5r6.in-berlin.de>	 <tkrat.fa7d9c31f0c263fb@s5r6.in-berlin.de> <da824cf30808111252m1decf08fk7ce3405105e1ceef@mail.gmail.com>
In-Reply-To: <da824cf30808111252m1decf08fk7ce3405105e1ceef@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Sat, Aug 9, 2008 at 11:21 AM, Stefan Richter
>> -                       orb->page_table[j].low = cpu_to_be32(sg_addr);
>> -                       orb->page_table[j].high = cpu_to_be32(l << 16);
> 
> I didn't check the rest of the driver - but it would be good if it
> explicitly called dma_set_mask() or  pci_dma_set_mask() with a 32-bit
> mask value. Most drivers assume 32-bit and that's why I point this
> out.

I thought about this and currently think that I should not do this. 
There is the API to set the mask, but there is no API to _decrease_ the 
mask only.  The SBP-2 protocol driver should not set DMA_32BIT_MASK if 
any other driver already set for example DMA_31BIT_MASK for whatever reason.

For now, this is no issue.  FireWire low-level drivers exist only for 
controllers with 32 bit local bus addressing capability.  I am sure that 
somebody will remember to modify the SBP-2 driver(s) if there will ever 
be a controller type and a driver for it which can address more than 4 GB.

On the other hand, we also currently have no reason to set a smaller 
mask.  We recently discovered a chip bug which requires DMA_31BIT_MASK 
for a special mode of data reception (only for cache-coherent DMA 
though), but we now work around this chip bug by simply falling back to 
an alternative mode.
-- 
Stefan Richter
-=====-==--- =--- -==-=
http://arcgraph.de/sr/
