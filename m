Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbXDQHrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbXDQHrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbXDQHrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:47:05 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:50113 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbXDQHrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:47:03 -0400
Date: Tue, 17 Apr 2007 09:49:34 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Patch -mm 0/3] RFC: module unloading vs. release function
Message-ID: <20070417094934.2709cd80@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0704161634460.2795-100000@iolanthe.rowland.org>
References: <d120d5000704161318t7bbc8ab9t3a23145dcc44e7dd@mail.gmail.com>
	<Pine.LNX.4.44L0.0704161634460.2795-100000@iolanthe.rowland.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007 17:02:46 -0400 (EDT),
Alan Stern <stern@rowland.harvard.edu> wrote:

> > No, only the core module has to stay. For example, every time you
> > register an input device you pin input.ko as it is the module that
> > provides ->release() method for input devices. You can freely unload
> > psmouse, or hid or your favorite joystick but input has to stay until
> > last reference to the input device is dropped. serio and gameport work
> > the same way.
> > 
> > I think the requirement that one is not able to unload a core
> > subsystem module untill all users are dropped off is ok - you can't
> > unload it anyway until you unload all drivers that reference its
> > exported functions and once you unload all the drivers data objects
> > will drop off pretty quickly.
> 
> The problem is that sometimes devices are owned by modules that aren't
> core subsystem modules.  Or the code using a device doesn't depend on the
> device's owner module and therefore doesn't pin it.

Yes. For example, zfcp creates some devices itself that don't have any
relation to the ccw bus. (Other s390 drivers need a simple device; they
use a generic device creation routine that uses a release function that
is always built into s390 kernels.)
