Return-Path: <linux-kernel-owner+w=401wt.eu-S1762742AbXK3Jba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762742AbXK3Jba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 04:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbXK3JbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 04:31:22 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:1447 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbXK3JbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 04:31:21 -0500
Date: Fri, 30 Nov 2007 10:30:32 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before
 kobject_init
Message-ID: <20071130103032.6393d846@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1196368000.7903.28.camel@lov.site>
References: <Pine.LNX.4.44L0.0711291455410.5666-100000@iolanthe.rowland.org>
	<1196367597.7903.25.camel@lov.site>
	<1196368000.7903.28.camel@lov.site>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 21:26:40 +0100,
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Thu, 2007-11-29 at 21:20 +0100, Kay Sievers wrote:
> > On Thu, 2007-11-29 at 15:09 -0500, Alan Stern wrote:
> > > On Thu, 29 Nov 2007, Kay Sievers wrote:
> 
> > > > > There's another good reason for not assigning the name in
> > > > > kobject_init(): Code that uses kobjects (like the driver core) doesn't
> > > > > set the name until later.
> > > > 
> > > > That can be done at any stage, I guess. We will rip out the name in the
> > > > struct device anyway.
> > > 
> > > Are you also going to change all the places in the kernel where the
> > > device name (.bus_id) isn't set until after device_initialize() has
> > > been called?

Hmpf, ccw does this as well...

> > 
> > Yes, I already have a patch that does that for all stuff that was needed
> > on my boxes.
> 
> To be exact, bus_id will be removed from the device, and the device name
> will be set and retrieved directly from the kobject.

I guess you'll have accessor functions for the bus id for use by higher
level code?
