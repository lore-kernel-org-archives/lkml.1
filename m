Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695Ab0AYXBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0AYXBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 18:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331Ab0AYXBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 18:01:52 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:19484 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab0AYXBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 18:01:52 -0500
X-IMAP-Sender: achiang
Date: Mon, 25 Jan 2010 15:46:28 -0700
X-OfflineIMAP-978951131-6c646c-494e424f582e4f7574626f78: 1264459603-0930583078911-v6.2.0
From: Alex Chiang <achiang@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] ACPI: processor: refactor internal
	map_lsapic_id()
Message-ID: <20100125224628.GB2828@grease.ALLEYCAT>
References: <20100125213221.28510.74078.stgit@bob.kio> <20100125214129.28510.72412.stgit@bob.kio> <alpine.DEB.2.00.1001251421440.27862@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1001251421440.27862@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

* David Rientjes <rientjes@google.com>:
> On Mon, 25 Jan 2010, Alex Chiang wrote:
> 
> > diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
> > index 9213f95..ec5989c 100644
> > --- a/drivers/acpi/processor_core.c
> > +++ b/drivers/acpi/processor_core.c
> > @@ -83,27 +83,17 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
> >  {
> >  	struct acpi_madt_local_sapic *lsapic =
> >  		(struct acpi_madt_local_sapic *)entry;
> > -	u32 tmp = (lsapic->id << 8) | lsapic->eid;
> >  
> > -	/* Only check enabled APICs*/
> >  	if (!(lsapic->lapic_flags & ACPI_MADT_ENABLED))
> >  		return 0;
> >  
> > -	/* Device statement declaration type */
> >  	if (device_declaration) {
> > -		if (entry->length < 16)
> > -			printk(KERN_ERR PREFIX
> > -			    "Invalid LSAPIC with Device type processor (SAPIC ID %#x)\n",
> > -			    tmp);
> 
> Why drop this error message?

It didn't seem to add any value.

If BIOS declares a processor with the Device statement in ACPI
and it has an invalid length, there's nothing that a user can do
about it.

Arguably, the message might be useful during internal platform
bringup (or new firmware validation), but even that's a hard sell
to me, since one of the first things a bringup engineer would
notice would be missing CPUs, and it wouldn't take that long to
realize that firmware was broken; why make upstream carry around
extra baggage for internal firmware debugging?

But I don't have a strong opinion here. If folks think that
message is useful, I can respin leaving it in.

Thanks,
/ac

