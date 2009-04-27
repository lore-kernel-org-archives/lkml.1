Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbZD0UE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbZD0UE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757573AbZD0UEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:04:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:43620 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757271AbZD0UEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:04:20 -0400
Cc: Ira Snyder <iws@ovro.caltech.edu>, Liu Dave-R63238 <DaveLiu@freescale.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Dan Williams <dan.j.williams@intel.com>,
       Timur Tabi <timur@freescale.com>
Message-Id: <9B86B565-1A28-46CD-8C30-DECB3EBF0763@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: David Hawkins <dwh@ovro.caltech.edu>
In-Reply-To: <49F60EC9.2050501@ovro.caltech.edu>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
Date: Mon, 27 Apr 2009 15:02:03 -0500
References: <20090424183517.GB23140@ovro.caltech.edu>	<D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net>	<ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com>	<49F608B7.9080409@ovro.caltech.edu>	<49F60A3A.4060402@freescale.com>	<49F60BF8.8040404@ovro.caltech.edu> <46B638E2-885C-4281-81EA-CB685264E143@kernel.crashing.org> <49F60EC9.2050501@ovro.caltech.edu>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 27, 2009, at 3:00 PM, David Hawkins wrote:

>
>>> Can you give me an example of non-PCI memory that would be
>>> non-prefetchable that you'd like us to try? We can see if our
>>> host CPUs have an area like that ... we just need to know
>>> what device to look for first :)
>> You can mark the pci inbound window on the 83xx as non-prefetchable  
>> (assuming 83xx is host). On a x86 host I doubt there is any easy  
>> way to get non-prefetchable memory.
>
> Yep, we were going to do that, but chose to use the
> 1MB region already setup for the IMMRs since its already
> marked as non-prefetchable. We were only doing reads, so
> it wasn't going to hurt anything.
>
> I doubt that marking one of the other BAR regions
> as non-prefetchable will give a different result.
> However, we're more than happy to double-check if
> you'd like.

Its possible you'll get a different result since IMMR is a register  
space internal and thats normally a completely different bus than  
memory would be (internal to the 83xx).  I'd suggest double-checking w/ 
a BAR marked non-prefetch pointing to real memory.

- k
