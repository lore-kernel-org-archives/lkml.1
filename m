Return-Path: <linux-kernel-owner+w=401wt.eu-S1757132AbXKESrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbXKESrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 13:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbXKESrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 13:47:15 -0500
Received: from ns2.suse.de ([195.135.220.15]:52375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137AbXKESrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 13:47:14 -0500
Date: Mon, 5 Nov 2007 10:46:36 -0800
From: Greg KH <gregkh@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/54] Driver Core: add kobj_attribute handling
Message-ID: <20071105184636.GA23031@suse.de>
References: <20071102235758.GA9803@kroah.com> <1194047972-9850-34-git-send-email-gregkh@suse.de> <20071105134203.1c078136@gondolin.boeblingen.de.ibm.com> <1194279812.6771.11.camel@lov.site> <20071105171133.GD12843@suse.de> <1194283540.2174.8.camel@lov.site> <20071105184350.0a1cd957@gondolin.boeblingen.de.ibm.com> <1194286070.2174.14.camel@lov.site> <20071105191705.5f2baaaa@gondolin.boeblingen.de.ibm.com> <1194287971.2174.27.camel@lov.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194287971.2174.27.camel@lov.site>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 07:39:31PM +0100, Kay Sievers wrote:
> On Mon, 2007-11-05 at 19:17 +0100, Cornelia Huck wrote:
> > On Mon, 05 Nov 2007 19:07:50 +0100,
> > Kay Sievers <kay.sievers@vrfy.org> wrote:
> > 
> > > On Mon, 2007-11-05 at 18:43 +0100, Cornelia Huck wrote:
> > > > On Mon, 05 Nov 2007 18:25:40 +0100,
> > > > Kay Sievers <kay.sievers@vrfy.org> wrote:
> > > > 
> > > > > > > That should usually be done by default attributes assigned to the ktype.
> > > > > > > Do you have a good use case, where people need to create such attributes
> > > > > > > individually instead?
> > > > > > 
> > > > > > The s390 code that was converted to use kobj_attributes :)
> > > > > > 
> > > > > > These look very useful, I'll go add them to the series unless Kay really
> > > > > > objects.
> > > > > 
> > > > > I just want to hear a good reason to create attributes individually. :)
> > > > > Especially in conjunction with kobject_register(), these attributes are
> > > > > not available at uevent time, which is really really bad.
> > > > > 
> > > > > Default attributes just work fine, and have the proper error handling
> > > > > built-in. Offering special functions for it, may just encourage people
> > > > > to continue this "broken" way of creating attributes.
> > > > 
> > > > But where should I specify those default attributes?
> > > > kset_create_and_register() sets the ktype to kset_ktype...
> > > 
> > > Do you need to create attributes at a kset itself, not the kobjects that
> > > belong to the kset?
> > 
> > Yes, see arch/s390/kernel/ipl.c
> 
> Where are the objects that join this kset? A kset is a "collection of
> objects of a similar type", If there are no objects, you don't need a
> kset at all, I guess, but just a plain directory. :)
> 
> Anyway, seems we need an easy way to pass default attributes to ksets
> and plain directories. If userspace should set some values here when a
> subsystems creates the its sysfs representation, we must make sure, that
> the attributes exist at the time the event is sent, otherwise we will
> run into all sorts of timing problems.

Kay is right, it should be simple to add the kobject attributes to the
kobject itself when it is registered to this kset, right?

> > (and I guess anything that uses
> > subsys_create_file() before).
> 
> Well, some users embedded ksets(subsystem) into objects, because it they
> confused kobjects and ksets. So there may be a only very few valid users
> left. :)

Hm, I don't think that anyone still does this anymore, as I think I
fixed up all of these horrible use cases :)

thanks,

greg k-h
