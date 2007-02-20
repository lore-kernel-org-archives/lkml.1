Return-Path: <linux-kernel-owner+w=401wt.eu-S965049AbXBTP2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965049AbXBTP2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965039AbXBTP2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:28:08 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43752 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965049AbXBTP2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:28:06 -0500
Message-ID: <45DB137F.1060301@garzik.org>
Date: Tue, 20 Feb 2007 10:27:59 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: Robert Hancock <hancockr@shaw.ca>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: pata_amd dropping to PIO on resume
References: <fa.q7ZuddHInqn2dVlS+EWjXjPvFC8@ifi.uio.no>	<45D63BCE.2080700@shaw.ca>	<45D6436C.4060209@garzik.org> <20070219220812.11c3baba@localhost.localdomain>
In-Reply-To: <20070219220812.11c3baba@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
>> Deleting the ata_pci_clear_simplex() call, then adding 
>> ATA_FLAG_IGN_SIMPLEX to the ata_port_info info[] array, is also worth 
>> trying.
> 
> I think I know what is going on here. Firstly the simplex bits
> need re-clearing on a resume. On my todo list now I'm back

If the bit does not actually alter /hardware/ operation, then
ATA_FLAG_IGN_SIMPLEX use is preferred over having to remember various 
places where the bit must be twiddled.  Its easier to leave the bit in 
the BIOS-initialized state, and ignore the hardware bit's existence in 
software, if we know the behavior in the controller is hardwired.  Less 
room for software bugs that way, IMO.

	Jeff


