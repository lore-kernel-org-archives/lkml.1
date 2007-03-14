Return-Path: <linux-kernel-owner+w=401wt.eu-S1422651AbXCNUzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422651AbXCNUzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422652AbXCNUzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:55:49 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:48183 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422651AbXCNUzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:55:48 -0400
Date: Wed, 14 Mar 2007 20:55:46 +0000 (GMT)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc3-mm2 (oops in move_freepages)
In-Reply-To: <200703141446.16274.bjorn.helgaas@hp.com>
Message-ID: <Pine.LNX.4.64.0703142054170.23208@skynet.skynet.ie>
References: <20070307201915.4d579113.akpm@linux-foundation.org>
 <200703141236.09599.bjorn.helgaas@hp.com> <Pine.LNX.4.64.0703141855010.18468@skynet.skynet.ie>
 <200703141446.16274.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007, Bjorn Helgaas wrote:

> On Wednesday 14 March 2007 12:59, Mel Gorman wrote:
>>> <SNIP>
>>> Virtual mem_map starts at 0xa0007fffc7200000
>>> Zone PFN ranges:
>>
>> Total aside, a message should have been printed out here with
>> "sizeof(struct page) = ??" when loglevel was set to 8. I wanted it so I
>> could work out PFNs from the faulting addresses. Can you find such a
>> string in the output of dmesg?
>
> You probably don't need this anymore, but sizeof(struct page) = 56.
>

Thanks, it allowed me to confirm that the fault happened in a definite 
hole based on the output of early_node_map[] so that's good to know. If it 
happened in a location that should have had memory, I would be worried.

>>> BUG: at drivers/pci/pci.c:679 pci_restore_state()
>>>
>>> Call Trace:
>>> [<a000000100014980>] show_stack+0x40/0xa0
>>>                                sp=e000004063a5fb90 bsp=e000004063a58f98
>>> [<a0000001000152b0>] dump_stack+0x30/0x60
>>>                                sp=e000004063a5fd60 bsp=e000004063a58f80
>>> [<a0000001003f8800>] pci_restore_state+0x480/0x4a0
>>>                                sp=e000004063a5fd60 bsp=e000004063a58f38
>>> [<a00000010051a0b0>] tg3_chip_reset+0x6d0/0x1020
>> ...
>> That doesn't look particularly healthy! Is this a known problem?
>
> Yeah, that's ugly, isn't it?  I hadn't got to worrying about that yet.
>

heh, ok.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
