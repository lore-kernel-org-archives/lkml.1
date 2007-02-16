Return-Path: <linux-kernel-owner+w=401wt.eu-S1946322AbXBPXvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946322AbXBPXvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946320AbXBPXvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:51:16 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:42070 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946316AbXBPXvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:51:14 -0500
Message-ID: <45D6436C.4060209@garzik.org>
Date: Fri, 16 Feb 2007 18:51:08 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: pata_amd dropping to PIO on resume
References: <fa.q7ZuddHInqn2dVlS+EWjXjPvFC8@ifi.uio.no> <45D63BCE.2080700@shaw.ca>
In-Reply-To: <45D63BCE.2080700@shaw.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Tobias Diedrich wrote:
>> Possibly a known issue:
>>
>> After resume pata_amd drops from UDMA/33 to PIO on my system.
>> Reloading the module puts both attached optical drives (master and
>> slave) back to UDMA/33.
>>
>> AFAICS "simplex DMA is claimed by other device, disabling DMA" seems
>> to be causing it to drop to PIO (but only after a suspend/resume
>> cycle, not on boot or module load).
>>
>> Burning a DVD with 6x speed using PIO makes heavy use of burnproof
>> and makes the whole system quite sluggish. :)
> 
> Yes, the fact that it's going into simplex mode is the problem, it 
> wasn't in simplex to start with. It looks like pata_amd does an 
> ata_pci_clear_simplex only for certain chip models, maybe this model 
> needs it as well?
> 

Deleting the ata_pci_clear_simplex() call, then adding 
ATA_FLAG_IGN_SIMPLEX to the ata_port_info info[] array, is also worth 
trying.

	Jeff


