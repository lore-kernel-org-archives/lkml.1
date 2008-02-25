Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbYBYVme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbYBYVme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbYBYVmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:42:25 -0500
Received: from mail.vyatta.com ([216.93.170.194]:36474 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbYBYVmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:42:24 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.431
Date: Mon, 25 Feb 2008 13:42:16 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: linux-kernel@vger.kernel.org
Subject: Re: net: tx timeouts with skge, 8139too, dmfe drivers/NICs
Message-ID: <20080225134216.7704696d@extreme>
In-Reply-To: <200802252336.06498.mitov@issp.bas.bg>
References: <200802252237.12326.mitov@issp.bas.bg>
	<47C32AAD.8040000@garzik.org>
	<200802252336.06498.mitov@issp.bas.bg>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 23:36:06 +0200
Marin Mitov <mitov@issp.bas.bg> wrote:

> On Monday 25 February 2008 10:53:01 pm you wrote:
> > Marin Mitov wrote:
> > > Hi all,
> > >
> > > I experience very rare freezes at heavy outbound traffic
> > > (sending ~4GB DVD image to another host(s) on the same LAN)
> > > using skge driver (NIC on the mobo) as well as (recently tested)
> > > using rtl8139 or dmfe NICs on the PCI bus. There is a single
> > > switch between them (tested with another one just to exclude
> > > a faulty switch).
> > >
> > > skge <--> Marvell 88E8001 chip
> > > 8139too <--> Realtek 8136B chip
> > > dmfe <--> Davicom DM9102 chip
> > >
> > > Symptoms are similar: tx timeouts and no more net activity.
> > > KDE desktop works, computational programs - work, the machine
> > > is usable, but cannot ping, nor can be ping-ed anymore.
> > > rmmod && modprobe the respective modules repairs the problem.
> > > Simple surfing/e-mailing from it do not trigger the problem.
> > >
> > > The machine is used as LTSP server for old PCs (as X terminals)
> > > (mostly outbound traffic) and is not usable as such due to this
> > > problem.
> > >
> > > The kernel is 2.6.24.2-SMP/x86_32 (PREEMPT or not - NO difference).
> > >
> > > As far as this happens with 3 different NICs/drivers could it be
> > > a problem in the (common for all of them) networking subsystem?
> >
> > A TX timeout (like hardware timeouts, in general) is a very generic
> > behavior, with many causes.
> >
> > In general, when you see timeouts with varied hardware and drivers,
> > you're almost always dealing with a problem with interrupt delivery, or
> 
> All the drivers are using #INTA on PCI bus (no MSI/MSI-X).
> 
> "problem with interrupt delivery" - you suspect interrupts incorrectly
>  disabled (lost) in the drivers or faulty hardware(motherboard)?
> 
> > a generic system problem, rather than bugs in the network stack or all
> 
> "a generic system problem" - bad config or faulty hardware(motherboard)?
> 
> Where I should look for the problem?
> 
> Just for info: the system is very stable - uptime (if no power outages) could
> be a month or more (rebooting for kernel changes or updates).
> 
> Marin Mitov

Make sure the interrupt is showing up as level triggered in /proc/interrupts.
The BIOS may be configuring it as edge-triggered and that won't work with
Ethernet drivers that use NAPI.
