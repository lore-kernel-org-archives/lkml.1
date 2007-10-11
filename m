Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbXJKO7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbXJKO7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 10:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbXJKO7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 10:59:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37197 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874AbXJKO7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 10:59:03 -0400
Message-ID: <470E3A35.4000104@garzik.org>
Date: Thu, 11 Oct 2007 10:59:01 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Bernd Schubert <bs@q-leap.de>
CC: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] faster workaround
References: <200710081709.18253.bs@q-leap.de>	<200710101112.20448.bs@q-leap.de>	<200710111409.56210.bs@q-leap.de>	<200710111433.23833.bs@q-leap.de>	<20071011142628.48272a4a@the-village.bc.nu>	<470E30F9.5060705@garzik.org> <20071011155024.46007973@the-village.bc.nu>
In-Reply-To: <20071011155024.46007973@the-village.bc.nu>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> The problem is that the 3112 generates Data FIS's of a size other than a 
>> multiple of 512 bytes.  Spec-legal, but exposed firmware bugs in many 
>> early SATA drives.  Early Seagate hard drives choked when the formula 
>> (sector%15)==1 was satisfied (or something along those lines).
> 
> And the 3114 is the same ?

3114 should not be affected by this problem (see below).

Most likely we are led down this road because the 'slow_down' module 
parameter has an excellent capacity for hiding all manner of problems.

As a tangent from this thread, this is why I was OK with adding the 
libata.dma even for SATA.  Sometimes knobs are found useful by users, 
though perhaps not its original intended use.  Sometimes masking a 
hardware problem can help you get through the rest of your day on hold 
with vendor support :)


>> 2) Once we identified, over time, the set of drives affected by this 
>> 3112 quirk (aka drives that didn't fully comply to SATA spec), the 
>> debugging of corruption cases largely shifted to the standard routine: 
>> update the BIOS, replace the cables/RAM/power/mainboard/slot/etc. to be 
>> certain of problem location.
> 
> Except for the continued series of later SI + Nvidia chipset (mostly)
> pattern which seems unanswered but also being later chips I assume
> unrelated to this problem.

The SIL_FLAG_MOD15WRITE flag is set in sil_port_info[] is set according 
to the best info we have from SiI, which indicates that 3114 and 3512 do 
not have the same problem as the 3112.

	Jeff


