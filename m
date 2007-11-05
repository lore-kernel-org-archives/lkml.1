Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbXKEUCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbXKEUCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 15:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbXKEUCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 15:02:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:57711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbXKEUC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 15:02:29 -0500
Date: Mon, 5 Nov 2007 12:01:47 -0800
From: Greg KH <gregkh@suse.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/54] Driver Core: add kobj_attribute handling
Message-ID: <20071105200147.GA25907@suse.de>
References: <1194047972-9850-34-git-send-email-gregkh@suse.de> <20071105134203.1c078136@gondolin.boeblingen.de.ibm.com> <1194279812.6771.11.camel@lov.site> <20071105171133.GD12843@suse.de> <1194283540.2174.8.camel@lov.site> <20071105184350.0a1cd957@gondolin.boeblingen.de.ibm.com> <1194286070.2174.14.camel@lov.site> <20071105191705.5f2baaaa@gondolin.boeblingen.de.ibm.com> <1194287971.2174.27.camel@lov.site> <20071105195950.604ea56f@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105195950.604ea56f@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 07:59:50PM +0100, Cornelia Huck wrote:
> On Mon, 05 Nov 2007 19:39:31 +0100,
> Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > Where are the objects that join this kset? A kset is a "collection of
> > objects of a similar type", If there are no objects, you don't need a
> > kset at all, I guess, but just a plain directory. :)
> 
> Yes, ipl.c looks a lot like "we need a subdirectory under /sys/firmware/
> and need to jump through hoops to get it there".

In looking at all of the users of the firmware subdirectory, that is
what they are all needing that subdirectory for.

Ugh, I'll go change that up and delete that kset, and a few of the other
ksets as they just need to be directories, not full-blown ksets.

> > Anyway, seems we need an easy way to pass default attributes to ksets
> > and plain directories. If userspace should set some values here when a
> > subsystems creates the its sysfs representation, we must make sure, that
> > the attributes exist at the time the event is sent, otherwise we will
> > run into all sorts of timing problems.
> 
> Maybe they need something like device->uevent_suppress, but at the
> kobject level?

Ugh, I hope not :)

thanks,

greg k-h
