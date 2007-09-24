Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbXIXGGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbXIXGGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 02:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbXIXGGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 02:06:01 -0400
Received: from main.gmane.org ([80.91.229.2]:49276 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbXIXGGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 02:06:00 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: PROBLEM: Network sky2 Module, kernel version 2.6.23-rc7
Date: Sun, 23 Sep 2007 23:06:24 -0700
Organization: Linux Foundation
Message-ID: <20070923230624.6f25ace5@oldman>
References: <46E2BC6A.4070800@gmx.de>
	<46EF4DE1.4000707@soo.com>
	<46EFE09B.6090901@tmr.com>
	<20070918080525.7a49d110@freepuppy.rosehill.hemminger.net>
	<46F21692.4020607@soo.com>
	<46F5C7B4.7050802@soo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 069-064-229-129.pdx.net
In-Reply-To: <46F5C7B4.7050802@soo.com>
X-Newsreader: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2007 21:56:04 -0400
ben soo <lnx-kern@soo.com> wrote:

> i spoke too soon.  The Gbit interface still dies.  Lasted around 
> 19hrs. or so.  i can't tell if there are hardware issues: yesterday 
> a Gbit NIC on the firewall died.  Different chip (Realtek), 
> different driver, different machine, same segment.  Segment is a 
> mix of 100Mbit and 1Gbit machines.
> 
> Symptoms of the failure are it just stops functioning with no error 
> messages.  ifconfig says there are packets being TX'd and none 
> being RX'd.  Interface can't be brought up again.
> 
> i use this box as the secondary DNS for our Internet domains 
> (unblocked by firewall), as well as the database server for our 
> developmental web CMS and the LAN ntp server (both services 
> invisible outside the LAN).
> 
> 
> dmesg says this on bootup:
> 
> > ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 18 (level, low) -> IRQ 16
> > PCI: Setting latency timer of device 0000:01:00.0 to 64
> > sky2 0000:01:00.0: v1.17 addr 0xdfefc000 irq 16 Yukon-EC (0xb6) rev 2
> > sky2 eth0: addr 00:01:29:d6:35:f4
> > ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 19 (level, low) -> IRQ 17
> > PCI: Setting latency timer of device 0000:02:00.0 to 64
> > sky2 0000:02:00.0: v1.17 addr 0xdfcfc000 irq 17 Yukon-EC (0xb6) rev 2
> > sky2 eth1: addr 00:01:29:d6:36:26

Does your network switch support flowcontrol?  The Yukon-EC may have
a hardware problem that happens if FIFO gets full. If flow control is enabled,
that shouldn't happen. 

The newest version of the driver has a watchdog to try
and detect and do an automatic reset, but it still means there would be about
2 seconds of downtime.

