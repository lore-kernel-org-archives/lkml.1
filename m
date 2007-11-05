Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbXKESjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbXKESjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 13:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbXKESjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 13:39:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62762 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbXKESjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 13:39:24 -0500
Subject: Re: [PATCH 34/54] Driver Core: add kobj_attribute handling
From: Kay Sievers <kay.sievers@vrfy.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20071105191705.5f2baaaa@gondolin.boeblingen.de.ibm.com>
References: <20071102235758.GA9803@kroah.com>
	 <1194047972-9850-34-git-send-email-gregkh@suse.de>
	 <20071105134203.1c078136@gondolin.boeblingen.de.ibm.com>
	 <1194279812.6771.11.camel@lov.site> <20071105171133.GD12843@suse.de>
	 <1194283540.2174.8.camel@lov.site>
	 <20071105184350.0a1cd957@gondolin.boeblingen.de.ibm.com>
	 <1194286070.2174.14.camel@lov.site>
	 <20071105191705.5f2baaaa@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Mon, 05 Nov 2007 19:39:31 +0100
Message-Id: <1194287971.2174.27.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX198Ui3V3HzE1EWE+cSTgCwklr3pJBVd/lHQKP1
 eLoOtM/e81nVryfu4Kyhhp9i1kg2ZgkV3rmrb8GJttXHU72BC3
 S9HOE/K6KZkb7+sBw9b5gE7s3+cnnSS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-05 at 19:17 +0100, Cornelia Huck wrote:
> On Mon, 05 Nov 2007 19:07:50 +0100,
> Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > On Mon, 2007-11-05 at 18:43 +0100, Cornelia Huck wrote:
> > > On Mon, 05 Nov 2007 18:25:40 +0100,
> > > Kay Sievers <kay.sievers@vrfy.org> wrote:
> > > 
> > > > > > That should usually be done by default attributes assigned to the ktype.
> > > > > > Do you have a good use case, where people need to create such attributes
> > > > > > individually instead?
> > > > > 
> > > > > The s390 code that was converted to use kobj_attributes :)
> > > > > 
> > > > > These look very useful, I'll go add them to the series unless Kay really
> > > > > objects.
> > > > 
> > > > I just want to hear a good reason to create attributes individually. :)
> > > > Especially in conjunction with kobject_register(), these attributes are
> > > > not available at uevent time, which is really really bad.
> > > > 
> > > > Default attributes just work fine, and have the proper error handling
> > > > built-in. Offering special functions for it, may just encourage people
> > > > to continue this "broken" way of creating attributes.
> > > 
> > > But where should I specify those default attributes?
> > > kset_create_and_register() sets the ktype to kset_ktype...
> > 
> > Do you need to create attributes at a kset itself, not the kobjects that
> > belong to the kset?
> 
> Yes, see arch/s390/kernel/ipl.c

Where are the objects that join this kset? A kset is a "collection of
objects of a similar type", If there are no objects, you don't need a
kset at all, I guess, but just a plain directory. :)

Anyway, seems we need an easy way to pass default attributes to ksets
and plain directories. If userspace should set some values here when a
subsystems creates the its sysfs representation, we must make sure, that
the attributes exist at the time the event is sent, otherwise we will
run into all sorts of timing problems.

> (and I guess anything that uses
> subsys_create_file() before).

Well, some users embedded ksets(subsystem) into objects, because it they
confused kobjects and ksets. So there may be a only very few valid users
left. :)

Kay

