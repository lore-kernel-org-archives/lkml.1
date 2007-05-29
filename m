Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbXE2Wju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbXE2Wju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXE2Wjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:39:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57361 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbXE2Wjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:39:39 -0400
Message-ID: <465CABA3.10003@pobox.com>
Date: Tue, 29 May 2007 18:39:31 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Gary Zambrano <zambrano@broadcom.com>
CC: Michael Buesch <mb@bu3sch.de>, Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: b44: regression in 2.6.22 (resend)
References: <20070525172431.60affaca@freepuppy> <200705281655.15105.mb@bu3sch.de> <1180448075.17146.12.camel@dhcp-10-12-136-115.broadcom.com> <200705292245.22940.mb@bu3sch.de> <1180472741.17711.19.camel@dhcp-10-12-136-115.broadcom.com>
In-Reply-To: <1180472741.17711.19.camel@dhcp-10-12-136-115.broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Zambrano wrote:
> The b44 interrupt status reg returns a value of 0 if no interrupts are
> pending. The b44 uses a mask to determine which bits (events) can
> generate device interrupts on the system. If the masked interrupt status
> register bits are not asserted, then the b44 will return to the system
> with handled = 0. 
> So, I think the way the b44 interrupt code is written should be ok and
> not a bug. 


This is normal.

We check for 0xffffffff because that is often how a fault is indicated, 
when the memory location is read during or immediately after hotplug (or 
if the PCI bus is truly faulty).  So for most hardware, you see

tmp = read(irq status)
if (!tmp)
	return irq-none		/* no irq events raised */
if (tmp == 0xffffffff)
	return irq-none		/* hot unplug or h/w fault */

and the method that determines no interrupt handling is needed.

Regards,

	Jeff


