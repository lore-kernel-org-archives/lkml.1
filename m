Return-Path: <linux-kernel-owner+w=401wt.eu-S1760869AbXEWE0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869AbXEWE0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 00:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbXEWEZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 00:25:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55552 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534AbXEWEZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 00:25:47 -0400
Date: Tue, 22 May 2007 21:25:29 -0700
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Pierre Ossman <drzeus-list@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Kristian H?gsberg <krh@bitplanet.net>
Subject: Re: Race free attributes in sysfs
Message-ID: <20070523042529.GC27329@kroah.com>
References: <46502A8B.70803@drzeus.cx> <3ae72650705211050p6b6cefbdya70dd4e0a27e2d1b@mail.gmail.com> <4651E866.5010304@drzeus.cx> <1179775695.3320.82.camel@lov.localdomain> <20070522103857.17bf1a3e@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522103857.17bf1a3e@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 10:38:57AM +0200, Cornelia Huck wrote:
> On Mon, 21 May 2007 21:28:15 +0200,
> Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > We could change the driver-core to suppress the creation of an attribute
> > if the attribute's show() or store() method returns something like
> > -ENOENT at registration time?
> > The driver would pass _all_ possible attributes of the device at
> > registration time, but the core would only create the attributes which
> > are implemented for this particular device? Would that work for you?
> > 
> > There are already subsystems who need to do similar things internally
> > (firewire), and it may be nice to add such functionality to the core.
> 
> This sounds a bit hackish (overloading the meaning of the show() and
> store() methods).

Firewire already does this today, it's actually really nice :)

> > You can assign any number of attribute groups to the device. If they
> > don't have a group name, they will all be created directly at the device
> > level. Would that work for you?
> 
> What about generic "conditional attribute groups"? Add a check() method
> which is called just before adding them, and only add them if check()
> returned 0 (or doesn't exist)?

People want this on a per-attribute basis, if you did it on a group
level, we would have a bunch of groups with only one attribute in it,
which would be messy.

thanks,

greg k-h
