Return-Path: <linux-kernel-owner+w=401wt.eu-S1760396AbXIMROF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760396AbXIMROF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 13:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbXIMRNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 13:13:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47266 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752654AbXIMRNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 13:13:54 -0400
Date: Thu, 13 Sep 2007 12:13:49 -0500
From: Robin Holt <holt@sgi.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Robin Holt <holt@sgi.com>, Mikael Pettersson <mikpe@it.uu.se>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: Possible hang inside interrupt handler on sata_promise.
Message-ID: <20070913171349.GD26213@lnx-holt.americas.sgi.com>
References: <20070912131904.GW14474@lnx-holt.americas.sgi.com> <46E95E5D.2050305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E95E5D.2050305@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any way on typical motherboards to send an NMI?  On Altix boxes,
we can use the system controller to send an NMI.  I have found some
motherboards appear to have an NMI line.  Is there anything like that
on i386?  Maybe I am missing the issue entirely.  Does deadlock inside
an IRQ handler seem plausible?

On a side note, I have reproduced the hang with a different storage device
(ide).  At the time, I have deactivated the volume group, stopped the
raid device and unloaded the sata_promise module.  I also noticed that
uhci_hcd and eth1 (3com 3c59x module) are sharing IRQ 5 so I had unloaded
the uhci_hcd and usbcore before the last test.

On Thu, Sep 13, 2007 at 11:59:25AM -0400, Chuck Ebbert wrote:
> There is a list of kernel options you can try, including:
> 
>   noapic
>   nolapic
>   pci=nomsi,nommconf
>   pci=noacpi

I will try these this evening.

Thanks,
Robin
