Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbXDQHYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbXDQHYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbXDQHYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:24:08 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:6692 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbXDQHXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:23:44 -0400
Date: Tue, 17 Apr 2007 09:26:15 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <htejun@gmail.com>,
       Markus Rechberger <markus.rechberger@amd.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Swen Schillig <swen@vnet.ibm.com>
Subject: Re: [linux-usb-devel] How should an exit routine wait for release()
 callbacks?
Message-ID: <20070417092615.7381a5f3@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070416221247.GA9365@kroah.com>
References: <20070413162701.4e7342a9@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.44L0.0704131049380.3407-100000@iolanthe.rowland.org>
	<20070416221247.GA9365@kroah.com>
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

On Mon, 16 Apr 2007 15:12:47 -0700,
Greg KH <greg@kroah.com> wrote:

> Ah, just found this original thread, now Cornelia's patches make more
> sense...

I would have included a pointer, but couldn't access marc yesterday
evening, sorry...

> 
> On Fri, Apr 13, 2007 at 11:24:58AM -0400, Alan Stern wrote:
> > Tejun, it just occurred to me that you would be interested in this email 
> > thread.  Just to bring you up to speed, here's the original question:
> > 
> > > I've got a module which registers a struct device.  (It represents a
> > > virtual device, not a real one, but that doesn't matter.)
> 
> Wait, that's the issue right there.
> 
> Don't do that.
> 
> devices should be created by busses or the platform core, which owns the
> release function for them.  Individual drivers should not create
> devices.

There are drivers that do it, for a variety of reasons.

> 
> Hm, but then, how would you ever unload a bus, as the same issue might
> be there too...

Exactly :) This would imply busses/subsystems could never be unloadable
modules.

> 
> Any specific code in the kernel you can point to that has this issue
> today?

zfcp comes to mind. They register some units in zfcp_aux.c, which don't
have anything to do with the bus the zfcp adapter is on (the ccw bus).
Currently, that is "solved" by disallowing zfcp module unloading.
