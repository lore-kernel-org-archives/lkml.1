Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbYHNAa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbYHNAa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 20:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYHNAaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 20:30:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55553 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbYHNAaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 20:30:17 -0400
Date: Wed, 13 Aug 2008 17:23:05 -0700
From: Greg KH <greg@kroah.com>
To: Marcin Obara <marcin_obara@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
Message-ID: <20080814002305.GA7359@kroah.com>
References: <alpine.DEB.1.00.0807180742560.7868@ip-195-3-221-75.vnet.pl> <alpine.DEB.1.00.0807181938180.12442@ip-195-3-221-75.vnet.pl> <alpine.DEB.1.00.0807182122460.24146@ip-195-3-221-75.vnet.pl> <alpine.DEB.1.00.0807182229070.30162@ip-195-3-221-75.vnet.pl> <alpine.DEB.1.00.0807231958130.20791@ip-195-3-221-75.vnet.pl> <alpine.DEB.1.00.0808112115140.6724@ip-195-3-221-75.vnet.pl> <20080813005835.GE22793@kroah.com> <ea8d860a0808130016w646307few3cc6385caf9b1ec7@mail.gmail.com> <20080813181850.GD4886@kroah.com> <ea8d860a0808131248g31ffb10g37b14dc8af89038c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea8d860a0808131248g31ffb10g37b14dc8af89038c@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 08:48:19PM +0100, Marcin Obara wrote:
> 2008/8/13 Greg KH <greg@kroah.com>:
> >> GET_VERSION is called frequently
> >
> > Why?  Shouldn't it only be called once?
> Once per connection. But you can have many clients connecting.

Is that a real issue?

> >> With ioctl - only one file handle is used, and userspace client logic
> >> is simpler.
> >
> > But the kernel is messier and we are trying to not add any more ioctls
> > to it.  Especially for trivial things like the version number of the
> > hardware device.
> It's rather protocol version (=running software version) supported by
> hardware device.
> Hmmm, I just didn't know that there is something wrong with ioctls.

There always have been :)

> >> Normal flow looks like:
> >>
> >> open
> >> ioctl(GET_VERSION)
> >
> > Great, do an additional open/read/close here for the version, I think
> > you will find it pretty trivial to do :)
> Right, it's trivial.... but will make userspace source code messier and bigger.
> 
> Btw. I know we have powerful CPUs... but small wasting resources is
> still wasting resources... so we still need new CPUs :-).

So you keep your employer in business :)

Seriously, an ioctl for a hardware version number is total overkill
here.  Your other ioctls are also suspect, please repost with the
description of why they are all needed, with documentation about the
user/kernel interface you have created here.

thanks,

greg k-h
