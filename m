Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbYBYVea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbYBYVea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYBYVeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:34:22 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:45490 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbYBYVeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:34:21 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: Re: net: tx timeouts with skge, 8139too, dmfe drivers/NICs
Date: Mon, 25 Feb 2008 23:36:06 +0200
User-Agent: KMail/1.9.7
References: <200802252237.12326.mitov@issp.bas.bg> <47C32AAD.8040000@garzik.org>
In-Reply-To: <47C32AAD.8040000@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802252336.06498.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 February 2008 10:53:01 pm you wrote:
> Marin Mitov wrote:
> > Hi all,
> >
> > I experience very rare freezes at heavy outbound traffic
> > (sending ~4GB DVD image to another host(s) on the same LAN)
> > using skge driver (NIC on the mobo) as well as (recently tested)
> > using rtl8139 or dmfe NICs on the PCI bus. There is a single
> > switch between them (tested with another one just to exclude
> > a faulty switch).
> >
> > skge <--> Marvell 88E8001 chip
> > 8139too <--> Realtek 8136B chip
> > dmfe <--> Davicom DM9102 chip
> >
> > Symptoms are similar: tx timeouts and no more net activity.
> > KDE desktop works, computational programs - work, the machine
> > is usable, but cannot ping, nor can be ping-ed anymore.
> > rmmod && modprobe the respective modules repairs the problem.
> > Simple surfing/e-mailing from it do not trigger the problem.
> >
> > The machine is used as LTSP server for old PCs (as X terminals)
> > (mostly outbound traffic) and is not usable as such due to this
> > problem.
> >
> > The kernel is 2.6.24.2-SMP/x86_32 (PREEMPT or not - NO difference).
> >
> > As far as this happens with 3 different NICs/drivers could it be
> > a problem in the (common for all of them) networking subsystem?
>
> A TX timeout (like hardware timeouts, in general) is a very generic
> behavior, with many causes.
>
> In general, when you see timeouts with varied hardware and drivers,
> you're almost always dealing with a problem with interrupt delivery, or

All the drivers are using #INTA on PCI bus (no MSI/MSI-X).

"problem with interrupt delivery" - you suspect interrupts incorrectly
 disabled (lost) in the drivers or faulty hardware(motherboard)?

> a generic system problem, rather than bugs in the network stack or all

"a generic system problem" - bad config or faulty hardware(motherboard)?

Where I should look for the problem?

Just for info: the system is very stable - uptime (if no power outages) could
be a month or more (rebooting for kernel changes or updates).

Marin Mitov

> three drivers.
>
> 	Jeff
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


