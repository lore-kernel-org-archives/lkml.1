Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbYBYUxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbYBYUxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYBYUxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:53:06 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:52954 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbYBYUxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:53:05 -0500
Message-ID: <47C32AAD.8040000@garzik.org>
Date: Mon, 25 Feb 2008 15:53:01 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Marin Mitov <mitov@issp.bas.bg>
CC: linux-kernel@vger.kernel.org
Subject: Re: net: tx timeouts with skge, 8139too, dmfe drivers/NICs
References: <200802252237.12326.mitov@issp.bas.bg>
In-Reply-To: <200802252237.12326.mitov@issp.bas.bg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marin Mitov wrote:
> Hi all,
> 
> I experience very rare freezes at heavy outbound traffic 
> (sending ~4GB DVD image to another host(s) on the same LAN) 
> using skge driver (NIC on the mobo) as well as (recently tested)
> using rtl8139 or dmfe NICs on the PCI bus. There is a single 
> switch between them (tested with another one just to exclude
> a faulty switch).
> 
> skge <--> Marvell 88E8001 chip
> 8139too <--> Realtek 8136B chip
> dmfe <--> Davicom DM9102 chip
> 
> Symptoms are similar: tx timeouts and no more net activity.
> KDE desktop works, computational programs - work, the machine 
> is usable, but cannot ping, nor can be ping-ed anymore.
> rmmod && modprobe the respective modules repairs the problem.
> Simple surfing/e-mailing from it do not trigger the problem.
> 
> The machine is used as LTSP server for old PCs (as X terminals)
> (mostly outbound traffic) and is not usable as such due to this
> problem.
> 
> The kernel is 2.6.24.2-SMP/x86_32 (PREEMPT or not - NO difference).
> 
> As far as this happens with 3 different NICs/drivers could it be
> a problem in the (common for all of them) networking subsystem?

A TX timeout (like hardware timeouts, in general) is a very generic 
behavior, with many causes.

In general, when you see timeouts with varied hardware and drivers, 
you're almost always dealing with a problem with interrupt delivery, or 
a generic system problem, rather than bugs in the network stack or all 
three drivers.

	Jeff



