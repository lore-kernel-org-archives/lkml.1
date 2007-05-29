Return-Path: <linux-kernel-owner+w=401wt.eu-S1752200AbXE2W7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbXE2W7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbXE2W7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:59:31 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2602 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbXE2W72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:59:28 -0400
X-Server-Uuid: 6B5CFB92-F616-4477-B110-55F967A57302
Subject: Re: b44: regression in 2.6.22 (resend)
From: "Gary Zambrano" <zambrano@broadcom.com>
To: "Jeff Garzik" <jgarzik@pobox.com>
cc: "Michael Buesch" <mb@bu3sch.de>,
       "Maximilian Engelhardt" <maxi@daemonizer.de>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       netdev@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <465CABA3.10003@pobox.com>
References: <20070525172431.60affaca@freepuppy>
 <200705281655.15105.mb@bu3sch.de>
 <1180448075.17146.12.camel@dhcp-10-12-136-115.broadcom.com>
 <200705292245.22940.mb@bu3sch.de>
 <1180472741.17711.19.camel@dhcp-10-12-136-115.broadcom.com>
 <465CABA3.10003@pobox.com>
Date: Tue, 29 May 2007 14:36:51 -0700
Message-ID: <1180474611.17711.26.camel@dhcp-10-12-136-115.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5)
X-WSS-ID: 6A426FC137035436522-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-29 at 18:39 -0400, Jeff Garzik wrote:

> We check for 0xffffffff because that is often how a fault is indicated, 
> when the memory location is read during or immediately after hotplug (or 
> if the PCI bus is truly faulty).  So for most hardware, you see
> 
> tmp = read(irq status)
> if (!tmp)
> 	return irq-none		/* no irq events raised */
> if (tmp == 0xffffffff)
> 	return irq-none		/* hot unplug or h/w fault */
> 
> and the method that determines no interrupt handling is needed.
> 

I guess you are right, but then shouldn't the driver be checking for
faults in other parts of the code too? What if a fault/hotplug occurs
immediately after an interrupt, but before a tx?
Thanks,
Gary

