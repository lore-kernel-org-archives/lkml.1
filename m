Return-Path: <linux-kernel-owner+w=401wt.eu-S1751675AbXBPXUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbXBPXUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbXBPXUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:20:33 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:37192 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbXBPXUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:20:32 -0500
Date: Fri, 16 Feb 2007 17:18:38 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: pata_amd dropping to PIO on resume
In-reply-to: <fa.q7ZuddHInqn2dVlS+EWjXjPvFC8@ifi.uio.no>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan <alan@lxorguk.ukuu.org.uk>
Message-id: <45D63BCE.2080700@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.q7ZuddHInqn2dVlS+EWjXjPvFC8@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> Possibly a known issue:
> 
> After resume pata_amd drops from UDMA/33 to PIO on my system.
> Reloading the module puts both attached optical drives (master and
> slave) back to UDMA/33.
> 
> AFAICS "simplex DMA is claimed by other device, disabling DMA" seems
> to be causing it to drop to PIO (but only after a suspend/resume
> cycle, not on boot or module load).
> 
> Burning a DVD with 6x speed using PIO makes heavy use of burnproof
> and makes the whole system quite sluggish. :)

Yes, the fact that it's going into simplex mode is the problem, it 
wasn't in simplex to start with. It looks like pata_amd does an 
ata_pci_clear_simplex only for certain chip models, maybe this model 
needs it as well?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

