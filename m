Return-Path: <linux-kernel-owner+w=401wt.eu-S1759590AbZFPQeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590AbZFPQeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756593AbZFPQeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:34:06 -0400
Received: from mail.oxtel.com ([193.200.114.15]:2166 "EHLO oxtel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756172AbZFPQeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:34:06 -0400
Message-ID: <4A37C97A.5050508@oxtel.com>
Date: Tue, 16 Jun 2009 17:34:02 +0100
From: Chris Pringle <chris.pringle@oxtel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PowerPC PCI DMA issues (prefetch/coherency?)
References: <4A37A503.3030209@oxtel.com>
 <20090616162114.GA5051@loki.buserror.net>
In-Reply-To: <20090616162114.GA5051@loki.buserror.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: chris.pringle
X-Server: VPOP3 Enterprise V2.6.0b - Registered
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:
> On Tue, Jun 16, 2009 at 02:58:27PM +0100, Chris Pringle wrote:
>   
>> We're developing on a Freescale MPC8272 and are having some nasty  
>> problems with PCI bus mastering and data corruption.
>>     
>
> What kernel version?  What firmware?  Custom board, or one in upstream
> (which one)?
>   
The kernel version is 2.6.26. Firmware is custom on a custom board.
> Cache coherency on PCI DMA requires that the memory be mapped with the M
> attribute on this chip, but that should be happening based on detection of
> the core.
>   
I'm not sure where to look to verify this?
> Also make sure that you park the bus on PCI and raise its arbitration
> priority, as done at the end of fixup_pci in arch/powerpc/boot/cuboot-pq2.c.
>   
Since this is a reasonably recent kernel, I'd guess that both of these 
things are correct. I've had a quick look in that file and there is code 
in there raising arbitartion priority and parking the bus.
> BTW, you may want to post to linuxppc-dev@lists.ozlabs.org for
> powerpc-specific issues, especially this kind of hardware issue.
>
>   
I've just posted there :-)

Interestingly, I've just turned off cache snooping and the problem has 
got much worse. This has surprised me as I thought that part of the job 
done by pci_map_sg was to flush the CPU cache - so I wasn't expecting 
this to make any difference. The memory corruption with the cache 
snooping turned off is almost identical to that which I'm seeing with it 
turned on, only much, much worse.


-- 

______________________________
Chris Pringle
Software Engineer

Miranda Technologies Ltd.
Hithercroft Road
Wallingford
Oxfordshire OX10 9DG
UK

Tel. +44 1491 820206
Fax. +44 1491 820001
www.miranda.com

____________________________

Miranda Technologies Limited
Registered in England and Wales CN 02017053
Registered Office: James House, Mere Park, Dedmere Road, Marlow, Bucks, SL7 1FJ
